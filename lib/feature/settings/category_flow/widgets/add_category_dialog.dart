import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/constants/category_icons.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(String name, String icon, String colorHex) onAdd;

  const AddCategoryDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final nameController = TextEditingController();
  String selectedIcon = 'favorite';
  String selectedColorHex = '#FF6B6B'; // Default red color

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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onAdd(nameController.text, selectedIcon, selectedColorHex);
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
                controller: nameController,
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: CategoryIcons.getIconsList().map((entry) {
                    final isSelected = selectedIcon == entry.key;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = entry.key;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.3)
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
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colorOptions.map((colorHex) {
                  final isSelected = selectedColorHex == colorHex;
                  final color = Color(
                    int.parse(colorHex.replaceFirst('#', '0xff')),
                  );

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorHex = colorHex;
                      });
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
                    onPressed: _handleAdd,
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
