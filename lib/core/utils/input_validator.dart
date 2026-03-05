class InputValidator {
  // ============================
  // 📧 Email Validation
  // ============================
  static final RegExp _emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return "Email cannot be empty";
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return "Please enter a valid email address";
    }
    return null; // ✅ Valid
  }

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());

  // ============================
  // 📞 Phone Number Validation (International)
  // ============================
  /// Supports international formats like:
  /// +8801712345678, +1-202-555-0123, 01712345678, 2025550123 etc.
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[0-9]{6,15}$', // 6 to 15 digits, optional +
  );

  static String? validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return "Phone number cannot be empty";
    }
    if (!_phoneRegex.hasMatch(phone.trim())) {
      return "Please enter a valid phone number";
    }
    return null; // ✅ Valid
  }

  static bool isValidPhone(String phone) => _phoneRegex.hasMatch(phone.trim());

  // ============================
  // 🔐 Password Validation
  // ============================
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  static String? validatePassword(String password) {
    if (password.trim().isEmpty) {
      return "Password cannot be empty";
    }
    if (!_passwordRegex.hasMatch(password.trim())) {
      return "Password must be at least 8 characters long,\ninclude uppercase, lowercase, number and special character.";
    }
    return null; // ✅ Valid
  }

  static bool isValidPassword(String password) =>
      _passwordRegex.hasMatch(password.trim());
}
