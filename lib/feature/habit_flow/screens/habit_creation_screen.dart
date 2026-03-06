import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../controllers/habit_creation_form_controller.dart';
import '../model/habit_model.dart';
import '../widgets/category_selector.dart';
import '../widgets/numeric_value_input.dart';
import '../widgets/question_type_selector.dart';
import '../widgets/repeat_days_selector.dart';
import '../widgets/time_duration_picker.dart';

class HabitCreationScreen extends StatelessWidget {
  final HabitModel? habitToEdit;

  const HabitCreationScreen({Key? key, this.habitToEdit}) : super(key: key);

  void _handleSubmit(
    BuildContext context,
    HabitCreationFormController formController,
  ) {
    final isEditMode = formController.isEditMode;
    final habitName = formController.habitNameController.text.trim();
    final success = formController.submit();

    if (!success) return;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Get.back();
    }

    Future.delayed(const Duration(milliseconds: 120), () {
      Get.snackbar(
        'Success',
        isEditMode
            ? 'Habit updated successfully'
            : 'Habit "$habitName" created successfully',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.success,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HabitCreationFormController>(
      init: HabitCreationFormController(habitToEdit: habitToEdit),
      global: false,
      builder: (formController) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            elevation: 0,
            title: Text(
              formController.isEditMode ? 'Edit Habit' : 'Create New Habit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onMainColor,
              ),
            ),
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back, color: AppColors.onMainColor),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      border: Border.all(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Fields marked with * are required',
                      style: TextStyle(fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuestionTypeSelector(
                    selectedType: formController.selectedQuestionType,
                    onSelected: formController.setQuestionType,
                    isEnabled: !formController.isEditMode,
                  ),
                  if (formController.isEditMode) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Question type cannot be changed while editing.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Habit Name *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: formController.habitNameController,
                    style: TextStyle(color: AppColors.primaryText),
                    decoration: InputDecoration(
                      hintText: 'e.g., Morning Run, Read Books, Drink Water',
                      hintStyle: TextStyle(color: AppColors.secondaryText),
                      filled: true,
                      fillColor: AppColors.inputFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (formController.selectedQuestionType ==
                      HabitQuestionType.numeric) ...[
                    NumericValueInput(
                      targetValue: formController.targetValue,
                      onValueChanged: formController.setTargetValue,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (formController.selectedQuestionType ==
                      HabitQuestionType.time) ...[
                    TimeDurationPicker(
                      timeDurationMinutes: formController.timeDurationMinutes,
                      onDurationChanged: formController.setTimeDurationMinutes,
                    ),
                    const SizedBox(height: 24),
                  ],
                  CategorySelector(
                    selectedCategoryId:
                        formController.selectedCategoryId.isEmpty
                        ? null
                        : formController.selectedCategoryId,
                    onCategorySelected: formController.setCategoryId,
                  ),
                  const SizedBox(height: 24),
                  RepeatDaysSelector(
                    repeatDays: formController.repeatDays,
                    onDaysChanged: formController.setRepeatDays,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.overlayColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _handleSubmit(context, formController),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            formController.isEditMode
                                ? 'Update Habit'
                                : 'Create Habit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
