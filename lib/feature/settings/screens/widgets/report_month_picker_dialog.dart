import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

Future<DateTime?> showReportMonthPicker(
  BuildContext context,
  DateTime initialMonth,
) {
  final now = DateTime.now();
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final minYear = now.year - 5;
  final maxYear = now.year + 1;

  int selectedYear = initialMonth.year;
  if (selectedYear < minYear) selectedYear = minYear;
  if (selectedYear > maxYear) selectedYear = maxYear;
  int selectedMonth = initialMonth.month;

  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            backgroundColor: AppColors.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.borderColor),
            ),
            title: Text(
              'Select Report Month',
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: selectedYear > minYear
                          ? () => setState(() => selectedYear--)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      color: AppColors.primary,
                    ),
                    Text(
                      '$selectedYear',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    IconButton(
                      onPressed: selectedYear < maxYear
                          ? () => setState(() => selectedYear++)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(12, (index) {
                    final month = index + 1;
                    final isSelected = month == selectedMonth;

                    return GestureDetector(
                      onTap: () => setState(() => selectedMonth = month),
                      child: Container(
                        width: 66,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.overlayColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.borderColor,
                          ),
                        ),
                        child: Text(
                          monthNames[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.inActiveColor),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  DateTime(selectedYear, selectedMonth, 1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Download',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
