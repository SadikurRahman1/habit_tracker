import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class SettingsManageCategoriesTile extends StatelessWidget {
  const SettingsManageCategoriesTile({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.overlayColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Manage Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.secondaryText,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
