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
              title: const Text(
                'Select Duration',
                style: TextStyle(
                  color: Colors.white,
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
                        style: const TextStyle(
                          color: Colors.white,
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
                        inactiveColor: Colors.white24,
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
                        style: const TextStyle(
                          color: Colors.white,
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
                        inactiveColor: Colors.white24,
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
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
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
    final displayText = hours > 0
        ? '$hours h $minutes m'
        : '$minutes m';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time Duration *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showTimePicker(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(
                color: timeDurationMinutes > 0 ? Colors.blue : Colors.white24,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeDurationMinutes > 0
                      ? displayText
                      : 'Select duration',
                  style: TextStyle(
                    fontSize: 14,
                    color: timeDurationMinutes > 0
                        ? Colors.blue
                        : Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: Colors.white54,
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
