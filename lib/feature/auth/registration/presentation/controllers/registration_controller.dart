import '../../../../../../../core/exported_files/exported_file.dart';

class RegistrationController extends GetxController {
  final stService = STService();
  final firebaseAuthService = FirebaseAuthService();

  var isLoading = false.obs;
  final agreeToTerms = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void _clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    agreeToTerms.value = false;
  }

  void gotoLoginScreen() {
    Get.back();
  }

  void _gotoHomeScreen() {
    Get.offAllNamed(AppRoutes.mainBottomNavScreen);
  }

  void agreeToTermsChanged(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  void _validateFields() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      MessageHelper().showWarning(
        title: "Error",
        message: "All fields are required",
      );
      return;
    }

    if (name.length < 3) {
      MessageHelper().showWarning(
        title: "Invalid Name",
        message: "Name must contain at least 3 characters",
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

    if (password != confirmPassword) {
      MessageHelper().showWarning(
        title: "Password Mismatch",
        message: "Passwords do not match",
      );
      return;
    }

    _register();
  }

  void registerUser() => _validateFields();

  Future<void> _register() async {
    isLoading.value = true;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    DService().info("=== REGISTRATION STARTED ===");
    DService().info("Name: $name");
    DService().info("Email: $email");

    try {
      // Call Firebase Auth Service
      DService().info("Calling Firebase Auth Service...");
      final result = await firebaseAuthService.registerWithEmailPassword(
        email: email,
        password: password,
        name: name,
      );

      DService().info("=== REGISTRATION RESULT ===");
      DService().info("Result: $result");
      print("=================== REGISTRATION RESULT ===================");
      print("Success: ${result['success']}");
      print("Message: ${result['message']}");
      print("User: ${result['user']}");
      print("===========================================================");

      if (result['success']) {
        DService().info("Registration successful! Processing...");

        // Save auth token/uid to storage
        await stService.saveData(
          AuthConstants.accessTokenKey,
          result['user'].uid,
        );
        DService().info("Token saved: ${result['user'].uid}");

        // Mark onboarding as completed
        await stService.saveData(AuthConstants.onboardingCompletedKey, 'true');
        DService().info("Onboarding marked as completed");

        // Show success message
        MessageHelper().showAlert(title: "Success", message: result['message']);
        DService().info("Success message shown");

        // Clear fields and navigate to home_flow
        _clearFields();
        DService().info("Fields cleared");

        _gotoHomeScreen();
        DService().info("Navigation to home_flow called");
      } else {
        DService().error("Registration failed: ${result['message']}");
        print("=================== REGISTRATION FAILED ===================");
        print("Message: ${result['message']}");
        print("===========================================================");

        // Show error message
        MessageHelper().showWarning(
          title: "Registration Failed",
          message: result['message'],
        );
      }
    } catch (e) {
      DService().error("=== REGISTRATION ERROR ===");
      DService().error("Error: $e");
      print("=================== REGISTRATION ERROR ===================");
      print("Error: $e");
      print("==========================================================");

      MessageHelper().showWarning(
        title: "Error",
        message: "An unexpected error occurred. Please try again.",
      );
    } finally {
      isLoading.value = false;
      DService().info("=== REGISTRATION FINISHED ===");
    }
  }
}
