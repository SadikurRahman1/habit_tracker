import 'package:habit/core/wrappers/responsive_card.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';
import 'day_completion_row.dart';

class WeeklyBreakdownCard extends StatelessWidget {
  final List<DayCompletionData> weeklyData;

  const WeeklyBreakdownCard({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        ResponsiveCard(
          borderColor: AppColors.borderColor,
          backgroundColor: AppColors.mainColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (int i = 0; i < weeklyData.length; i++) ...[
                DayCompletionRow(data: weeklyData[i]),
                if (i != weeklyData.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
