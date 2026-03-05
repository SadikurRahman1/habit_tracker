import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnalyticsController());
  }
}
