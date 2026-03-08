import 'package:habit/core/wrappers/responsive_card.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsOverviewCard extends StatelessWidget {
  final AnalyticsController controller;

  const AnalyticsOverviewCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selectedDate = controller.getFormattedSelectedDate();
    final totalHabits = controller.totalHabits.value;
    final completedHabits = controller.completedHabits.value;
    final totalTasks = controller.totalTasks.value;
    final completedTasks = controller.completedTasks.value;
    final done = completedHabits + completedTasks;
    final total = totalHabits + totalTasks;
    final percentage = controller.dailyCompletion.value.clamp(0.0, 100.0);

    return ResponsiveCard(
      borderColor: AppColors.borderColor,
      backgroundColor: AppColors.mainColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onMainColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Daily Progress',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onMainSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$done / $total Completed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onMainColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Habits: $completedHabits/$totalHabits • Tasks: $completedTasks/$totalTasks',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onMainSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: percentage / 100,
                    backgroundColor: AppColors.overlayColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onMainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
