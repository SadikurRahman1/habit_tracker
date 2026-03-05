import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final VoidCallback? onTap;
  final Color? color;

  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.child,
    this.alignment,
    this.constraints,
    this.onTap,
    this.color,
  });

  // ---------- Responsive Padding ----------
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

  // ---------- Responsive Margin ----------
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
    Widget container = Container(
      width: width?.w,
      height: height?.h,
      padding: _responsivePadding(padding),
      margin: _responsiveMargin(margin),
      alignment: alignment,
      constraints: constraints,
      color: color,
      child: child,
    );

    if (onTap != null) {
      return container.onTap(onTap);
    }
    return container;
  }
}
