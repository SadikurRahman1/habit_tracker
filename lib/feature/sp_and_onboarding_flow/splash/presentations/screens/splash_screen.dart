import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();

    return Scaffold(
      backgroundColor: AppColors.mainColor,

      body: CommonBody(
        widget: Column(
          children: [
            const Spacer(),
            ResponsiveImage(path: ImagePath.profile, fit: BoxFit.fill, size: 200, ),
            const Spacer(),
            const CircleLoader(),
          ],
        ),
      ),
    );
  }
}
