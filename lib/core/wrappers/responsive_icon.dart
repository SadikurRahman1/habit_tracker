import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ResponsiveIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: _responsivePadding(padding),
        margin: _responsiveMargin(margin),
        child: Icon(
          icon,
          size: size?.w ?? 24.w, // responsive icon size
          color: color,
        ),
      ),
    );
  }
}
