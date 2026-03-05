import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../../core/exported_files/exported_file.dart'; // responsive extensions

class CircleLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CircleLoader({
    super.key,
    this.color = AppColors.mainColor,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      color: color,
      size: size.w,
    );
  }
}
