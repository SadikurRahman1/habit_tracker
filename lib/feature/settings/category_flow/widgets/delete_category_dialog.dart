import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final String categoryName;
  final VoidCallback onDelete;

  const DeleteCategoryDialog({
    Key? key,
    required this.categoryName,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Delete Category?',
        style: TextStyle(
          color: AppColors.onMainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to delete "$categoryName"? This action cannot be undone.',
        style: TextStyle(color: AppColors.onMainSecondary, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.onMainSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onDelete();
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
