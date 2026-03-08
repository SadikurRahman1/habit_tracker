import '../../../../core/exported_files/exported_file.dart';
import '../../../../core/wrappers/responsive_card.dart';
import '../controllers/analytics_controller.dart';

class WeeklyTrendChart extends StatelessWidget {
  final List<DayCompletionData> data;
  final DateTime selectedDate;

  const WeeklyTrendChart({
    super.key,
    required this.data,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final average = data.isEmpty
        ? 0.0
        : data.map((item) => item.percentage).reduce((a, b) => a + b) /
              data.length;

    return ResponsiveCard(
      borderColor: AppColors.borderColor,
      backgroundColor: AppColors.mainColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onMainColor,
                ),
              ),
              Text(
                'Avg ${average.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onMainSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 165,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final percentage = item.percentage.clamp(0, 100).toDouble();
                final isSelected = _isSameDate(item.date, selectedDate);
                final barColor = _barColor(percentage);
                final barHeight = 24 + (percentage / 100) * 76;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onMainSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        width: 18,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.onMainColor
                                : AppColors.borderColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.onMainColor
                              : AppColors.onMainSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _barColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 50) return AppColors.warning;
    return AppColors.danger;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
