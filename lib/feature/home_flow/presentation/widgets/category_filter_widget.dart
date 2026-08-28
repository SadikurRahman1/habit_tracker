import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/models/category_model.dart';

class CategoryFilterWidget extends StatelessWidget {
  final String? selectedCategoryId;
  final List<CategoryModel> categories;
  final Function(String?) onCategorySelected;

  const CategoryFilterWidget({
    Key? key,
    required this.selectedCategoryId,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                'All',
                style: TextStyle(
                  color: selectedCategoryId == null
                      ? AppColors.white
                      : AppColors.primaryText,
                  fontWeight: selectedCategoryId == null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: selectedCategoryId == null,
              onSelected: (_) => onCategorySelected(null),
              backgroundColor: AppColors.overlayColor,
              selectedColor: AppColors.primaryDark,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AppColors.borderColor, // border color
                  width: 1.5, // border width
                ),
              ),
            ),
          ),

          // Category chips
          ...categories.map((category) {
            final isSelected = selectedCategoryId == category.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.primaryText,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(category.id),
                backgroundColor: AppColors.overlayColor,
                selectedColor: category.getColor(),
                checkmarkColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppColors.borderColor, // border color
                    width: 1.5, // border width
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
