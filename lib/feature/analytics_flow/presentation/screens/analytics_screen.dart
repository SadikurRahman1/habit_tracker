import 'package:habit/core/wrappers/responsive_card.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../../../home_flow/presentation/controllers/home_controller.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/completion_progress_bar.dart';
import '../widgets/date_picker_calendar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(
      init: AnalyticsController(),
      builder: (analyticsController) {
        return GetBuilder<HomeController>(
          init: HomeController(),
          builder: (homeController) {
            return Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: AppBar(
                backgroundColor: AppColors.bgColor,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'Analytics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: ResponsiveCard(
                        backgroundColor: AppColors.mainColor,
                        borderColor: AppColors.borderColor,
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: ResponsiveCard(
                          backgroundColor: AppColors.mainColor,
                          borderColor: AppColors.borderColor,
                          onTap: () => _showExportOptions(context, homeController),
                          child: const Icon(
                            Icons.download,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date range header with current date info
                        Obx(
                          () => ResponsiveCard(
                            borderColor: AppColors.borderColor,
                            backgroundColor: AppColors.mainColor,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      analyticsController.getFormattedSelectedDate(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Selected Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Calendar Widget
                        Obx(
                          () => DatePickerCalendar(
                            initialDate: analyticsController.selectedDate.value,
                            onDateSelected: (date) {
                              analyticsController.updateSelectedDate(date);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Streak Statistics
                        const Text(
                          'Your Streaks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => AnalyticsStatCard(
                                icon: Icons.local_fire_department,
                                label: 'Current Streak',
                                value: analyticsController.currentStreak.value.toString(),
                                iconColor: Colors.orange,
                                unit: 'days',
                              )),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(() => AnalyticsStatCard(
                                icon: Icons.star,
                                label: 'Best Streak',
                                value: analyticsController.longestStreak.value.toString(),
                                iconColor: Colors.amber,
                                unit: 'days',
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Completion Statistics
                        const Text(
                          'Completion Rate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => CompletionProgressBar(
                            title: 'Weekly Completion',
                            percentage: analyticsController.weeklyCompletion.value,
                            period: 'This week',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => CompletionProgressBar(
                            title: 'Monthly Completion',
                            percentage: analyticsController.monthlyCompletion.value,
                            period: 'This month',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Habit Statistics
                        const Text(
                          'Habit Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => AnalyticsStatCard(
                                icon: Icons.check_circle,
                                label: 'Completed',
                                value: homeController.getCompletedTasksCount().toString(),
                                iconColor: AppColors.success,
                              )),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(() => AnalyticsStatCard(
                                icon: Icons.list_alt,
                                label: 'Total Habits',
                                value: homeController.getTotalTasksCount().toString(),
                                iconColor: AppColors.purple,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Weekly breakdown
                        const Text(
                          'Weekly Breakdown',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ResponsiveCard(
                          borderColor: AppColors.borderColor,
                          backgroundColor: AppColors.mainColor,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildDayCompletionRow('Monday', 5, 6),
                              const SizedBox(height: 12),
                              _buildDayCompletionRow('Tuesday', 6, 6),
                              const SizedBox(height: 12),
                              _buildDayCompletionRow('Wednesday', 4, 6),
                              const SizedBox(height: 12),
                              _buildDayCompletionRow('Thursday', 5, 6),
                              const SizedBox(height: 12),
                              _buildDayCompletionRow('Friday', 6, 6),
                              const SizedBox(height: 12),
                              _buildDayCompletionRow('Saturday', 3, 6),
                              const SizedBox(height: 12),
                              _buildDayCompletionRow('Sunday', 2, 6),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDayCompletionRow(String day, int completed, int total) {
    final percentage = (completed / total * 100).toStringAsFixed(0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        Row(
          children: [
            Container(
              width: 120,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completed / total,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
              // widthFactor: 2,
            ),
          ],
        ),
      ],
    );
  }

  void _showExportOptions(BuildContext context, HomeController homeController) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Export Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose export format:',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  final jsonData = homeController.exportTasks();
                  Share.share(
                    jsonData,
                    subject: 'Habit Tracker - Task Data Export',
                  );
                  Navigator.pop(context);
                  Get.snackbar(
                    'Exported',
                    'Tasks exported successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.data_object, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Export as JSON',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Share or backup your data',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  final totalTasks = homeController.getTotalTasksCount();
                  final completedTasks = homeController.getCompletedTasksCount();
                  final completion = homeController.getCompletionPercentage();
                  
                  final summary = '''
📊 Habit Tracker Summary
━━━━━━━━━━━━━━━━━━━━━━━━
📝 Total Tasks: $totalTasks
✅ Completed Tasks: $completedTasks
📈 Completion Rate: ${completion.toStringAsFixed(1)}%
⏰ Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}
━━━━━━━━━━━━━━━━━━━━━━━━
''';
                  
                  Share.share(summary, subject: 'Habit Tracker - Progress Report');
                  Navigator.pop(context);
                  Get.snackbar(
                    'Exported',
                    'Summary exported successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.summarize, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Export Summary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Share progress statistics',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
