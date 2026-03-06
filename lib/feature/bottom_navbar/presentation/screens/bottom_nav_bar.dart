import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  BottomNavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

class BottomNavBar extends StatelessWidget {
  final Function(int) onTabChanged;

  const BottomNavBar({
    super.key,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavBarController>();

    final items = [
      BottomNavItem(
        activeIcon: Icons.home,
        inactiveIcon: Icons.home,
        label: 'Home',
      ),
      BottomNavItem(
        activeIcon: Icons.align_vertical_bottom,
        inactiveIcon: Icons.align_vertical_bottom,
        label: 'Analytics',
      ),
      BottomNavItem(
        activeIcon: Icons.settings,
        inactiveIcon: Icons.settings,
        label: 'Settings',
      ),
    ];

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.mainColor,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.inActiveColor,
          currentIndex: controller.selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            controller.onTabChanged(index);
            onTabChanged(index);
          },
          items: List.generate(
            items.length,
            (index) => BottomNavigationBarItem(
              icon: ResponsiveIcon(
                icon: items[index].inactiveIcon,
                size: 24,
                color: AppColors.inActiveColor,
              ),
              activeIcon: ResponsiveIcon(
                icon: items[index].activeIcon,
                size: 24,
                color: AppColors.primary,
              ),
              label: items[index].label,
            ),
          ),
        ),
      ),
    );
  }
}

