import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:printing/printing.dart';

import '../../habit_flow/controllers/habit_controller.dart';
import '../../home_flow/presentation/controllers/home_controller.dart';
import '../services/monthly_report_pdf_service.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  final InAppReview _inAppReview = InAppReview.instance;
  static const String _themeKey = 'theme_mode';
  final MonthlyReportPdfService _monthlyReportPdfService =
      MonthlyReportPdfService();

  final isDarkMode = true.obs;
  final isGeneratingMonthlyReport = false.obs;
  final isLaunchingReviewFlow = false.obs;
  final selectedReportMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
    }

    _applyTheme();
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme([bool? value]) {
    isDarkMode.value = value ?? !isDarkMode.value;
    _storage.write(_themeKey, isDarkMode.value ? 'dark' : 'light');
    _applyTheme();
    // Force immediate app rebuild to reflect color changes
    Future.delayed(Duration.zero, () {
      Get.forceAppUpdate();
    });
  }

  Future<void> downloadMonthlyReport(DateTime month) async {
    if (isGeneratingMonthlyReport.value) return;

    if (!Get.isRegistered<HabitController>()) {
      Get.snackbar(
        'Unavailable',
        'Habit data is not ready yet. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isGeneratingMonthlyReport.value = true;

    try {
      final selectedMonth = DateTime(month.year, month.month, 1);
      selectedReportMonth.value = selectedMonth;

      final habitController = Get.find<HabitController>();
      final homeController = Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : null;

      final result = await _monthlyReportPdfService.generateMonthlyReport(
        month: selectedMonth,
        habitController: habitController,
        homeController: homeController,
      );

      await Printing.layoutPdf(
        name: result.fileName,
        onLayout: (_) async => result.fileBytes,
      );

      Get.snackbar(
        'Print Opened',
        'Monthly report is ready to print.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Failed',
        'Could not generate monthly report. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGeneratingMonthlyReport.value = false;
    }
  }

  Future<void> requestPlayStoreReview() async {
    if (isLaunchingReviewFlow.value) return;

    if (!GetPlatform.isAndroid) {
      Get.snackbar(
        'Unavailable',
        'Play Store review is available only on Android devices.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLaunchingReviewFlow.value = true;

    try {
      final canRequestInAppReview = await _inAppReview.isAvailable();

      if (!canRequestInAppReview) {
        Get.snackbar(
          'Unavailable',
          'In-app review is not available right now. Please try again later.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      await _inAppReview.requestReview();
    } catch (_) {
      Get.snackbar(
        'Unavailable',
        'Could not open in-app review right now. Please try again later.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLaunchingReviewFlow.value = false;
    }
  }

  String formatMonth(DateTime month) {
    return _monthTitle(DateTime(month.year, month.month, 1));
  }

  String _monthTitle(DateTime month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[month.month - 1]} ${month.year}';
  }
}
