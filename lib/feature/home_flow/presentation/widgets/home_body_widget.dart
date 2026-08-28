import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/services/local_notification_service.dart';
import 'package:habit/feature/habit_flow/controllers/habit_controller.dart';
import 'package:habit/feature/habit_flow/model/habit_model.dart';
import 'package:habit/feature/home_flow/model/task.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/home_flow/presentation/widgets/category_filter_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/habit_card_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/notification_time_picker_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/progress_bar_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/task_action_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/task_progress_card_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/week_day_selector.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';
import 'package:habit/feature/task_flow/bindings/task_flow_binding.dart';
import 'package:habit/feature/task_flow/screens/task_creation_screen.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({
    super.key,
    required this.homeController,
    required this.habitController,
    required this.categoryController,
    required this.onHabitTap,
    required this.onCircleTap,
    required this.onHabitLongPress,
  });

  final HomeController homeController;
  final HabitController habitController;
  final CategoryController categoryController;
  final ValueChanged<HabitModel> onHabitTap;
  final ValueChanged<HabitModel> onCircleTap;
  final ValueChanged<HabitModel> onHabitLongPress;

  Future<void> _configureTaskReminder(
    BuildContext context,
    HomeController homeController,
    Task task,
  ) async {
    final result = await Get.bottomSheet<List<String>>(
      NotificationTimePickerBottomSheet(
        initialTimes: task.notificationTimes,
        habitName: task.description,
      ),
      isScrollControlled: true,
      isDismissible: true,
    );

    if (result == null) return;

    final updatedTimes = result.toSet().toList()..sort();
    final updatedTask = task.copyWith(
      notificationEnabled: updatedTimes.isNotEmpty,
      notificationTimes: updatedTimes,
    );

    await homeController.updateTask(updatedTask);

    if (updatedTimes.isEmpty) {
      await LocalNotificationService.cancelTaskNotifications(task.id);
      Get.snackbar(
        'Reminder Off',
        'Task reminders removed.',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    await LocalNotificationService.scheduleTaskNotifications(
      taskId: task.id,
      taskName: task.description,
      times: updatedTimes,
      selectedDays: task.selectedDays,
    );

    Get.snackbar(
      'Reminder Set',
      '${updatedTimes.length} reminder${updatedTimes.length > 1 ? 's' : ''} configured.',
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
    );
  }

  void _confirmDeleteTask(HomeController homeController, Task task) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.mainColor,
        title: Text(
          'Delete Task',
          style: TextStyle(color: AppColors.onMainColor),
        ),
        content: Text(
          'Are you sure you want to delete "${task.description}"?',
          style: TextStyle(color: AppColors.onMainSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await LocalNotificationService.cancelTaskNotifications(task.id);
              await homeController.deleteTask(task.id);
              Get.close(2); // closes confirm dialog + action bottom sheet
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTaskBottomSheet(
    BuildContext context,
    HomeController homeController,
    Task task,
    VoidCallback onConfigureReminder,
    VoidCallback onDelete,
  ) {
    final completedCount = homeController.getTaskProgressForDate(
      task,
      homeController.selectedDate.value,
    );

    Get.bottomSheet(
      TaskActionBottomSheet(
        completedCount: completedCount,
        totalCount: task.frequency,
        onUndoProgress: () {
          homeController.decrementTaskProgress(
            task,
            homeController.selectedDate.value,
          );
        },
        onEdit: () {
          Get.to(
            () => TaskCreationScreen(taskToEdit: task),
            binding: TaskFlowBinding(),
          );
        },
        onSetNotification: onConfigureReminder,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final habits = homeController.getHabitsForSelectedDate();
      final tasks = homeController.getTasksForSelectedDay();
      final habitsForDate = habitController.getHabitsForDate(
        homeController.selectedDate.value,
      );
      final hasCategorizedItems =
          habitsForDate.any((habit) => habit.categoryId.trim().isNotEmpty) ||
          tasks.isNotEmpty;
      final availableCategories = homeController
          .getAvailableCategoriesForSelectedDate();
      final totalHabits = homeController.getTotalHabitsForSelectedDate();
      final totalTasks = tasks.length;
      final totalItems = totalHabits + totalTasks;
      final overallProgress = homeController.getOverallProgressForSelectedDate();

      if (!hasCategorizedItems &&
          homeController.selectedCategoryId.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (homeController.selectedCategoryId.value != null) {
            homeController.selectCategory(null);
          }
        });
      }

      return Column(
        children: [
          WeekDaySelector(
            selectedDate: homeController.selectedDate.value,
            onDateSelected: (date) {
              homeController.updateSelectedDate(date);
            },
          ),
          if (availableCategories.isNotEmpty)
            CategoryFilterWidget(
              selectedCategoryId: homeController.selectedCategoryId.value,
              categories: availableCategories,
              onCategorySelected: (categoryId) {
                homeController.selectCategory(categoryId);
              },
            ),
          if (totalItems > 0)
            ProgressBarWidget(
              progressRatio: overallProgress,
              totalItems: totalItems,
            ),
          Expanded(
            child: habits.isEmpty && tasks.isEmpty
                ? const _EmptyItemsView()
                : _HomeItemsListView(
                    habits: habits,
                    tasks: tasks,
                    homeController: homeController,
                    habitController: habitController,
                    categoryController: categoryController,
                    onHabitTap: onHabitTap,
                    onCircleTap: onCircleTap,
                    onHabitLongPress: onHabitLongPress,
                    onConfigureTaskReminder: (task) =>
                        _configureTaskReminder(context, homeController, task),
                    onDeleteTask: (task) =>
                        _confirmDeleteTask(homeController, task),
                    onTaskLongPress: (task) => _showTaskBottomSheet(
                      context,
                      homeController,
                      task,
                      () =>
                          _configureTaskReminder(context, homeController, task),
                      () => _confirmDeleteTask(homeController, task),
                    ),
                  ),
          ),
        ],
      );
    });
  }
}

class _EmptyItemsView extends StatelessWidget {
  const _EmptyItemsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 64, color: AppColors.inActiveColor),
          const SizedBox(height: 16),
          Text(
            'No habits or tasks for this day',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _HomeItemsListView extends StatelessWidget {
  const _HomeItemsListView({
    required this.habits,
    required this.tasks,
    required this.homeController,
    required this.habitController,
    required this.categoryController,
    required this.onHabitTap,
    required this.onCircleTap,
    required this.onHabitLongPress,
    required this.onConfigureTaskReminder,
    required this.onDeleteTask,
    required this.onTaskLongPress,
  });

  final List<HabitModel> habits;
  final List<Task> tasks;
  final HomeController homeController;
  final HabitController habitController;
  final CategoryController categoryController;
  final ValueChanged<HabitModel> onHabitTap;
  final ValueChanged<HabitModel> onCircleTap;
  final ValueChanged<HabitModel> onHabitLongPress;
  final ValueChanged<Task> onConfigureTaskReminder;
  final ValueChanged<Task> onDeleteTask;
  final ValueChanged<Task> onTaskLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      children: [
        if (habits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              'Habits',
              style: TextStyle(
                color: AppColors.onMainSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ...habits.map((habit) {
          final category = categoryController.getCategoryById(habit.categoryId);
          final timerRemainingSeconds =
              habit.questionType == HabitQuestionType.time
              ? homeController.getTimeRemainingSeconds(
                  habit,
                  homeController.selectedDate.value,
                )
              : null;
          final isTimeRunning = habit.questionType == HabitQuestionType.time
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
            onTap: () => onHabitTap(habit),
            onCircleTap: () => onCircleTap(habit),
            onLongPress: () => onHabitLongPress(habit),
          );
        }),
        if (tasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Tasks',
              style: TextStyle(
                color: AppColors.onMainSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ...tasks.map((task) {
          final completedCount = homeController.getTaskProgressForDate(
            task,
            homeController.selectedDate.value,
          );

          return TaskProgressCardWidget(
            task: task,
            completedCount: completedCount,
            onIncrement: () => homeController.incrementTaskProgress(
              task,
              homeController.selectedDate.value,
            ),
            onDecrement: () => homeController.decrementTaskProgress(
              task,
              homeController.selectedDate.value,
            ),
            onReminderTap: () => onConfigureTaskReminder(task),
            onDelete: () => onDeleteTask(task),
            onLongPress: () => onTaskLongPress(task),
          );
        }),
      ],
    );
  }
}
