import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class TimeDurationPicker extends StatelessWidget {
  final int timeDurationMinutes;
  final Function(int) onDurationChanged;

  const TimeDurationPicker({
    Key? key,
    required this.timeDurationMinutes,
    required this.onDurationChanged,
  }) : super(key: key);

  void _showTimePicker(BuildContext context) {
    final hours = timeDurationMinutes ~/ 60;
    final minutes = timeDurationMinutes % 60;

    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hours, minute: minutes),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.mainColor,
              onSurface: AppColors.onMainColor,
            ),
          ),
          child: child!,
        );
      },
    ).then((picked) {
      if (picked != null) {
        final totalMinutes = (picked.hour * 60) + picked.minute;
        onDurationChanged(totalMinutes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = timeDurationMinutes ~/ 60;
    final minutes = timeDurationMinutes % 60;
    final displayText = hours > 0 ? '$hours h $minutes m' : '$minutes m';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Duration *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showTimePicker(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.inputFillColor,
              border: Border.all(
                color: timeDurationMinutes > 0
                    ? AppColors.primary
                    : AppColors.borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeDurationMinutes > 0 ? displayText : 'Select duration',
                  style: TextStyle(
                    fontSize: 14,
                    color: timeDurationMinutes > 0
                        ? AppColors.primary
                        : AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: AppColors.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
