import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveGridView extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double heightFactor;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final IndexedWidgetBuilder itemBuilder;

  const  ResponsiveGridView({
    super.key,
    required this.itemCount,
    required this.crossAxisCount,
    required this.itemBuilder,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.heightFactor = 1.25,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  EdgeInsetsGeometry _responsivePadding(EdgeInsetsGeometry? padding) {
    if (padding is EdgeInsets) {
      return EdgeInsets.only(
        left: padding.left.w,
        right: padding.right.w,
        top: padding.top.h,
        bottom: padding.bottom.h,
      );
    }
    return padding ?? EdgeInsets.zero;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double itemWidth = (width - (crossAxisSpacing.w * (crossAxisCount - 1))) / crossAxisCount;
        double itemHeight = itemWidth * heightFactor;
        double aspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          itemCount: itemCount,
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: _responsivePadding(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing.w,
            mainAxisSpacing: mainAxisSpacing.h,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
