import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/home_flow/model/task.dart';
import 'package:habit/feature/task_flow/controllers/task_creation_form_controller.dart';
import 'package:habit/feature/task_flow/widgets/task_creation_form_content.dart';

class TaskCreationScreen extends StatelessWidget {
  const TaskCreationScreen({super.key, this.taskToEdit});

  final Task? taskToEdit;

  Future<void> _handleSubmit(TaskCreationFormController formController) async {
    final isEditMode = formController.isEditMode;
    final success = await formController.submit();

    if (!success) return;

    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    }

    Future.delayed(const Duration(milliseconds: 120), () {
      Get.snackbar(
        'Success',
        isEditMode
            ? 'Task updated successfully.'
            : 'Task created successfully.',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskCreationFormController>(
      init: TaskCreationFormController(taskToEdit: taskToEdit),
      global: false,
      builder: (formController) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            elevation: 0,
            title: Text(
              formController.isEditMode ? 'Edit Task' : 'Create Task',
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
          body: TaskCreationFormContent(
            formController: formController,
            onSubmit: () => _handleSubmit(formController),
          ),
        );
      },
    );
  }
}
