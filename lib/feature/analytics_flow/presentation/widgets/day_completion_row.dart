import '../../../../core/exported_files/exported_file.dart';
import '../controllers/analytics_controller.dart';

class DayCompletionRow extends StatelessWidget {
  final DayCompletionData data;

  const DayCompletionRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final percentage = data.percentage.toStringAsFixed(0);
    final progressValue = data.total == 0 ? 0.0 : data.completed / data.total;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          data.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
        Row(
          children: [
            Container(
              width: 120,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.overlayColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: AppColors.overlayColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }
}
