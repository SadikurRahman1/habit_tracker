import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../controllers/settings_controller.dart';
import '../category_flow/screens/category_management_screen.dart';
import '../category_flow/bindings/category_binding.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<DateTime?> _pickReportMonth(
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Obx(() {
      final textPrimary = AppColors.primaryText;
      final textSecondary = AppColors.secondaryText;

      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          elevation: 0,
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onMainColor,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
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
                          Icon(
                            Icons.brightness_4,
                            color: textPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: controller.isDarkMode.value,
                        onChanged: (value) => controller.toggleTheme(value),
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: () => Get.to(
                    () => const CategoryManagementScreen(),
                    binding: CategoryBinding(),
                  ),
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
                            Icon(
                              Icons.category,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Manage Categories',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: controller.isGeneratingMonthlyReport.value
                      ? null
                      : () async {
                          final selectedMonth = await _pickReportMonth(
                            context,
                            controller.selectedReportMonth.value,
                          );

                          if (selectedMonth == null) return;
                          await controller.downloadMonthlyReport(selectedMonth);
                        },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.overlayColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf,
                                  color: AppColors.danger,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Monthly PDF Report',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            controller.isGeneratingMonthlyReport.value
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.download_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                          ],
                        ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   'Selected: ${controller.formatMonth(controller.selectedReportMonth.value)}',
                        //   style: TextStyle(
                        //     color: textPrimary,
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // const SizedBox(height: 4),
                        // Text(
                        //   'Choose month and download report as PDF',
                        //   style: TextStyle(color: textSecondary, fontSize: 12),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (GetPlatform.isAndroid) ...[
                  GestureDetector(
                    onTap: controller.isLaunchingReviewFlow.value
                        ? null
                        : controller.requestPlayStoreReview,
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
                              Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Rate on Play Store',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          controller.isLaunchingReviewFlow.value
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
                                  color: textSecondary,
                                  size: 18,
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.overlayColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Habit Tracker',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
