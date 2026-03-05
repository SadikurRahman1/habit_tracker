import 'package:flutter/material.dart';

extension WidgetPaddingExtension on Widget {
  Widget p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget px(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Widget py(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  Widget p8() => p(8);
  Widget p16() => p(16);
  Widget p24() => p(24);
}

extension WidgetAlignExtension on Widget {
  Widget center() => Center(child: this);
  Widget align(Alignment alignment) =>
      Align(alignment: alignment, child: this);
}

extension WidgetVisibilityExtension on Widget {
  Widget hide(bool isVisible) =>
      isVisible ? this : const SizedBox.shrink();
}

extension WidgetCornerExtension on Widget {
  Widget corner(double radius) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: this,
  );
}
extension WidgetTapExtension on Widget {
  Widget onTap(VoidCallback? onTap) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: this,
  );
}
