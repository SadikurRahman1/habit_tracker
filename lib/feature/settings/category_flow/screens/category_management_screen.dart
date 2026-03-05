import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../controllers/category_controller.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/category_grid_item.dart';
import '../widgets/delete_category_dialog.dart';
import '../widgets/empty_category_state.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  void _showAddCategoryDialog(BuildContext context) {
    final controller = Get.find<CategoryController>();
    
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        onAdd: (name, icon, colorHex) {
          controller.addCategory(
            name: name,
            icon: icon,
            colorHex: colorHex,
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String categoryId, String categoryName) {
    final controller = Get.find<CategoryController>();
    
    Get.dialog(
      DeleteCategoryDialog(
        categoryName: categoryName,
        onDelete: () {
          controller.removeCategory(categoryId);
          Get.snackbar(
            'Success',
            'Category "$categoryName" deleted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        title: const Text(
          'Manage Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => controller.categories.isEmpty
            ? const EmptyCategoryState()
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  
                  return CategoryGridItem(
                    category: category,
                    onLongPress: () => _showDeleteDialog(
                      context,
                      category.id,
                      category.name,
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Category',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
