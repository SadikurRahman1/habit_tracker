
import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveSpace extends StatelessWidget {
  final double value;

  const ResponsiveSpace(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<Flex>();

    if (parent == null) {
      return SizedBox(
        width: value.w,
        height: value.h,
      );
    }

    if (parent.direction == Axis.horizontal) {
      // Row বা Horizontal Flex → width responsive
      return SizedBox(width: value.w);
    } else {
      // Column বা Vertical Flex → height responsive
      return SizedBox(height: value.h);
    }
  }
}
