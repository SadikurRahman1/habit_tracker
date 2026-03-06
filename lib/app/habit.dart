import '../core/app_routes/app_pages.dart';
import '../core/exported_files/exported_file.dart';
import '../feature/settings/controllers/settings_controller.dart';

class Habit extends StatelessWidget {
  const Habit({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBgColor,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightMainColor,
        foregroundColor: AppColors.darkPrimaryText,
        elevation: 0,
      ),
      cardColor: AppColors.lightMainColor,
      dividerColor: AppColors.lightBorderColor,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.lightInActiveColor,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBgColor,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkMainColor,
        foregroundColor: AppColors.darkPrimaryText,
        elevation: 0,
      ),
      cardColor: AppColors.darkMainColor,
      dividerColor: AppColors.darkBorderColor,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.darkInActiveColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController(), permanent: true);

    ScreenConfig.init(context);
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: settingsController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: AppRoutes.splashScreen,
        getPages: AppPages.appPages(),
      ),
    );
  }
}
