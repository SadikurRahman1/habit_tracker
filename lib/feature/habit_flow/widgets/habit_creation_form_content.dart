import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/habit_flow/controllers/habit_creation_form_controller.dart';
import 'package:habit/feature/habit_flow/model/habit_model.dart';
import 'package:habit/feature/habit_flow/widgets/category_selector.dart';
import 'package:habit/feature/habit_flow/widgets/numeric_value_input.dart';
import 'package:habit/feature/habit_flow/widgets/question_type_selector.dart';
import 'package:habit/feature/habit_flow/widgets/repeat_days_selector.dart';
import 'package:habit/feature/habit_flow/widgets/time_duration_picker.dart';

class HabitCreationFormContent extends StatelessWidget {
  const HabitCreationFormContent({
    super.key,
    required this.formController,
    required this.onSubmit,
  });

  final HabitCreationFormController formController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const _RequiredFieldsBanner(),
            // const SizedBox(height: 24),
            _QuestionTypeSection(formController: formController),
            const SizedBox(height: 24),
            _HabitNameSection(formController: formController),
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
              selectedCategoryId: formController.selectedCategoryId.isEmpty
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
            _ReminderTimeSection(formController: formController),
            const SizedBox(height: 32),
            _FormActionButtons(
              isEditMode: formController.isEditMode,
              onSubmit: onSubmit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _RequiredFieldsBanner extends StatelessWidget {
  const _RequiredFieldsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _QuestionTypeSection extends StatelessWidget {
  const _QuestionTypeSection({required this.formController});

  final HabitCreationFormController formController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionTypeSelector(
          selectedType: formController.selectedQuestionType,
          onSelected: formController.setQuestionType,
          isEnabled: !formController.isEditMode,
        ),
        if (formController.isEditMode) ...[
          const SizedBox(height: 8),
          Text(
            'Question type cannot be changed while editing.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
        ],
      ],
    );
  }
}

class _HabitNameSection extends StatelessWidget {
  const _HabitNameSection({required this.formController});

  final HabitCreationFormController formController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habit Name *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
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
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormActionButtons extends StatelessWidget {
  const _FormActionButtons({required this.isEditMode, required this.onSubmit});

  final bool isEditMode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isEditMode ? 'Update Habit' : 'Create Habit',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderTimeSection extends StatelessWidget {
  const _ReminderTimeSection({required this.formController});

  final HabitCreationFormController formController;

  String _displayTime(String hhmm) {
    final parts = hhmm.split(':');
    final hour24 = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    return '$hour12:$minute $period';
  }

  Future<void> _addReminderTime(BuildContext context) async {
    if (formController.notificationTimes.length >= 10) {
      Get.snackbar(
        'Limit Reached',
        'You can set up to 10 reminder times.',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
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

    formController.addNotificationTime(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            onPressed: () => _addReminderTime(context),
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
                  label: Text(_displayTime(time)),
                  onDeleted: () {
                    formController.removeNotificationTime(time);
                  },
                );
              }).toList(),
            ),
        ],
      ],
    );
  }
}
