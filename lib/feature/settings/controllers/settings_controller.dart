import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  static const String _themeKey = 'theme_mode';
  static const String _customCategoriesKey = 'custom_categories';

  final isDarkMode = false.obs;
  final customCategories = <String>[].obs;

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

    // Load custom categories
    final saved = _storage.read(_customCategoriesKey);
    if (saved != null && saved is List) {
      customCategories.assignAll(List<String>.from(saved));
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(_themeKey, isDarkMode.value ? 'dark' : 'light');
  }

  void addCustomCategory(String categoryName) {
    if (categoryName.isNotEmpty && !customCategories.contains(categoryName)) {
      customCategories.add(categoryName);
      _storage.write(_customCategoriesKey, customCategories.toList());
    }
  }

  void removeCustomCategory(String categoryName) {
    customCategories.remove(categoryName);
    _storage.write(_customCategoriesKey, customCategories.toList());
  }

  List<String> getAllCategories() {
    // Combine built-in and custom categories
    List<String> all = [
      'Health',
      'Work',
      'Exercise',
      'Learning',
      'Personal',
      'Other',
    ];
    all.addAll(customCategories);
    return all;
  }
}
