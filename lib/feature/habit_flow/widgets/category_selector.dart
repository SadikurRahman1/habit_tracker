import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/constants/category_icons.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

  void _showCategoryBottomSheet(BuildContext context) {
    final controller = Get.find<CategoryController>();
    final isNoCategorySelected =
        selectedCategoryId == null || selectedCategoryId!.trim().isEmpty;

    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.72,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.handleColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onMainColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: GestureDetector(
                  onTap: () {
                    onCategorySelected('');
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.overlayColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isNoCategorySelected
                            ? Colors.blue
                            : AppColors.borderColor,
                        width: isNoCategorySelected ? 2 : 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.block,
                          color: isNoCategorySelected
                              ? Colors.blue
                              : AppColors.onMainSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'No Category (Optional)',
                            style: TextStyle(
                              color: isNoCategorySelected
                                  ? Colors.blue
                                  : AppColors.onMainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isNoCategorySelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Categories Grid
              Expanded(
                child: Obx(
                  () => controller.categories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                color: AppColors.onMainSecondary,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No categories available',
                                style: TextStyle(
                                  color: AppColors.onMainSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 3.0,
                              ),
                          itemCount: controller.categories.length,
                          itemBuilder: (context, index) {
                            final category = controller.categories[index];
                            final isSelected =
                                selectedCategoryId == category.id;
                            final color = category.getColor();
                            final icon = CategoryIcons.getIcon(category.icon);

                            return GestureDetector(
                              onTap: () {
                                onCategorySelected(category.id);
                                Get.back();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : color.withOpacity(0.5),
                                    width: isSelected ? 3 : 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          icon,
                                          color: color,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: color,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(height: 4),
                                      Icon(
                                        Icons.check_circle,
                                        color: color,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
              // Close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final selectedCategory =
        selectedCategoryId != null && selectedCategoryId!.trim().isNotEmpty
        ? categoryController.getCategoryById(selectedCategoryId!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showCategoryBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.inputFillColor,
              border: Border.all(
                color: selectedCategory != null
                    ? Colors.blue
                    : AppColors.borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedCategory != null) ...[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: selectedCategory.getColor().withValues(
                            alpha: .2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            CategoryIcons.getIcon(selectedCategory.icon),
                            color: selectedCategory.getColor(),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedCategory.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: selectedCategory.getColor(),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'No category selected',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.secondaryText,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
