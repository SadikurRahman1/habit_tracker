import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';
import 'completion_progress_bar.dart';

class AnalyticsCompletionSection extends StatelessWidget {
  final AnalyticsController controller;

  const AnalyticsCompletionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Rate',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        CompletionProgressBar(
          title: 'Weekly Completion',
          percentage: controller.weeklyCompletion.value,
          period: 'Selected week',
        ),
        const SizedBox(height: 12),
        CompletionProgressBar(
          title: 'Monthly Completion',
          percentage: controller.monthlyCompletion.value,
          period: 'Selected month',
        ),
      ],
    );
  }
}
