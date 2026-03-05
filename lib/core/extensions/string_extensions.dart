extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";

  /// Convert to title case
  String toTitleCase() => split(" ")
      .map((word) => word.isEmpty
      ? word
      : "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}")
      .join(" ");

  /// Check valid email
  bool isValidEmail() => RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
  ).hasMatch(this);

  /// Convert String → int safely
  int toInt() => int.tryParse(this) ?? 0;

  /// Convert String → double safely
  double toDouble() => double.tryParse(this) ?? 0.0;

  /// Is numeric?
  bool get isNumeric => double.tryParse(this) != null;
}
