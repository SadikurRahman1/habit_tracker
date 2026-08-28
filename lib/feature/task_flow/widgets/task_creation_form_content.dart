import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/habit_flow/widgets/category_selector.dart';
import 'package:habit/feature/habit_flow/widgets/repeat_days_selector.dart';
import 'package:habit/feature/task_flow/controllers/task_creation_form_controller.dart';

class TaskCreationFormContent extends StatelessWidget {
  const TaskCreationFormContent({
    super.key,
    required this.formController,
    required this.onSubmit,
  });

  final TaskCreationFormController formController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Name *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: TextField(
              controller: formController.taskNameController,
              style: TextStyle(color: AppColors.primaryText),
              decoration: InputDecoration(
                hintText: 'e.g., Drink water, Read book',
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
              ),
            ),
          ),
          const SizedBox(height: 20),
          CategorySelector(
            selectedCategoryId: formController.selectedCategoryId,
            onCategorySelected: formController.setCategoryId,
          ),
          const SizedBox(height: 20),
          Text(
            'Frequency *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.inputFillColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: formController.frequency > 1
                        ? formController.decrementFrequency
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Expanded(
                    child: Text(
                      '${formController.frequency} times',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onMainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: formController.frequency < 12
                        ? formController.incrementFrequency
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          RepeatDaysSelector(
            repeatDays: formController.repeatDays,
            onDaysChanged: formController.setRepeatDays,
          ),
          const SizedBox(height: 20),
          SwitchListTile.adaptive(
            value: formController.reminderEnabled,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
            title: Text(
              'Reminder Time',
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              formController.reminderEnabled ? 'On' : 'Off (default)',
              style: TextStyle(color: AppColors.secondaryText),
            ),
            onChanged: formController.setReminderEnabled,
            contentPadding: EdgeInsets.zero,
          ),
          if (formController.reminderEnabled) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => formController.addReminderTime(context),
              icon: const Icon(Icons.add_alarm),
              label: const Text('Add Reminder Time'),
            ),
            const SizedBox(height: 8),
            if (formController.notificationTimes.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: formController.notificationTimes.map((time) {
                  return Chip(
                    label: Text(formController.displayTime(time)),
                    onDeleted: () => formController.removeReminderTime(time),
                  );
                }).toList(),
              ),
          ],
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.onMainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    formController.isEditMode ? 'Update Task' : 'Create Task',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
