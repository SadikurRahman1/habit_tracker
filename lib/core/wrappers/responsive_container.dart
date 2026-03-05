import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final VoidCallback? onTap;
  final Color? color;

  const ResponsiveContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.child,
    this.alignment,
    this.constraints,
    this.onTap,
    this.color,
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
        width: width?.w,
        height: height?.h,
        padding: _responsivePadding(padding),
        margin: _responsiveMargin(margin),
        decoration: decoration,
        alignment: alignment,
        constraints: constraints,
        color: decoration == null ? color : null,
        child: child,
      ),
    );
  }
}
