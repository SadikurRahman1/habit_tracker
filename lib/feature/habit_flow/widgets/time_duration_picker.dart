import 'package:flutter/cupertino.dart';
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
    final initialMinutes = timeDurationMinutes.clamp(0, (23 * 60) + 59);
    Duration selectedDuration = Duration(minutes: initialMinutes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final hours = selectedDuration.inHours;
            final minutes = selectedDuration.inMinutes % 60;
            final displayText = hours > 0
                ? '$hours h $minutes m'
                : '$minutes m';

            return SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.onMainSecondary),
                          ),
                        ),
                        Text(
                          'Select Duration',
                          style: TextStyle(
                            color: AppColors.onMainColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            onDurationChanged(selectedDuration.inMinutes);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Text(
                        displayText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.onMainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          primaryColor: AppColors.primary,
                          textTheme: CupertinoTextThemeData(
                            pickerTextStyle: TextStyle(
                              color: AppColors.onMainColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hm,
                          minuteInterval: 1,
                          initialTimerDuration: selectedDuration,
                          onTimerDurationChanged: (duration) {
                            setState(() {
                              selectedDuration = Duration(
                                hours: duration.inHours,
                                minutes: duration.inMinutes % 60,
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
