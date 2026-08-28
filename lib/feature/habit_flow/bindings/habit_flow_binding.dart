import 'package:get/get.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';
import '../controllers/habit_controller.dart';

class HabitFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HabitController>(() => HabitController());
    Get.lazyPut(() => CategoryController());
  }
}
