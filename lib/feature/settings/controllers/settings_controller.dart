import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  static const String _themeKey = 'theme_mode';

  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    // Load theme mode
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(_themeKey, isDarkMode.value ? 'dark' : 'light');
  }
}

