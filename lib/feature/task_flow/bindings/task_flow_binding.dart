import 'package:get/get.dart';
import 'package:habit/feature/habit_flow/controllers/habit_controller.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

class TaskFlowBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HabitController>()) {
      Get.lazyPut(() => HabitController());
    }
    if (!Get.isRegistered<CategoryController>()) {
      Get.lazyPut(() => CategoryController());
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut(() => HomeController());
    }
  }
}
