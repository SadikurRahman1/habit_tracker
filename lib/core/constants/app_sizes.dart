import 'package:flutter/material.dart';

class AppSizes {
  static late MediaQueryData _mediaQueryData;
  static late double width;
  static late double height;
  static late Orientation orientation;
  static late bool isTablet;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    isTablet = width > 600;
  }

  double screenHeight() => AppSizes.height;
  double screenWidth() => AppSizes.width;
}

double screenHeight() => AppSizes.height;
double screenWidth() => AppSizes.width;

double getHeight(double inputHeight, {double? minHeight, double? maxHeight}) {
  double screenHeight = AppSizes.height;

  double factor = AppSizes.isTablet ? 1.2 : 1.0;

  var percent = ((screenHeight / 100) * inputHeight) / screenHeight;
  double calculatedHeight = ((screenHeight * percent) / 10) * factor;

  if (minHeight != null && calculatedHeight < minHeight) {
    return minHeight;
  } else if (maxHeight != null && calculatedHeight > maxHeight) {
    return maxHeight;
  }
  return calculatedHeight;
}

double getWidth(double inputWidth, {double? minWidth, double? maxWidth}) {
  double screenWidth = AppSizes.width;
  double factor = AppSizes.isTablet ? 1.2 : 1.0;

  double calculatedWidth = ((inputWidth / 430) * screenWidth) * factor;

  // Default +8 max if not provided
  double effectiveMaxWidth = maxWidth ?? (inputWidth + 8);

  if (minWidth != null && calculatedWidth < minWidth) {
    return minWidth;
  } else if (calculatedWidth > effectiveMaxWidth) {
    return effectiveMaxWidth;
  }
  return calculatedWidth;
}
