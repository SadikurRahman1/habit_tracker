import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final double progressRatio;
  final int totalItems;

  const ProgressBarWidget({
    Key? key,
    required this.progressRatio,
    required this.totalItems,
  }) : super(key: key);

  double get _percentage {
    if (totalItems == 0) return 0;
    return progressRatio.clamp(0.0, 1.0);
  }

  String get _progressSummary {
    final equivalentCompleted = _percentage * totalItems;
    return '${equivalentCompleted.toStringAsFixed(1)} of $totalItems items progress';
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = AppColors.isDarkMode
        ? [AppColors.primaryDark, AppColors.primary]
        : [AppColors.primary, AppColors.primaryLight];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Progress',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(_percentage * 100).toInt()}%',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _percentage,
              minHeight: 10,
              backgroundColor: AppColors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _progressSummary,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
