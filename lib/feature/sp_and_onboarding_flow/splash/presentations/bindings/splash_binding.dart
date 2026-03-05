import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/splash_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
