import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/constants/category_icons.dart';

class AddCategoryDialog extends StatelessWidget {
  final Function(String name, String icon, String colorHex) onAdd;
  final RxString _name = ''.obs;
  final RxString _selectedIcon = 'favorite'.obs;
  final RxString _selectedColorHex = '#FF6B6B'.obs; // Default red color

  AddCategoryDialog({Key? key, required this.onAdd}) : super(key: key);

  final List<String> colorOptions = [
    '#FF6B6B', // Red
    '#4ECDC4', // Teal
    '#45B7D1', // Blue
    '#FFA07A', // Light Salmon
    '#98D8C8', // Mint
    '#F7DC6F', // Yellow
    '#BB8FCE', // Purple
    '#85C1E2', // Light Blue
    '#E74C3C', // Crimson
    '#3498DB', // Dodger Blue
    '#2ECC71', // Emerald
    '#F39C12', // Orange
    '#9B59B6', // Amethyst
    '#1ABC9C', // Turquoise
    '#E67E22', // Carrot
    '#16A085', // Green Sea
  ];

  void _handleAdd(BuildContext context) {
    if (_name.value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    onAdd(_name.value.trim(), _selectedIcon.value, _selectedColorHex.value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Add New Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onMainColor,
                ),
              ),
              const SizedBox(height: 20),

              // Category Name Field
              Text(
                'Category Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onMainColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => _name.value = value,
                style: TextStyle(color: AppColors.onMainColor),
                decoration: InputDecoration(
                  hintText: 'e.g., Hobby, Travel, Health',
                  hintStyle: TextStyle(color: AppColors.onMainSecondary),
                  filled: true,
                  fillColor: AppColors.inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Icon Selection
              Text(
                'Select Icon',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onMainColor,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: Obx(
                  () => ListView(
                    scrollDirection: Axis.horizontal,
                    children: CategoryIcons.getIconsList().map((entry) {
                      final isSelected = _selectedIcon.value == entry.key;
                      return GestureDetector(
                        onTap: () {
                          _selectedIcon.value = entry.key;
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withValues(alpha: 0.3)
                                : AppColors.inputFillColor,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : AppColors.borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              entry.value,
                              color: AppColors.onMainColor,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Color Selection
              Text(
                'Select Color',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onMainColor,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: colorOptions.map((colorHex) {
                    final isSelected = _selectedColorHex.value == colorHex;
                    final color = Color(
                      int.parse(colorHex.replaceFirst('#', '0xff')),
                    );

                    return GestureDetector(
                      onTap: () {
                        _selectedColorHex.value = colorHex;
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.white
                                : Colors.transparent,
                            width: isSelected ? 3 : 0,
                          ),
                        ),
                        child: isSelected
                            ? const Center(
                                child: Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.inActiveColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _handleAdd(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
