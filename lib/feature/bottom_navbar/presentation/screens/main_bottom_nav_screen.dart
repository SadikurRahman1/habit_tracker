import 'package:habit/feature/analytics_flow/presentation/screens/analytics_screen.dart';
import '../../../../../../../core/exported_files/exported_file.dart';
import '../../../home_flow/presentation/screens/home_screen.dart';
import '../../../settings/screens/settings_screen.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../screens/bottom_nav_bar.dart';

/// Main Home Screen with Bottom Navigation
class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  late final BottomNavBarController controller;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BottomNavBarController>();
    // Initialize ChatBinding for ChatListScreen
    screens = [HomeScreen(), const AnalyticsScreen(), const SettingsScreen()];
  }

  @override
  Widget build(BuildContext context) {
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
