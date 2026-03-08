import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';
import 'analytics_stat_card.dart';

class AnalyticsStreakSection extends StatelessWidget {
  final AnalyticsController controller;

  const AnalyticsStreakSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Streak Performance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnalyticsStatCard(
                icon: Icons.local_fire_department,
                label: 'Current Streak',
                value: controller.currentStreak.value.toString(),
                iconColor: AppColors.warning,
                unit: 'days',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnalyticsStatCard(
                icon: Icons.auto_graph,
                label: 'Best Streak',
                value: controller.longestStreak.value.toString(),
                iconColor: AppColors.success,
                unit: 'days',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AnalyticsStatCard(
                icon: Icons.check_circle,
                label: 'Completed Habits',
                value: controller.completedHabits.value.toString(),
                iconColor: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnalyticsStatCard(
                icon: Icons.task_alt,
                label: 'Completed Tasks',
                value: controller.completedTasks.value.toString(),
                iconColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
