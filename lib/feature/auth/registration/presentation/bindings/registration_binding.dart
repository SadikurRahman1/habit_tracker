


import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/registration_controller.dart';

class RegistrationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationController());

  }
}
