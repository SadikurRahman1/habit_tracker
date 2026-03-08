import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/habit_flow/bindings/habit_flow_binding.dart';
import 'package:habit/feature/habit_flow/controllers/habit_controller.dart';
import 'package:habit/feature/habit_flow/model/habit_model.dart';
import 'package:habit/feature/habit_flow/screens/habit_creation_screen.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/home_flow/presentation/widgets/add_item_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/calendar_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/category_filter_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/habit_action_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/habit_card_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/progress_bar_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/week_day_selector.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showNumericInputDialog(
    BuildContext context,
    HabitController habitController,
    HabitModel habit,
    DateTime date,
  ) {
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
                                    // borderSide: const BorderSide(
                                    // color: Colors.blue,
                                    // width: 1.5,
                                    // ),
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

  void _showTextInputDialog(
    BuildContext context,
    HabitController habitController,
    HabitModel habit,
    DateTime date,
  ) {
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

  void _handleHabitTap(
    BuildContext context,
    HabitController habitController,
    HomeController homeController,
    HabitModel habit,
  ) {
    final isFuture = homeController.isFutureDate;
    if (isFuture) return;

    final date = homeController.selectedDate.value;

    switch (habit.questionType) {
      case HabitQuestionType.yesNo:
        habitController.toggleYesNoCompletion(habit.id, date);
        break;
      case HabitQuestionType.numeric:
        _showNumericInputDialog(context, habitController, habit, date);
        break;
      case HabitQuestionType.time:
        homeController.toggleTimeCountdown(habit, date);
        break;
      case HabitQuestionType.text:
        _showTextInputDialog(context, habitController, habit, date);
        break;
    }
  }

  void _handleCircleTap(
    BuildContext context,
    HabitController habitController,
    HomeController homeController,
    HabitModel habit,
  ) {
    final isFuture = homeController.isFutureDate;
    if (isFuture) return;

    final date = homeController.selectedDate.value;

    switch (habit.questionType) {
      case HabitQuestionType.yesNo:
        habitController.toggleYesNoCompletion(habit.id, date);
        break;
      case HabitQuestionType.numeric:
        _showNumericInputDialog(context, habitController, habit, date);
        break;
      case HabitQuestionType.time:
        homeController.toggleTimeCountdown(habit, date);
        break;
      case HabitQuestionType.text:
        _showTextInputDialog(context, habitController, habit, date);
        break;
    }
  }

  void _handleHabitLongPress(
    HabitController habitController,
    HabitModel habit,
    DateTime date,
  ) {
    final completion = habitController.getCompletion(habit.id, date);
    final isCompleted = completion?.isCompleted ?? false;

    Get.bottomSheet(
      HabitActionBottomSheet(
        isCompleted: isCompleted,
        onToggleComplete: () {
          if (isCompleted) {
            // Remove completion
            if (habit.questionType == HabitQuestionType.time) {
              Get.find<HomeController>().stopTimeCountdown(habit.id, date);
            }
            habitController.updateCompletion(
              habitId: habit.id,
              date: date,
              isCompleted: false,
            );
          } else {
            // Mark as complete based on type
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
                Get.find<HomeController>().stopTimeCountdown(habit.id, date);
                habitController.updateTimeCompletion(
                  habit.id,
                  date,
                  habit.timeDurationMinutes,
                );
                break;
              case HabitQuestionType.text:
                habitController.updateTextCompletion(
                  habit.id,
                  date,
                  'Completed',
                );
                break;
            }
          }
        },
        onEdit: () {
          Get.to(
            () => HabitCreationScreen(habitToEdit: habit),
            binding: HabitFlowBinding(),
          );
        },
        onSetNotification: () {
          // TODO: Set notification
          Get.snackbar('Coming Soon', 'Notification feature will be added');
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
                  onPressed: () {
                    if (habit.questionType == HabitQuestionType.time) {
                      Get.find<HomeController>().stopTimeCountdown(
                        habit.id,
                        date,
                      );
                    }
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

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final habitController = Get.find<HabitController>();
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        title: Text(
          'Habit Tracker',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.onMainColor,
          ),
        ),
        centerTitle: true,
        actions: [
          // Calendar icon
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                CalendarBottomSheet(
                  selectedDate: homeController.selectedDate.value,
                  onDateSelected: (date) {
                    homeController.updateSelectedDate(date);
                  },
                ),
                isScrollControlled: true,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.calendar_today,
                color: AppColors.onMainSecondary,
              ),
            ),
          ),
          // Add button
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                const AddItemBottomSheet(),
                isScrollControlled: true,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.blue.shade300,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final habits = homeController.getHabitsForSelectedDate();
          final habitsForDate = habitController.getHabitsForDate(
            homeController.selectedDate.value,
          );
          final hasCategorizedHabits = habitsForDate.any(
            (habit) => habit.categoryId.trim().isNotEmpty,
          );
          final availableCategories = homeController
              .getAvailableCategoriesForSelectedDate();
          final totalHabits = homeController.getTotalHabitsForSelectedDate();
          final completedHabits = homeController
              .getCompletedHabitsForSelectedDate();

          if (!hasCategorizedHabits &&
              homeController.selectedCategoryId.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (homeController.selectedCategoryId.value != null) {
                homeController.selectCategory(null);
              }
            });
          }

          return Column(
            children: [
              // 7-day week selector
              WeekDaySelector(
                selectedDate: homeController.selectedDate.value,
                onDateSelected: (date) {
                  homeController.updateSelectedDate(date);
                },
              ),

              // Category filter
              if (hasCategorizedHabits && availableCategories.isNotEmpty)
                CategoryFilterWidget(
                  selectedCategoryId: homeController.selectedCategoryId.value,
                  categories: availableCategories,
                  onCategorySelected: (categoryId) {
                    homeController.selectCategory(categoryId);
                  },
                ),

              // Progress bar
              if (totalHabits > 0)
                ProgressBarWidget(
                  completedCount: completedHabits,
                  totalCount: totalHabits,
                ),

              // Habits list
              Expanded(
                child: habits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 64,
                              color: AppColors.inActiveColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No habits for this day',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                Get.bottomSheet(
                                  const AddItemBottomSheet(),
                                  isScrollControlled: true,
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Create Habit'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final habit = habits[index];
                          final category = categoryController.getCategoryById(
                            habit.categoryId,
                          );
                          final timerRemainingSeconds =
                              habit.questionType == HabitQuestionType.time
                              ? homeController.getTimeRemainingSeconds(
                                  habit,
                                  homeController.selectedDate.value,
                                )
                              : null;
                          final isTimeRunning =
                              habit.questionType == HabitQuestionType.time
                              ? homeController.isTimeCountdownRunning(
                                  habit.id,
                                  homeController.selectedDate.value,
                                )
                              : false;
                          final completion = habitController.getCompletion(
                            habit.id,
                            homeController.selectedDate.value,
                          );

                          return HabitCardWidget(
                            habit: habit,
                            category: category,
                            completion: completion,
                            selectedDate: homeController.selectedDate.value,
                            isFutureDate: homeController.isFutureDate,
                            timeRemainingSeconds: timerRemainingSeconds,
                            isTimeRunning: isTimeRunning,
                            onTap: () => _handleHabitTap(
                              context,
                              habitController,
                              homeController,
                              habit,
                            ),
                            onCircleTap: () => _handleCircleTap(
                              context,
                              habitController,
                              homeController,
                              habit,
                            ),
                            onLongPress: () => _handleHabitLongPress(
                              habitController,
                              habit,
                              homeController.selectedDate.value,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
