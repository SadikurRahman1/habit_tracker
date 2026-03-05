import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../exported_files/exported_file.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<Map<String, dynamic>> registerWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user account
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      DService().info(
        "Firebase Auth account created! User ID: ${userCredential.user!.uid}",
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);
      DService().info("Display name updated");

      // Try to save user data to Firestore (optional - won't fail if Firestore not setup)
      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'photoUrl': '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastSeen': FieldValue.serverTimestamp(),
          'isOnline': true,
          'bio': 'Hey there! I am using Message app',
        });

        await userCredential.user!.sendEmailVerification();

        DService().info("Firestore user profile created");
      } catch (firestoreError) {
        DService().warning(
          "Firestore save failed (database may not exist): $firestoreError",
        );
        // Continue anyway - registration was successful even if Firestore save failed
      }

      DService().info("Registration successful!");

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Registration successful',
      };
    } on FirebaseAuthException catch (e) {
      DService().error("Firebase Auth Error: ${e.code}");
      String errorMessage = _getAuthErrorMessage(e.code);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      DService().error("Registration Error: $e");
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Login with email and password
  Future<Map<String, dynamic>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DService().info(
        "Firebase Auth successful! User ID: ${userCredential.user!.uid}",
      );
      DService().info("===============: ${userCredential.user}");
      DService().info("===============: ${userCredential.user!.refreshToken}");
      DService().info("===============: ${userCredential.user!.phoneNumber}");
      DService().info("===============: ${userCredential.user!.phoneNumber}");
      DService().info("===============: ${userCredential.user!.photoURL}");

      // Try to update user online status (optional - won't fail if Firestore not setup)
      // try {
      //   await _firestore.collection('users').doc(userCredential.user!.uid).update({
      //     'isOnline': true,
      //     'lastSeen': FieldValue.serverTimestamp(),
      //   });
      //   DService().info("Firestore status updated");
      // } catch (firestoreError) {
      //   DService().warning("Firestore update failed (database may not exist): $firestoreError");
      //   // Continue anyway - login was successful even if Firestore update failed
      // }

      User? user = FirebaseAuth.instance.currentUser;

      await user?.reload(); // refresh user data
      user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
        print("Email Verified ✅");
      } else {
        await FirebaseAuth.instance.signOut();
      }
      DService().info("Login successful!");

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Login successful',
      };
    } on FirebaseAuthException catch (e) {
      DService().error("Firebase Auth Error: ${e.code}");
      String errorMessage = _getAuthErrorMessage(e.code);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      DService().error("Login Error: $e");
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (currentUserId != null) {
        // Update user offline status
        await _firestore.collection('users').doc(currentUserId).update({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
      await _auth.signOut();
      DService().info("Logout successful!");
    } catch (e) {
      DService().error("Logout Error: $e");
    }
  }

  // Send password reset email
  Future<Map<String, dynamic>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent successfully',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getAuthErrorMessage(e.code);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      if (currentUserId != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(currentUserId).delete();
        // Delete user account
        await currentUser?.delete();
      }
      return {'success': true, 'message': 'Account deleted successfully'};
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getAuthErrorMessage(e.code);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Get user data from Firestore
  Future<DocumentSnapshot?> getUserData(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      DService().error("Get User Data Error: $e");
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
      return true;
    } catch (e) {
      DService().error("Update User Data Error: $e");
      return false;
    }
  }

  // Convert Firebase error codes to user-friendly messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'requires-recent-login':
        return 'Please login again to perform this action.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
