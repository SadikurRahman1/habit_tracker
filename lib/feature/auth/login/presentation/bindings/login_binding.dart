import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => LoginController(),);
    Get.lazyPut(() => LoginController(), fenix: true);
  }
}
