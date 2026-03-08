import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/services/local_notification_service.dart';
import 'package:habit/feature/habit_flow/bindings/habit_flow_binding.dart';
import 'package:habit/feature/habit_flow/controllers/habit_controller.dart';
import 'package:habit/feature/habit_flow/model/habit_model.dart';
import 'package:habit/feature/habit_flow/screens/habit_creation_screen.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/home_flow/presentation/widgets/habit_action_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/notification_time_picker_bottom_sheet.dart';

class HomeHabitActionHelper {
  static void handleHabitTap({
    required BuildContext context,
    required HabitController habitController,
    required HomeController homeController,
    required HabitModel habit,
  }) {
    if (homeController.isFutureDate) return;

    final date = homeController.selectedDate.value;

    switch (habit.questionType) {
      case HabitQuestionType.yesNo:
        habitController.toggleYesNoCompletion(habit.id, date);
        break;
      case HabitQuestionType.numeric:
        _showNumericInputDialog(
          context: context,
          habitController: habitController,
          habit: habit,
          date: date,
        );
        break;
      case HabitQuestionType.time:
        homeController.toggleTimeCountdown(habit, date);
        break;
      case HabitQuestionType.text:
        _showTextInputDialog(
          habitController: habitController,
          habit: habit,
          date: date,
        );
        break;
    }
  }

  static void handleHabitLongPress({
    required HabitController habitController,
    required HomeController homeController,
    required HabitModel habit,
  }) {
    final date = homeController.selectedDate.value;
    final completion = habitController.getCompletion(habit.id, date);
    final isCompleted = completion?.isCompleted ?? false;

    Get.bottomSheet(
      HabitActionBottomSheet(
        isCompleted: isCompleted,
        onToggleComplete: () {
          if (isCompleted) {
            if (habit.questionType == HabitQuestionType.time) {
              homeController.stopTimeCountdown(habit.id, date);
            }
            habitController.updateCompletion(
              habitId: habit.id,
              date: date,
              isCompleted: false,
            );
            return;
          }

          switch (habit.questionType) {
            case HabitQuestionType.yesNo:
              habitController.toggleYesNoCompletion(habit.id, date);
              break;
            case HabitQuestionType.numeric:
              habitController.updateNumericCompletion(
                habit.id,
                date,
                habit.targetValue,
              );
              break;
            case HabitQuestionType.time:
              homeController.stopTimeCountdown(habit.id, date);
              habitController.updateTimeCompletion(
                habit.id,
                date,
                habit.timeDurationMinutes,
              );
              break;
            case HabitQuestionType.text:
              habitController.updateTextCompletion(habit.id, date, 'Completed');
              break;
          }
        },
        onEdit: () {
          Get.to(
            () => HabitCreationScreen(habitToEdit: habit),
            binding: HabitFlowBinding(),
          );
        },
        onSetNotification: () async {
          final result = await Get.bottomSheet<List<String>>(
            NotificationTimePickerBottomSheet(
              initialTimes: habit.notificationTimes,
              habitName: habit.name,
            ),
            isScrollControlled: true,
            isDismissible: true,
          );

          if (result != null) {
            // Update habit with new notification times
            final updatedHabit = HabitModel(
              id: habit.id,
              name: habit.name,
              questionType: habit.questionType,
              categoryId: habit.categoryId,
              targetValue: habit.targetValue,
              timeDurationMinutes: habit.timeDurationMinutes,
              repeatDays: habit.repeatDays,
              createdAt: habit.createdAt,
              isActive: habit.isActive,
              notificationTimes: result,
            );

            // Save to controller
            habitController.updateHabitModel(updatedHabit);

            // Schedule notifications
            if (result.isNotEmpty) {
              await LocalNotificationService.scheduleHabitNotifications(
                habitId: habit.id,
                habitName: habit.name,
                times: result,
                repeatDays: habit.repeatDays,
              );

              Get.snackbar(
                'Notifications Set',
                '${result.length} reminder${result.length > 1 ? 's' : ''} scheduled',
                backgroundColor: AppColors.success,
                colorText: AppColors.white,
              );
            } else {
              // Cancel all notifications if no times selected
              await LocalNotificationService.cancelHabitNotifications(habit.id);

              Get.snackbar(
                'Notifications Removed',
                'All reminders have been cancelled',
                backgroundColor: AppColors.warning,
                colorText: AppColors.white,
              );
            }
          }
        },
        onDelete: () {
          Get.dialog(
            AlertDialog(
              backgroundColor: AppColors.mainColor,
              title: Text(
                'Delete Habit',
                style: TextStyle(color: AppColors.onMainColor),
              ),
              content: Text(
                'Are you sure you want to delete "${habit.name}"?',
                style: TextStyle(color: AppColors.onMainSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (habit.questionType == HabitQuestionType.time) {
                      homeController.stopTimeCountdown(habit.id, date);
                    }
                    await LocalNotificationService.cancelHabitNotifications(
                      habit.id,
                    );
                    habitController.removeHabit(habit.id);
                    Get.back();
                    Get.snackbar(
                      'Deleted',
                      '${habit.name} has been deleted',
                      backgroundColor: AppColors.danger,
                      colorText: AppColors.white,
                    );
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  static void _showNumericInputDialog({
    required BuildContext context,
    required HabitController habitController,
    required HabitModel habit,
    required DateTime date,
  }) {
    final existing = habitController.getCompletion(habit.id, date);
    final currentValue = (existing?.numericValue ?? 0).obs;
    final valueController = TextEditingController(
      text: currentValue.value.toString(),
    );

    void syncValueField() {
      final valueText = currentValue.value.toString();
      if (valueController.text != valueText) {
        valueController.value = TextEditingValue(
          text: valueText,
          selection: TextSelection.collapsed(offset: valueText.length),
        );
      }
    }

    Get.dialog(
      Obx(() {
        syncValueField();
        return AlertDialog(
          backgroundColor: AppColors.mainColor,
          title: Text(
            habit.name,
            style: TextStyle(color: AppColors.onMainColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Target: ${habit.targetValue}',
                style: TextStyle(
                  color: AppColors.onMainSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.overlayColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (currentValue.value > 0) {
                              currentValue.value--;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            elevation: 4,
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.onMainColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.inputFillColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    currentValue.value = 0;
                                    return;
                                  }
                                  final parsedValue = int.tryParse(value);
                                  if (parsedValue != null) {
                                    currentValue.value = parsedValue;
                                  }
                                },
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Direct edit',
                                style: TextStyle(
                                  color: AppColors.onMainSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            currentValue.value++;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            elevation: 4,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentValue.value >= habit.targetValue
                          ? '✓ Target reached!'
                          : '${habit.targetValue - currentValue.value} to go',
                      style: TextStyle(
                        color: currentValue.value >= habit.targetValue
                            ? Colors.green
                            : AppColors.onMainSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (currentValue.value / habit.targetValue).clamp(
                          0.0,
                          1.0,
                        ),
                        minHeight: 6,
                        backgroundColor: AppColors.weakOverlayColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          currentValue.value >= habit.targetValue
                              ? Colors.green
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                habitController.updateNumericCompletion(
                  habit.id,
                  date,
                  currentValue.value,
                );
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        );
      }),
    );
  }

  static void _showTextInputDialog({
    required HabitController habitController,
    required HabitModel habit,
    required DateTime date,
  }) {
    final controller = TextEditingController();
    final existing = habitController.getCompletion(habit.id, date);
    controller.text = existing?.textAnswer ?? '';

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.mainColor,
        title: Text(habit.name, style: TextStyle(color: AppColors.onMainColor)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: TextStyle(color: AppColors.onMainColor),
          decoration: InputDecoration(
            labelText: 'Enter your answer',
            labelStyle: TextStyle(color: AppColors.onMainSecondary),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final answer = controller.text.trim();
              if (answer.isNotEmpty) {
                habitController.updateTextCompletion(habit.id, date, answer);
              }
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
