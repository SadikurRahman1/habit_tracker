import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';

class TimeDurationPicker extends StatelessWidget {
  final int timeDurationMinutes;
  final Function(int) onDurationChanged;

  const TimeDurationPicker({
    Key? key,
    required this.timeDurationMinutes,
    required this.onDurationChanged,
  }) : super(key: key);

  void _showDurationPicker(BuildContext context) {
    final initialHours = timeDurationMinutes ~/ 60;
    final initialMinutes = timeDurationMinutes % 60;
    final selectedHours = initialHours.obs;
    final selectedMinutes = initialMinutes.obs;
    final hoursController = FixedExtentScrollController(initialItem: initialHours);
    final minutesController = FixedExtentScrollController(
      initialItem: initialMinutes,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.mainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Set Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final totalMinutes =
                            (selectedHours.value * 60) + selectedMinutes.value;
                        onDurationChanged(totalMinutes);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Picker Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hours Picker
                    SizedBox(
                      width: 100,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background border
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.borderColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: AppColors.borderColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          // Scroll wheel
                          ListWheelScrollView(
                            controller: hoursController,
                            itemExtent: 50,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              selectedHours.value = index;
                            },
                            children: List.generate(
                              24,
                              (index) => Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: selectedHours.value == index
                                        ? AppColors.primary
                                        : AppColors.secondaryText.withValues(
                                            alpha: 0.4,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Separator
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    // Minutes Picker
                    SizedBox(
                      width: 100,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background border
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.borderColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: AppColors.borderColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          // Scroll wheel
                          ListWheelScrollView(
                            controller: minutesController,
                            itemExtent: 50,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              selectedMinutes.value = index;
                            },
                            children: List.generate(
                              60,
                              (index) => Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: selectedMinutes.value == index
                                        ? AppColors.primary
                                        : AppColors.secondaryText.withValues(
                                            alpha: 0.4,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Selected Display
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${selectedHours.value.toString().padLeft(2, '0')}h ${selectedMinutes.value.toString().padLeft(2, '0')}m',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      hoursController.dispose();
      minutesController.dispose();
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
          onTap: () => _showDurationPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputFillColor,
              border: Border.all(
                color: timeDurationMinutes > 0
                    ? AppColors.primary
                    : AppColors.borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeDurationMinutes > 0 ? displayText : 'Select duration',
                  style: TextStyle(
                    fontSize: 15,
                    color: timeDurationMinutes > 0
                        ? AppColors.primaryText
                        : AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.schedule_rounded,
                  color: timeDurationMinutes > 0
                      ? AppColors.primary
                      : AppColors.secondaryText,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
