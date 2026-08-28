import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();

    return Scaffold(
      backgroundColor: AppColors.mainColor,

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(),
            Center(child: Image.asset(ImagePath.logo, fit: BoxFit.fill, width: 200, height: 200)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
