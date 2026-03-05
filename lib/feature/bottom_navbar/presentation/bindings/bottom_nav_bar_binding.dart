import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

import '../../../../../../../core/exported_files/exported_file.dart';
import '../../../habit_flow/controllers/habit_controller.dart';
import '../../../home_flow/presentation/controllers/home_controller.dart';
import '../../../home_flow/presentation/controllers/timer_controller.dart';
import '../../../settings/controllers/settings_controller.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavBarController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => HabitController());
    Get.lazyPut(() => TimerController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => SettingsController());
  }
}

