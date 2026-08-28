import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/services/local_notification_service.dart';
import 'package:habit/feature/home_flow/model/task.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';

class TaskCreationFormController extends GetxController {
  TaskCreationFormController({this.taskToEdit});

  final Task? taskToEdit;
  final taskNameController = TextEditingController();

  String selectedCategoryId = '';
  int frequency = 1;
  List<bool> repeatDays = List<bool>.filled(7, true);
  bool reminderEnabled = false;
  List<String> notificationTimes = <String>[];

  bool get isEditMode => taskToEdit != null;

  @override
  void onInit() {
    super.onInit();
    if (taskToEdit != null) {
      _loadTaskData(taskToEdit!);
    }
  }

  void _loadTaskData(Task task) {
    taskNameController.text = task.description;
    selectedCategoryId = task.categoryId;
    frequency = task.frequency;
    reminderEnabled = task.notificationEnabled;
    notificationTimes = List.from(task.notificationTimes);

    repeatDays = List<bool>.filled(7, false);
    for (final day in task.selectedDays) {
      if (day == 7) {
        repeatDays[0] = true;
      } else {
        repeatDays[day] = true;
      }
    }
    update();
  }

  void setCategoryId(String categoryId) {
    selectedCategoryId = categoryId;
    update();
  }

  void decrementFrequency() {
    if (frequency <= 1) return;
    frequency--;
    update();
  }

  void incrementFrequency() {
    if (frequency >= 12) return;
    frequency++;
    update();
  }

  void setRepeatDays(List<bool> days) {
    repeatDays = days;
    update();
  }

  void setReminderEnabled(bool value) {
    reminderEnabled = value;
    if (!value) {
      notificationTimes = <String>[];
    }
    update();
  }

  void removeReminderTime(String value) {
    notificationTimes = notificationTimes
        .where((time) => time != value)
        .toList();
    update();
  }

  Future<void> addReminderTime(BuildContext context) async {
    if (notificationTimes.length >= 10) {
      Get.snackbar(
        'Limit Reached',
        'You can set up to 10 reminder times.',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    );

    if (picked == null) return;

    final value =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    if (notificationTimes.contains(value)) return;

    notificationTimes = [...notificationTimes, value]..sort();
    update();
  }

  String displayTime(String hhmm) {
    final parts = hhmm.split(':');
    final hour24 = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    return '$hour12:$minute $period';
  }

  Future<bool> submit() async {
    final name = taskNameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Validation',
        'Task name is required.',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return false;
    }

    if (!repeatDays.any((day) => day)) {
      Get.snackbar(
        'Validation',
        'Please select at least one repeat day.',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return false;
    }

    if (reminderEnabled && notificationTimes.isEmpty) {
      Get.snackbar(
        'Validation',
        'Reminder is on, please add at least one time.',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return false;
    }

    final homeController = Get.find<HomeController>();
    final selectedDays = _mapRepeatDaysToSelectedDays(repeatDays);

    final Task task;

    if (taskToEdit != null) {
      final updatedTask = taskToEdit!.copyWith(
        description: name,
        categoryId: selectedCategoryId,
        targetValue: frequency,
        selectedDays: selectedDays,
        notificationEnabled: reminderEnabled,
        notificationTimes: notificationTimes,
      );

      await homeController.updateTask(updatedTask);
      task = updatedTask;
      await LocalNotificationService.cancelTaskNotifications(task.id);
    } else {
      task = await homeController.addTask(
        description: name,
        categoryId: selectedCategoryId,
        priority: TaskPriority.medium,
        taskType: TaskType.integerTarget,
        targetValue: frequency,
        selectedDays: selectedDays,
        notificationEnabled: reminderEnabled,
        notificationTimes: notificationTimes,
      );
    }

    if (reminderEnabled && notificationTimes.isNotEmpty) {
      await LocalNotificationService.scheduleTaskNotifications(
        taskId: task.id,
        taskName: task.description,
        times: notificationTimes,
        selectedDays: selectedDays,
      );
    }

    return true;
  }

  List<int> _mapRepeatDaysToSelectedDays(List<bool> days) {
    final selectedDays = <int>[];
    for (var i = 0; i < days.length; i++) {
      if (!days[i]) continue;
      if (i == 0) {
        selectedDays.add(7);
      } else {
        selectedDays.add(i);
      }
    }
    return selectedDays;
  }

  @override
  void onClose() {
    taskNameController.dispose();
    super.onClose();
  }
}
