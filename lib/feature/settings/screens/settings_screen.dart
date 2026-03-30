import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../controllers/settings_controller.dart';
import '../category_flow/screens/category_management_screen.dart';
import '../category_flow/bindings/category_binding.dart';
import 'widgets/report_month_picker_dialog.dart';
import 'widgets/settings_about_section.dart';
import 'widgets/settings_app_bar.dart';
import 'widgets/settings_manage_categories_tile.dart';
import 'widgets/settings_monthly_report_tile.dart';
import 'widgets/settings_play_store_review_tile.dart';
import 'widgets/settings_theme_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const SettingsAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsThemeTile(
                  isDarkMode: controller.isDarkMode.value,
                  onToggle: controller.toggleTheme,
                ),
                const SizedBox(height: 24),

                SettingsManageCategoriesTile(
                  onTap: () => Get.to(
                    () => const CategoryManagementScreen(),
                    binding: CategoryBinding(),
                  ),
                ),
                const SizedBox(height: 24),

                SettingsMonthlyReportTile(
                  isLoading: controller.isGeneratingMonthlyReport.value,
                  onTap: controller.isGeneratingMonthlyReport.value
                      ? null
                      : () async {
                          final selectedMonth = await showReportMonthPicker(
                            context,
                            controller.selectedReportMonth.value,
                          );

                          if (selectedMonth == null) return;
                          await controller.downloadMonthlyReport(selectedMonth);
                        },
                ),
                const SizedBox(height: 24),

                if (GetPlatform.isAndroid) ...[
                  SettingsPlayStoreReviewTile(
                    isLoading: controller.isLaunchingReviewFlow.value,
                    onTap: controller.isLaunchingReviewFlow.value
                        ? null
                        : controller.requestPlayStoreReview,
                  ),
                  const SizedBox(height: 24),
                ],

                const SettingsAboutSection(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
