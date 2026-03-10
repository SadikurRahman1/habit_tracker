import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:uuid/uuid.dart';
import 'package:habit/core/models/category_model.dart';

class CategoryController extends GetxController {
  final _storage = GetStorage();
  static const String _categoriesKey = 'app_categories';

  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  // Load categories from storage
  void loadCategories() {
    try {
      isLoading.value = true;
      final saved = _storage.read(_categoriesKey);

      if (saved != null && saved is List && saved.isNotEmpty) {
        final categoryList = saved
            .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
        categories.assignAll(categoryList);
      } else {
        // Initialize default categories if none exist
        _initializeDefaultCategories();
      }
    } catch (e) {
      print('Error loading categories: $e');
      _initializeDefaultCategories();
    } finally {
      isLoading.value = false;
    }
  }

  // Initialize default categories
  void _initializeDefaultCategories() {
    final defaultCategories = [
      CategoryModel(
        id: const Uuid().v4(),
        name: 'Health',
        icon: 'health_and_safety',
        colorHex: '#2ECC71',
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: 'Work',
        icon: 'work',
        colorHex: '#3498DB',
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: 'Exercise',
        icon: 'fitness_center',
        colorHex: '#E74C3C',
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: 'Learning',
        icon: 'book',
        colorHex: '#9B59B6',
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: 'Personal',
        icon: 'favorite',
        colorHex: '#FF6B6B',
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: 'Sleep',
        icon: 'sleep',
        colorHex: '#45B7D1',
      ),
    ];

    categories.assignAll(defaultCategories);
    _saveCategories();
  }

  // Add new category
  void addCategory({
    required String name,
    required String icon,
    required String colorHex,
  }) {
    if (name.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a category name',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return;
    }

    // Check if category name already exists
    if (categories.any((cat) => cat.name.toLowerCase() == name.toLowerCase())) {
      Get.snackbar(
        'Error',
        'Category "$name" already exists',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return;
    }

    final newCategory = CategoryModel(
      id: const Uuid().v4(),
      name: name.trim(),
      icon: icon,
      colorHex: colorHex,
    );

    categories.add(newCategory);
    _saveCategories();

    Get.snackbar(
      'Success',
      'Category "$name" added successfully',
      snackPosition: SnackPosition.TOP,
      colorText: AppColors.white,
      backgroundColor: AppColors.success,
    );
  }

  // Remove category
  void removeCategory(String categoryId) {
    categories.removeWhere((cat) => cat.id == categoryId);
    _saveCategories();
  }

  // Update category
  void updateCategory({
    required String categoryId,
    required String name,
    required String icon,
    required String colorHex,
  }) {
    final index = categories.indexWhere((cat) => cat.id == categoryId);

    if (index != -1) {
      categories[index] = CategoryModel(
        id: categoryId,
        name: name.trim(),
        icon: icon,
        colorHex: colorHex,
      );
      _saveCategories();

      Get.snackbar(
        'Success',
        'Category updated successfully',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.success,
      );
    }
  }

  // Save categories to storage
  void _saveCategories() {
    final jsonList = categories.map((cat) => cat.toJson()).toList();
    _storage.write(_categoriesKey, jsonList);
  }

  // Get category by id
  CategoryModel? getCategoryById(String id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Check if category name exists
  bool categoryNameExists(String name, {String? excludeId}) {
    return categories.any(
      (cat) =>
          cat.name.toLowerCase() == name.toLowerCase() && cat.id != excludeId,
    );
  }
}
