
import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final double? size;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ResponsiveCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.size,
    this.shape,
    this.padding,
    this.margin,
  });

  EdgeInsetsGeometry? _responsivePadding(EdgeInsetsGeometry? padding) {
    if (padding is EdgeInsets) {
      return EdgeInsets.only(
        left: padding.left.w,
        right: padding.right.w,
        top: padding.top.h,
        bottom: padding.bottom.h,
      );
    }
    return padding;
  }

  EdgeInsetsGeometry? _responsiveMargin(EdgeInsetsGeometry? margin) {
    if (margin is EdgeInsets) {
      return EdgeInsets.only(
        left: margin.left.w,
        right: margin.right.w,
        top: margin.top.h,
        bottom: margin.bottom.h,
      );
    }
    return margin;
  }

  @override
  Widget build(BuildContext context) {
    final double checkboxSize = size?.w ?? 24.w;
    return Container(
      padding: _responsivePadding(padding),
      margin: _responsiveMargin(margin),
      width: checkboxSize,
      height: checkboxSize,
      child: Transform.scale(
        scale: checkboxSize / 24.w,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor ?? AppColors.primary,
          checkColor: checkColor ?? Colors.white,
          shape: shape ??
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.w)),
        ),
      ),
    );
  }
}
