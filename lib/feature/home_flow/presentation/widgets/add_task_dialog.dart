import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../../model/task.dart';
import '../controllers/home_controller.dart';

class AddTaskDialog extends StatelessWidget {
  final titleController = TextEditingController();
  final targetValueController = TextEditingController();

  final selectedCategory = TaskCategory.other.obs;
  final selectedPriority = TaskPriority.medium.obs;
  final selectedTaskType = TaskType.descriptionOnly.obs;
  final selectedTimerMinutes = 5.obs;
  final selectedDays = <int>{1, 2, 3, 4, 5, 6, 7}.obs;

  AddTaskDialog({Key? key}) : super(key: key);

  void _addTask() {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter task title',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedDays.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one day',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedTaskType.value == TaskType.integerTarget &&
        targetValueController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter target value',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedTaskType.value == TaskType.timer && selectedTimerMinutes.value == 0) {
      Get.snackbar(
        'Error',
        'Please select timer duration',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    int targetValue = int.tryParse(targetValueController.text) ?? 1;

    final homeController = Get.find<HomeController>();
    homeController.addTask(
      description: titleController.text,
      category: selectedCategory.value,
      priority: selectedPriority.value,
      taskType: selectedTaskType.value,
      question: null,
      targetValue: targetValue,
      timerDurationInSeconds: selectedTaskType.value == TaskType.timer ? selectedTimerMinutes.value * 60 : 0,
      selectedDays: selectedDays.toList()..sort(),
    );

    titleController.dispose();
    targetValueController.dispose();

    Get.back();
    Get.snackbar(
      'Success',
      'Task added successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: selectedTimerMinutes.value),
    );
    
    if (picked != null) {
      int totalMinutes = picked.hour * 60 + picked.minute;
      if (totalMinutes == 0) totalMinutes = 5;
      selectedTimerMinutes.value = totalMinutes;
    }
  }

  String _formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCategoryChip(TaskCategory category) {
    return Obx(() {
      final isSelected = selectedCategory.value == category;
      return GestureDetector(
        onTap: () => selectedCategory.value = category,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? category.color : category.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: category.color),
          ),
          child: Text(
            category.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPriorityChip(TaskPriority priority, String label) {
    return Expanded(
      child: Obx(() {
        final isSelected = selectedPriority.value == priority;
        final color = priority.color;

        return GestureDetector(
          onTap: () => selectedPriority.value = priority,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTaskTypeButton(
    TaskType type,
    String title,
    String description,
  ) {
    return Obx(() {
      final isSelected = selectedTaskType.value == type;
      return GestureDetector(
        onTap: () => selectedTaskType.value = type,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue : AppColors.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.white54,
                  ),
                  color: isSelected ? Colors.blue : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDayCircle(int dayNumber, String dayLabel) {
    return Obx(() {
      final isSelected = selectedDays.contains(dayNumber);
      return GestureDetector(
        onTap: () {
          if (isSelected) {
            selectedDays.remove(dayNumber);
          } else {
            selectedDays.add(dayNumber);
          }
          selectedDays.refresh();
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.blue : Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.blue : AppColors.borderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              dayLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // 1. Title/Task Name
              _buildLabel('Task Title *'),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Drink water, Exercise, Read',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
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
              const SizedBox(height: 16),

              // 2. Category Selection
              _buildLabel('Category *'),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip(TaskCategory.health),
                    const SizedBox(width: 8),
                    _buildCategoryChip(TaskCategory.work),
                    const SizedBox(width: 8),
                    _buildCategoryChip(TaskCategory.exercise),
                    const SizedBox(width: 8),
                    _buildCategoryChip(TaskCategory.learning),
                    const SizedBox(width: 8),
                    _buildCategoryChip(TaskCategory.personal),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Priority Selection
              _buildLabel('Priority *'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityChip(TaskPriority.low, 'Low'),
                  const SizedBox(width: 8),
                  _buildPriorityChip(TaskPriority.medium, 'Medium'),
                  const SizedBox(width: 8),
                  _buildPriorityChip(TaskPriority.high, 'High'),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Select Week/Days
              _buildLabel('Select Days of Week *'),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDayCircle(1, 'M'),
                    const SizedBox(width: 8),
                    _buildDayCircle(2, 'T'),
                    const SizedBox(width: 8),
                    _buildDayCircle(3, 'W'),
                    const SizedBox(width: 8),
                    _buildDayCircle(4, 'T'),
                    const SizedBox(width: 8),
                    _buildDayCircle(5, 'F'),
                    const SizedBox(width: 8),
                    _buildDayCircle(6, 'S'),
                    const SizedBox(width: 8),
                    _buildDayCircle(7, 'S'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 5. Task Type Selection
              _buildLabel('Task Type *'),
              const SizedBox(height: 8),
              Column(
                children: [
                  _buildTaskTypeButton(
                    TaskType.descriptionOnly,
                    'Task',
                    'Simple checkbox task',
                  ),
                  const SizedBox(height: 8),
                  _buildTaskTypeButton(
                    TaskType.yesNo,
                    'Yes/No',
                    'Click to mark complete',
                  ),
                  const SizedBox(height: 8),
                  _buildTaskTypeButton(
                    TaskType.writeAnswer,
                    'Write Answer',
                    'Write your answer',
                  ),
                  const SizedBox(height: 8),
                  _buildTaskTypeButton(
                    TaskType.integerTarget,
                    'Integer Target',
                    'Track progress to target',
                  ),
                  const SizedBox(height: 8),
                  _buildTaskTypeButton(
                    TaskType.timer,
                    'Timer Task',
                    'Task with timer countdown',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Target Value field (for integerTarget)
              Obx(() => selectedTaskType.value == TaskType.integerTarget
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Target Value *'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: targetValueController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'e.g., 5 (for 5 glasses of water)',
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white10,
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
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink()),

              // Timer Duration Selection (for timer type)
              Obx(() => selectedTaskType.value == TaskType.timer
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Timer Duration *'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _showTimePicker(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, color: Colors.white70),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Obx(() => Text(
                                    'Selected: ${_formatDuration(selectedTimerMinutes.value)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )),
                                ),
                                const Icon(Icons.edit, color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink()),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        titleController.dispose();
                        targetValueController.dispose();
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _addTask,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Add Task',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
