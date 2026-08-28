import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../feature/settings/controllers/settings_controller.dart';

class AppColors {
  // ⚪️ Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // 🟢 Success & 🛑 Error
  static const Color success = Color(0xFF4CAF50); // green
  static const Color danger = Color(0xFFF44336); // red
  static const Color warning = Color(0xFFFFC107); // amber / yellow

  // 🔵 Primary / Secondary
  static const Color primary = Color(0xFF1976D2); // blue
  static const Color primaryLight = Color(0xFF63A4FF);
  static const Color primaryDark = Color(0xFF004BA0);

  static const Color secondary = Color(0xFFFF5722); // deep orange
  static const Color secondaryLight = Color(0xFFFF8A50);
  static const Color secondaryDark = Color(0xFFBF360C);

  // ⚪️ Grayscale
  static const Color gray = Color(0xFF6B6B6B);
  static const Color lightGray = Color(0xFFBDBDBD);
  static const Color extraLightGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF424242);

  // 🟠 Others
  static const Color orange = Color(0xFFFF6200);
  static const Color pink = Color(0xFFE91E63);
  static const Color purple = Color(0xFF7953FF);
  static const Color teal = Color(0xFF009688);
  static const Color blueGray = Color(0xFF607D8B);

  // 🌟 Theme Palettes
  static const Color darkBgColor = Color(0xFF030712);
  static const Color darkMainColor = Color(0xFF111829);
  static const Color darkBorderColor = Color(0xFF1E2939);
  static const Color darkInActiveColor = Color(0xFF99A1AF);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFCBD5E1);

  static const Color lightBgColor = Color(0xFFF8FAFC);
  static const Color lightMainColor = Color(0xFFFFFFFF);
  static const Color lightBorderColor = Color(0xFFE2E8F0);
  static const Color lightInActiveColor = Color(0xFF64748B);
  static const Color lightPrimaryText = Color(0xFF0F172A);
  static const Color lightSecondaryText = Color(0xFF475569);

  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x33000000);

  // 📝 Text Colors (Theme-aware)
  static Color get primaryText =>
      isDarkMode ? darkPrimaryText : lightPrimaryText;
  static Color get secondaryText =>
      isDarkMode ? darkSecondaryText : lightSecondaryText;

  static const Color blackText = Color(0xFF2D2D2D);
  static const Color disabledText = Color(0xFFBDBDBD);

  // 🔔 Notification / Accent
  static const Color info = Color(0xFF2196F3); // blue
  static const Color accent = Color(0xFFFF4081);

  static bool get isDarkMode {
    try {
      // Try to get from SettingsController first for instant updates
      if (Get.isRegistered<SettingsController>()) {
        return Get.find<SettingsController>().isDarkMode.value;
      }
    } catch (_) {
      // Controller not found, fall back to Get.isDarkMode
    }
    return Get.isDarkMode;
  }

  static Color get bgColor => isDarkMode ? darkBgColor : lightBgColor;
  static Color get mainColor => isDarkMode ? darkMainColor : lightMainColor;
  static Color get borderColor =>
      isDarkMode ? darkBorderColor : lightBorderColor;
  static Color get inActiveColor =>
      isDarkMode ? darkInActiveColor : lightInActiveColor;

  static Color get onMainColor =>
      isDarkMode ? darkPrimaryText : lightPrimaryText;
  static Color get onMainSecondary =>
      isDarkMode ? darkSecondaryText : lightSecondaryText;

  static Color get overlayColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.black.withValues(alpha: 0.04);
  static Color get weakOverlayColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.black.withValues(alpha: 0.08);
  static Color get handleColor => isDarkMode ? Colors.white24 : Colors.black26;
  static Color get inputFillColor =>
      isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.04);
}
