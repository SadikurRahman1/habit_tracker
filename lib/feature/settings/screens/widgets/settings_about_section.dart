import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.primaryText;
    final textSecondary = AppColors.secondaryText;

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.overlayColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Habit Tracker',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Build better routines and stay consistent with your daily goals.',
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.inputFillColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your habit data is stored locally on your device.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Version',
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w600,
          //         color: textSecondary,
          //       ),
          //     ),
          //     Text(
          //       '1.0.0',
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w700,
          //         color: textPrimary,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 4),
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         'Built with',
        //         style: TextStyle(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w600,
        //           color: textSecondary,
        //         ),
        //       ),
        //       Text(
        //         'Flutter',
        //         style: TextStyle(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w700,
        //           color: textPrimary,
        //         ),
        //       ),
        //     ],
        //   ),
        ],
      ),
    );
  }
}
