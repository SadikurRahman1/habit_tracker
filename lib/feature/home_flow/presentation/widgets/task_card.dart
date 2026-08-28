import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/exported_files/exported_file.dart';
import 'package:habit/core/services/local_notification_service.dart';
import 'package:habit/core/wrappers/responsive_card.dart';
import '../../model/task.dart';
import '../controllers/timer_controller.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final Function(Task) onTaskUpdate;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onTaskUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();

    // Auto-start timer if needed
    if (task.taskType == TaskType.timer &&
        task.timerRemainingSeconds == 0 &&
        task.timerDurationInSeconds > 0 &&
        !task.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final updatedTask = task.copyWith(
          timerRemainingSeconds: task.timerDurationInSeconds,
        );
        onTaskUpdate(updatedTask);
        timerController.autoStartTimerIfNeeded(updatedTask);
      });
    } else if (task.taskType == TaskType.timer &&
        task.isTimerActive &&
        !timerController.isTimerActive(task.id)) {
      // Resume timer if it was active
      WidgetsBinding.instance.addPostFrameCallback((_) {
        timerController.startTimer(task);
      });
    }

    return ResponsiveCard(
      borderColor: AppColors.borderColor,
      backgroundColor: AppColors.mainColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title, priority and delete button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left section: checkbox/content and title
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox for description only type
                    if (task.taskType == TaskType.descriptionOnly)
                      Padding(
                        padding: const EdgeInsets.only(right: 12, top: 2),
                        child: _buildCheckbox(context),
                      ),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: task.isFullyCompleted
                                  ? Colors.white54
                                  : Colors.white,
                              decoration: task.isFullyCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Right section: priority badge and action menu
              Row(
                children: [
                  // Priority badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: task.priority.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.priority.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ResponsiveSpace(12),
                  // 3-dot menu
                  GestureDetector(
                    onTap: () => _showTaskActionsBottomSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content based on task type
          _buildTaskTypeContent(context, timerController),
        ],
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        onTaskUpdate(updatedTask);
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.isCompleted ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _buildTaskTypeContent(
    BuildContext context,
    TimerController timerController,
  ) {
    switch (task.taskType) {
      case TaskType.descriptionOnly:
        return const SizedBox.shrink();

      case TaskType.yesNo:
        return GestureDetector(
          onTap: () {
            final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
            onTaskUpdate(updatedTask);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.help_outline,
                  color: task.isCompleted ? Colors.green : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.isCompleted ? 'Completed' : 'Tap to complete',
                    style: TextStyle(
                      fontSize: 13,
                      color: task.isCompleted ? Colors.white70 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case TaskType.writeAnswer:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                task.answerText != null ? Icons.check_circle : Icons.edit,
                color: task.answerText != null ? Colors.green : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.answerText ?? 'No answer yet',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: task.answerText != null
                            ? Colors.white
                            : Colors.white70,
                        fontStyle: task.answerText == null
                            ? FontStyle.italic
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case TaskType.integerTarget:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${task.currentProgress}/${task.targetValue}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: task.completionPercentage,
                minHeight: 12,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(
                  task.isFullyCompleted ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ],
        );

      case TaskType.timer:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                timerController.formatTime(task.timerRemainingSeconds),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (!task.isTimerActive)
                    ElevatedButton.icon(
                      onPressed: () => timerController.startTimer(task),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => timerController.pauseTimer(task),
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () => timerController.resetTimer(task),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => timerController.completeTimer(task),
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }

  String _answerActionLabel() {
    switch (task.taskType) {
      case TaskType.descriptionOnly:
        return task.isCompleted ? 'Mark Incomplete' : 'Mark Complete';
      case TaskType.yesNo:
        return 'Answer Question';
      case TaskType.writeAnswer:
        return 'Write Answer';
      case TaskType.integerTarget:
        return 'Update Progress';
      case TaskType.timer:
        return 'Timer';
    }
  }

  void _handleAnswerAction(BuildContext context) {
    switch (task.taskType) {
      case TaskType.descriptionOnly:
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        onTaskUpdate(updatedTask);
        break;
      case TaskType.yesNo:
        showYesNoDialog(context);
        break;
      case TaskType.writeAnswer:
        showWriteAnswerDialog(context);
        break;
      case TaskType.integerTarget:
        showIntegerProgressDialog(context);
        break;
      case TaskType.timer:
        // For timer tasks, timer controls are in the task card itself
        break;
    }
  }

  Future<void> _toggleLocalNotification() async {
    final shouldEnable = !task.notificationEnabled;
    final updatedTask = task.copyWith(notificationEnabled: shouldEnable);

    onTaskUpdate(updatedTask);

    if (shouldEnable) {
      await LocalNotificationService.scheduleDailyTaskNotification(
        taskId: updatedTask.id,
        title: 'Habit Reminder',
        body: updatedTask.description,
      );
      Get.snackbar(
        'Notification On',
        'Local notification enabled for this task',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      await LocalNotificationService.cancelTaskNotification(updatedTask.id);
      Get.snackbar(
        'Notification Off',
        'Local notification turned off for this task',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _showTaskActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.mainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                _buildBottomActionTile(
                  icon: Icons.question_answer_outlined,
                  title: _answerActionLabel(),
                  onTap: () {
                    Navigator.pop(context);
                    _handleAnswerAction(context);
                  },
                ),
                _buildBottomActionTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit Task',
                  onTap: () {
                    Navigator.pop(context);
                    _showEditTaskDialog(context);
                  },
                ),
                _buildBottomActionTile(
                  icon: task.notificationEnabled
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_active_outlined,
                  title: task.notificationEnabled
                      ? 'Turn Off Notification'
                      : 'Turn On Notification',
                  onTap: () async {
                    Navigator.pop(context);
                    await _toggleLocalNotification();
                  },
                ),
                _buildBottomActionTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Task',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context) {
    final descriptionController = TextEditingController(text: task.description);
    final questionController = TextEditingController(text: task.question ?? '');
    final targetController = TextEditingController(
      text: task.targetValue.toString(),
    );

    TaskPriority selectedPriority = task.priority;
    final selectedDays = task.selectedDays.toSet();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                    'Edit Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Task Title',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Task title',
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
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: TaskPriority.values.map((priority) {
                      final isSelected = selectedPriority == priority;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedPriority = priority;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: priority == TaskPriority.high ? 0 : 8,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? priority.color
                                  : priority.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: priority.color),
                            ),
                            child: Center(
                              child: Text(
                                priority.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (task.taskType != TaskType.descriptionOnly) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'Question / Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: questionController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Question/details',
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
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (task.taskType == TaskType.integerTarget) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'Target Integer Value',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter target value',
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
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  const Text(
                    'Days',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildEditDayChip(setDialogState, selectedDays, 1, 'M'),
                        _buildEditDayChip(setDialogState, selectedDays, 2, 'T'),
                        _buildEditDayChip(setDialogState, selectedDays, 3, 'W'),
                        _buildEditDayChip(setDialogState, selectedDays, 4, 'T'),
                        _buildEditDayChip(setDialogState, selectedDays, 5, 'F'),
                        _buildEditDayChip(setDialogState, selectedDays, 6, 'S'),
                        _buildEditDayChip(setDialogState, selectedDays, 7, 'S'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
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
                          onTap: () {
                            final title = descriptionController.text.trim();
                            if (title.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Task title cannot be empty',
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

                            int targetValue = task.targetValue;
                            if (task.taskType == TaskType.integerTarget) {
                              targetValue =
                                  int.tryParse(targetController.text.trim()) ??
                                  1;
                              if (targetValue < 1) {
                                targetValue = 1;
                              }
                            }

                            final updatedTask = task.copyWith(
                              description: title,
                              priority: selectedPriority,
                              question:
                                  task.taskType == TaskType.descriptionOnly
                                  ? null
                                  : (questionController.text.trim().isEmpty
                                        ? null
                                        : questionController.text.trim()),
                              targetValue: targetValue,
                              selectedDays: selectedDays.toList()..sort(),
                            );

                            onTaskUpdate(updatedTask);
                            Navigator.pop(context);
                            Get.snackbar(
                              'Updated',
                              'Task updated successfully',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Save',
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
        ),
      ),
    );
  }

  Widget _buildEditDayChip(
    StateSetter setDialogState,
    Set<int> selectedDays,
    int day,
    String label,
  ) {
    final isSelected = selectedDays.contains(day);
    return GestureDetector(
      onTap: () {
        setDialogState(() {
          if (isSelected) {
            selectedDays.remove(day);
          } else {
            selectedDays.add(day);
          }
        });
      },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blue : AppColors.borderColor,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  void showYesNoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task.question ?? 'Did you complete this task?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final updatedTask = task.copyWith(isCompleted: true);
                        onTaskUpdate(updatedTask);
                        Navigator.pop(context);
                        Get.snackbar(
                          'Done',
                          'Task marked as completed',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Yes',
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No',
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

  void showWriteAnswerDialog(BuildContext context) {
    final TextEditingController answerController = TextEditingController(
      text: task.answerText ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task.question ?? 'Write your answer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: answerController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your answer here...',
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                      onTap: () {
                        if (answerController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter an answer',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        final updatedTask = task.copyWith(
                          answerText: answerController.text,
                        );
                        onTaskUpdate(updatedTask);
                        Navigator.pop(context);
                        Get.snackbar(
                          'Done',
                          'Answer saved',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Save',
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

  void showIntegerProgressDialog(BuildContext context) {
    int selectedProgress = task.currentProgress;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: AppColors.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.question ?? 'Update Progress',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Select value (1 to ${task.targetValue}):',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(task.targetValue, (index) {
                        final value = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() => selectedProgress = value);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: selectedProgress == value
                                  ? Colors.blue
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedProgress == value
                                    ? Colors.blue
                                    : AppColors.borderColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                        onTap: () {
                          final updatedTask = task.copyWith(
                            currentProgress: selectedProgress,
                          );
                          onTaskUpdate(updatedTask);
                          Navigator.pop(context);
                          Get.snackbar(
                            'Updated',
                            'Progress updated to $selectedProgress/${task.targetValue}',
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Update',
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
      ),
    );
  }
}
