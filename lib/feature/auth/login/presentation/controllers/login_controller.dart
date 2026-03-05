import '../../../../../../../core/exported_files/exported_file.dart';

class LoginController extends GetxController {
  final stService = STService();
  final firebaseAuthService = FirebaseAuthService();

  var isLoading = false.obs;
  var rememberMe = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadRememberedUser();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void gotoRegisterScreen() {
    Get.toNamed(AppRoutes.registrationScreen);
  }

  void gotoForgotPasswordScreen() {
      // Get.toNamed(AppRoutes.forgotPasswordScreen);
  }

  void _gotoHomeScreen() {
    DService().info("Navigating to Home Screen...");
    Get.offAllNamed(AppRoutes.mainBottomNavScreen);
  }

  void rememberMeChanged(bool? value) async {
    rememberMe.value = value ?? false;
    await stService.saveBool(AuthConstants.rememberButton, rememberMe.value);
    debugPrint("Remember Me: ${rememberMe.value}");
  }

  Future<void> _saveCredentials(String email, String password) async {
    if (rememberMe.value) {
      await stService.saveData(AuthConstants.savedEmail, email);
      await stService.saveData(AuthConstants.savedPassword, password);
      await stService.saveBool(AuthConstants.rememberButton, true);
    } else {
      await stService.removeData(AuthConstants.savedEmail);
      await stService.removeData(AuthConstants.savedPassword);
      await stService.saveBool(AuthConstants.rememberButton, false);
    }
  }

  Future<void> _loadRememberedUser() async {
    try {
      final savedRemember =
          stService.getBool(AuthConstants.rememberButton) ?? false;
      rememberMe.value = savedRemember;

      if (savedRemember) {
        final email = stService.getData(AuthConstants.savedEmail);
        final password = stService.getData(AuthConstants.savedPassword);

        if (email != null ) {
          emailController.text = email;
        }
        if (password != null) {
          passwordController.text = password;
        }
      }
    } catch (e) {
      // If there's a type mismatch, clear the corrupted data
      debugPrint("Error loading remembered user: $e");
      await stService.removeData(AuthConstants.savedEmail);
      await stService.removeData(AuthConstants.savedPassword);
      await stService.saveBool(AuthConstants.rememberButton, false);
      rememberMe.value = false;
    }
  }

  void _inputFieldIsEmpty() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (password.isEmpty || email.isEmpty) {
      DService().error("Please enter both Email and password");
      MessageHelper().showWarning(
        title: "Error",
        message: "Password fields cannot be empty",
      );
      return;
    }

    if (!InputValidator.isValidEmail(email)) {
      MessageHelper().showWarning(
        title: "Invalid Email",
        message: "Please enter a valid email address",
      );
      return;
    }

    if (password.length < 6) {
      MessageHelper().showWarning(
        title: "Weak Password",
        message: "Password must contain at least 6 characters",
      );
      return;
    }
    _login();
  }

  void loginUser() => _inputFieldIsEmpty();

  Future<void> _login() async {
    isLoading.value = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    DService().info("=== LOGIN STARTED ===");
    DService().info("Email: $email");

    try {
      // Call Firebase Auth Service
      DService().info("Calling Firebase Auth Service...");
      final result = await firebaseAuthService.loginWithEmailPassword(
        email: email,
        password: password,
      );

      DService().info("=== LOGIN RESULT ===");
      DService().info("Result: $result");
      print("===================== LOGIN RESULT =====================");
      print("Success: ${result['success']}");
      print("Message: ${result['message']}");
      print("User: ${result['user']}");
      print("========================================================");

      if (result['success']) {
        DService().info("Login successful! Processing...");

        // Save credentials if remember me is checked
        await _saveCredentials(email, password);
        DService().info("Credentials saved");

        // Save auth token/uid to storage
        await stService.saveData(
          AuthConstants.accessTokenKey,
          result['user'].uid,
        );
        DService().info("Token saved: ${result['user'].uid}");

        // Show success message
        MessageHelper().showAlert(
          title: "Success",
          message: result['message'],
        );
        DService().info("Success message shown");

        // Clear fields and navigate to home_flow
        _clearFields();
        DService().info("Fields cleared");

        _gotoHomeScreen();
        DService().info("Navigation called");
      } else {
        DService().error("Login failed: ${result['message']}");
        // Show error message
        MessageHelper().showWarning(
          title: "Login Failed",
          message: result['message'],
        );
      }
    } catch (e) {
      DService().error("=== LOGIN ERROR ===");
      DService().error("Error: $e");
      print("===================== LOGIN ERROR =====================");
      print("Error: $e");
      print("======================================================");

      MessageHelper().showWarning(
        title: "Error",
        message: "An unexpected error occurred. Please try again.",
      );
    } finally {
      isLoading.value = false;
      DService().info("=== LOGIN FINISHED ===");
    }
  }


}
