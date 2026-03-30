import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class SettingsPlayStoreReviewTile extends StatelessWidget {
  const SettingsPlayStoreReviewTile({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback? onTap;

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
                Icon(Icons.star_rate_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Rate on Play Store',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(
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
