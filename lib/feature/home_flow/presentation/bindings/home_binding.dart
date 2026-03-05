import '../../../../core/exported_files/exported_file.dart';
import '../controllers/home_controller.dart';
import '../controllers/timer_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TimerController());
  }
}
