import 'package:share_plus/share_plus.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../../../home_flow/presentation/controllers/home_controller.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsExportDialog extends StatelessWidget {
  final HomeController homeController;
  final AnalyticsController analyticsController;

  const AnalyticsExportDialog({
    super.key,
    required this.homeController,
    required this.analyticsController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            Text(
              'Export Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose export format:',
              style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 16),
            _buildJsonExportOption(context),
            const SizedBox(height: 12),
            _buildSummaryExportOption(context),
            const SizedBox(height: 16),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildJsonExportOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final jsonData = homeController.exportTasks();
        Share.share(jsonData, subject: 'Habit Tracker - Task Data Export');
        Navigator.pop(context);
        Get.snackbar(
          'Exported',
          'Tasks exported successfully',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Row(
          children: [
            Icon(Icons.data_object, color: AppColors.white, size: 20),
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
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Share or backup your data',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.darkSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryExportOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final selectedDate = analyticsController.getFormattedSelectedDate();
        final completedHabits = analyticsController.completedHabits.value;
        final totalHabits = analyticsController.totalHabits.value;
        final completedTasks = analyticsController.completedTasks.value;
        final totalTasks = analyticsController.totalTasks.value;
        final weeklyRate = analyticsController.weeklyCompletion.value;
        final monthlyRate = analyticsController.monthlyCompletion.value;
        final currentStreak = analyticsController.currentStreak.value;
        final bestStreak = analyticsController.longestStreak.value;
        final dailyRate = analyticsController.dailyCompletion.value;

        final summary =
            '''
📊 Habit Tracker Summary
━━━━━━━━━━━━━━━━━━━━━━━━
📅 Date: $selectedDate
🔥 Current Streak: $currentStreak days
⭐ Best Streak: $bestStreak days

🧠 Habits: $completedHabits / $totalHabits
📝 Tasks: $completedTasks / $totalTasks

📈 Daily Completion: ${dailyRate.toStringAsFixed(1)}%
📊 Weekly Completion: ${weeklyRate.toStringAsFixed(1)}%
📉 Monthly Completion: ${monthlyRate.toStringAsFixed(1)}%
━━━━━━━━━━━━━━━━━━━━━━━━
''';

        Share.share(summary, subject: 'Habit Tracker - Progress Report');
        Navigator.pop(context);
        Get.snackbar(
          'Exported',
          'Summary exported successfully',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Row(
          children: [
            Icon(Icons.summarize, color: AppColors.white, size: 20),
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
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Share progress statistics',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.darkSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.inActiveColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
