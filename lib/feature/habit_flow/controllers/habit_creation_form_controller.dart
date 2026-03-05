import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  bool get isEditMode => habitToEdit != null;

  @override
  void onInit() {
    super.onInit();
    if (habitToEdit != null) {
      _loadHabitData(habitToEdit!);
    }
  }

  void _loadHabitData(HabitModel habit) {
    habitNameController.text = habit.name;
    selectedQuestionType = habit.questionType;
    selectedCategoryId = habit.categoryId;
    repeatDays = List<bool>.from(habit.repeatDays);
    targetValue = habit.targetValue;
    timeDurationMinutes = habit.timeDurationMinutes;
    update();
  }

  void setQuestionType(HabitQuestionType type) {
    selectedQuestionType = type;
    update();
  }

  void setCategoryId(String categoryId) {
    selectedCategoryId = categoryId;
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

  bool submit() {
    if (selectedQuestionType == null) {
      Get.snackbar(
        'Error',
        'Please select a question type',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (habitNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a habit name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedCategoryId.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final habitController = Get.find<HabitController>();

    if (isEditMode) {
      return habitController.updateHabit(
        habitId: habitToEdit!.id,
        name: habitNameController.text,
        questionType: selectedQuestionType!,
        categoryId: selectedCategoryId,
        repeatDays: repeatDays,
        targetValue: targetValue,
        timeDurationMinutes: timeDurationMinutes,
      );
    }

    return habitController.addHabit(
      name: habitNameController.text,
      questionType: selectedQuestionType!,
      categoryId: selectedCategoryId,
      repeatDays: repeatDays,
      targetValue: targetValue,
      timeDurationMinutes: timeDurationMinutes,
    );
  }

  @override
  void onClose() {
    habitNameController.dispose();
    super.onClose();
  }
}
