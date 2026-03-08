import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../controllers/habit_creation_form_controller.dart';
import '../model/habit_model.dart';
import '../widgets/habit_creation_form_content.dart';

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
          body: HabitCreationFormContent(
            formController: formController,
            onSubmit: () => _handleSubmit(context, formController),
          ),
        );
      },
    );
  }
}
