import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/services/local_notification_service.dart';
import '../model/habit_model.dart';
import 'habit_controller.dart';

class HabitCreationFormController extends GetxController {
  HabitCreationFormController({this.habitToEdit});

  final HabitModel? habitToEdit;
  final habitNameController = TextEditingController();

  HabitQuestionType? selectedQuestionType;
  String selectedCategoryId = '';
  List<bool> repeatDays = [true, true, true, true, true, true, true];
  int targetValue = 0;
  int timeDurationMinutes = 0;
  bool reminderEnabled = false;
  List<String> notificationTimes = <String>[];

  bool get isEditMode => habitToEdit != null;

  @override
  void onInit() {
    super.onInit();
    if (habitToEdit != null) {
      _loadHabitData(habitToEdit!);
    } else {
      selectedQuestionType = HabitQuestionType.yesNo;
    }
  }

  void _loadHabitData(HabitModel habit) {
    habitNameController.text = habit.name;
    selectedQuestionType = habit.questionType;
    selectedCategoryId = habit.categoryId;
    repeatDays = List<bool>.from(habit.repeatDays);
    targetValue = habit.targetValue;
    timeDurationMinutes = habit.timeDurationMinutes;
    reminderEnabled = habit.notificationTimes.isNotEmpty;
    notificationTimes = List.from(habit.notificationTimes);
    update();
  }

  void setQuestionType(HabitQuestionType type) {
    if (isEditMode && habitToEdit != null) {
      selectedQuestionType = habitToEdit!.questionType;
      update();
      return;
    }

    selectedQuestionType = type;
    update();
  }

  void setCategoryId(String categoryId) {
    selectedCategoryId = categoryId.trim();
    update();
  }

  void setRepeatDays(List<bool> days) {
    repeatDays = days;
    update();
  }

  void setTargetValue(int value) {
    targetValue = value;
    update();
  }

  void setTimeDurationMinutes(int value) {
    timeDurationMinutes = value;
    update();
  }

  void setReminderEnabled(bool value) {
    reminderEnabled = value;
    if (!value) {
      notificationTimes = <String>[];
    }
    update();
  }

  void addNotificationTime(String time) {
    if (notificationTimes.contains(time)) return;
    notificationTimes = [...notificationTimes, time]..sort();
    update();
  }

  void removeNotificationTime(String time) {
    notificationTimes = notificationTimes.where((t) => t != time).toList();
    update();
  }

  Future<bool> submit() async {
    if (selectedQuestionType == null) {
      Get.snackbar(
        'Error',
        'Please select a question type',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    if (habitNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a habit name',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    final effectiveQuestionType = isEditMode && habitToEdit != null
        ? habitToEdit!.questionType
        : selectedQuestionType!;

    final habitController = Get.find<HabitController>();
    HabitModel? habit;

    if (isEditMode) {
      habit = habitController.updateHabit(
        habitId: habitToEdit!.id,
        name: habitNameController.text,
        questionType: effectiveQuestionType,
        categoryId: selectedCategoryId,
        repeatDays: repeatDays,
        targetValue: targetValue,
        timeDurationMinutes: timeDurationMinutes,
        notificationTimes: reminderEnabled ? notificationTimes : [],
      );
    } else {
      habit = habitController.addHabit(
        name: habitNameController.text,
        questionType: effectiveQuestionType,
        categoryId: selectedCategoryId,
        repeatDays: repeatDays,
        targetValue: targetValue,
        timeDurationMinutes: timeDurationMinutes,
        notificationTimes: reminderEnabled ? notificationTimes : [],
      );
    }

    if (habit == null) return false;

    // Schedule notification if enabled
    if (reminderEnabled && notificationTimes.isNotEmpty) {
      await _scheduleNotifications(habit);
    } else {
      // Cancel notifications if reminder is disabled
      await LocalNotificationService.cancelHabitNotifications(habit.id);
    }

    return true;
  }

  Future<void> _scheduleNotifications(HabitModel habit) async {
    await LocalNotificationService.scheduleHabitNotifications(
      habitId: habit.id,
      habitName: habit.name,
      times: notificationTimes,
      repeatDays: repeatDays,
    );
  }

  @override
  void onClose() {
    habitNameController.dispose();
    super.onClose();
  }
}
