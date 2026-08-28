import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../../../../core/wrappers/responsive_card.dart';

class CompletionProgressBar extends StatelessWidget {
  final String title;
  final double percentage;
  final String period;

  const CompletionProgressBar({
    super.key,
    required this.title,
    required this.percentage,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      borderColor: AppColors.borderColor,
      backgroundColor: AppColors.mainColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onMainColor,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 75
                      ? AppColors.success
                      : percentage >= 50
                      ? AppColors.warning
                      : AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: AppColors.overlayColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 75
                    ? AppColors.success
                    : percentage >= 50
                    ? AppColors.warning
                    : AppColors.danger,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            period,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onMainSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
