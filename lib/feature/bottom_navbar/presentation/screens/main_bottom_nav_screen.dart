import 'package:habit/feature/analytics_flow/presentation/screens/analytics_screen.dart';
import '../../../../../../../core/exported_files/exported_file.dart';
import '../../../home_flow/presentation/screens/home_screen.dart';
import '../../../settings/screens/settings_screen.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../screens/bottom_nav_bar.dart';

/// Main Home Screen with Bottom Navigation
class MainBottomNavScreen extends StatelessWidget {
  const MainBottomNavScreen({super.key});

  List<Widget> get screens => [
    HomeScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavBarController>();

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: BottomNavBar(
        onTabChanged: (index) {
          // Handle tab change if needed
        },
      ),
    );
  }
}
