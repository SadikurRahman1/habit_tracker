import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}

