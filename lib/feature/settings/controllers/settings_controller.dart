import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  static const String _themeKey = 'theme_mode';

  final isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
    }

    _applyTheme();
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme([bool? value]) {
    isDarkMode.value = value ?? !isDarkMode.value;
    _storage.write(_themeKey, isDarkMode.value ? 'dark' : 'light');
    _applyTheme();
  }
}
