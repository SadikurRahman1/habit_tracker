
import '../core/app_routes/app_pages.dart';
import '../core/exported_files/exported_file.dart';

class Habit extends StatelessWidget {
  const Habit({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
      ),
      // translations: AppTranslation(), // Your GetX translations
      // locale: savedLocale, // ✅ apply saved locale
      // fallbackLocale: const Locale(
      //   'en',
      //   'US',
      // ), // fallback if saved locale missing
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.appPages(),  
    );
  }
}
