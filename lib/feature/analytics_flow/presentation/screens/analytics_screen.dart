import 'package:habit/core/wrappers/responsive_card.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/home_flow/presentation/widgets/calendar_bottom_sheet.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/analytics_completion_section.dart';
import '../widgets/analytics_export_dialog.dart';
import '../widgets/analytics_overview_card.dart';
import '../widgets/analytics_streak_section.dart';
import '../widgets/date_picker_calendar.dart';
import '../widgets/weekly_breakdown_card.dart';
import '../widgets/weekly_trend_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  void _openCalendarBottomSheet(HomeController homeController) {
    Get.bottomSheet(
      CalendarBottomSheet(
        selectedDate: homeController.selectedDate.value,
        onDateSelected: homeController.updateSelectedDate,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return GetBuilder<AnalyticsController>(
      init: AnalyticsController(),
      builder: (analyticsController) {
        final homeController = analyticsController.homeController;

        return Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Analytics',
              style: TextStyle(
                color: AppColors.onMainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 16),
            //     child: Center(
            //       child: ResponsiveCard(
            //         backgroundColor: AppColors.mainColor,
            //         borderColor: AppColors.borderColor,
            //         onTap: () => showDialog(
            //           context: context,
            //           builder: (context) => AnalyticsExportDialog(
            //             homeController: homeController,
            //             analyticsController: analyticsController,
            //           ),
            //         ),
            //         child: const Icon(
            //           Icons.download_rounded,
            //           color: AppColors.primary,
            //           size: 20,
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
            actions: [
              // Calendar icon
              GestureDetector(
                onTap: () => _openCalendarBottomSheet(homeController),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.calendar_today, color: AppColors.primary),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Obx(() {
              final weeklyData = analyticsController.weeklyBreakdown.toList();
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnalyticsOverviewCard(controller: analyticsController),
                      const SizedBox(height: 20),
                      // DatePickerCalendar(
                      //   initialDate: analyticsController.selectedDate.value,
                      //   onDateSelected: analyticsController.updateSelectedDate,
                      // ),
                      // const SizedBox(height: 20),
                      AnalyticsStreakSection(controller: analyticsController),
                      const SizedBox(height: 20),
                      AnalyticsCompletionSection(
                        controller: analyticsController,
                      ),
                      const SizedBox(height: 20),
                      WeeklyTrendChart(
                        data: weeklyData,
                        selectedDate: analyticsController.selectedDate.value,
                      ),
                      const SizedBox(height: 20),
                      // WeeklyBreakdownCard(weeklyData: weeklyData),
                      // const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
