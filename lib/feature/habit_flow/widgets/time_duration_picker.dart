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
    int hours = timeDurationMinutes ~/ 60;
    int minutes = timeDurationMinutes % 60;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Select Duration',
                style: TextStyle(
                  color: AppColors.onMainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hours
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hours: $hours',
                        style: TextStyle(
                          color: AppColors.onMainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: hours.toDouble(),
                        min: 0,
                        max: 24,
                        divisions: 24,
                        activeColor: Colors.blue,
                        inactiveColor: AppColors.borderColor,
                        label: '$hours h',
                        onChanged: (value) {
                          setState(() {
                            hours = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Minutes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minutes: $minutes',
                        style: TextStyle(
                          color: AppColors.onMainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: minutes.toDouble(),
                        min: 0,
                        max: 59,
                        divisions: 59,
                        activeColor: Colors.blue,
                        inactiveColor: AppColors.borderColor,
                        label: '$minutes m',
                        onChanged: (value) {
                          setState(() {
                            minutes = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.onMainSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final totalMinutes = (hours * 60) + minutes;
                    onDurationChanged(totalMinutes);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
                    ? Colors.blue
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
                        ? Colors.blue
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
