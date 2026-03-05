import 'package:flutter/material.dart';

class ScreenConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  /// Base sizes (designed on iPhone X size)
  static const double baseWidth = 375.0;
  static const double baseHeight = 812.0;

  static double scaleWidth = 1.0;
  static double scaleHeight = 1.0;
  static double scaleText = 1.0;

  static bool isTablet = false;
  static bool isDesktop = false;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    final shortestSide = _mediaQueryData.size.shortestSide;

    /// Detect Device Type
    isTablet = shortestSide >= 600 && shortestSide < 1100;
    isDesktop = shortestSide >= 1100;

    /// Base scaling
    scaleWidth = screenWidth / baseWidth;
    scaleHeight = screenHeight / baseHeight;

    /// Average text scale
    scaleText = (scaleWidth + scaleHeight) / 2;

    /// Special Handling for Tablet
    if (isTablet) {
      scaleWidth *= 0.80;   // slightly reduce width scale (more natural UI)
      scaleHeight *= 0.85;
      scaleText *= 0.9;     // Tablet text slightly smaller
    }

    /// Special Handling for Desktop
    if (isDesktop) {
      scaleWidth = scaleWidth.clamp(1.2, 1.6);
      scaleHeight = scaleHeight.clamp(1.2, 1.6);
      scaleText = scaleText.clamp(1.0, 1.4);
    }

    /// Ensure minimum & max safety
    scaleWidth = scaleWidth.clamp(0.8, 2.0);
    scaleHeight = scaleHeight.clamp(0.8, 2.0);
    scaleText = scaleText.clamp(0.8, 2.0);
  }
}

/// Width extension (100.w)
extension ResponsiveWidth on num {
  double get w => this * ScreenConfig.scaleWidth;
}

/// Height extension (100.h)
extension ResponsiveHeight on num {
  double get h => this * ScreenConfig.scaleHeight;
}

/// Font size extension (16.sp)
extension ResponsiveFont on num {
  double get sp => this * ScreenConfig.scaleText;
}

/// Padding/Margin extensions
extension ResponsiveInsets on num {
  EdgeInsets get all => EdgeInsets.all(w);
  EdgeInsets get hP => EdgeInsets.symmetric(horizontal: w);
  EdgeInsets get vP => EdgeInsets.symmetric(vertical: h);
}
