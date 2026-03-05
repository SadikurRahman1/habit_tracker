import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/category_icons.dart';
import 'package:habit/core/models/category_model.dart';
import 'package:habit/feature/habit_flow/model/habit_completion.dart';
import 'package:habit/feature/habit_flow/model/habit_model.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';

class HabitCardWidget extends StatelessWidget {
  final HabitModel habit;
  final CategoryModel? category;
  final HabitCompletion? completion;
  final DateTime selectedDate;
  final Function() onTap;
  final Function() onLongPress;
  final Function()? onCircleTap;
  final int? timeRemainingSeconds;
  final bool isTimeRunning;
  final bool isFutureDate;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    required this.category,
    this.completion,
    required this.selectedDate,
    required this.onTap,
    required this.onLongPress,
    this.onCircleTap,
    this.timeRemainingSeconds,
    this.isTimeRunning = false,
    this.isFutureDate = false,
  }) : super(key: key);

  String _getSubtitle() {
    if (isFutureDate) {
      return 'Scheduled';
    }

    switch (habit.questionType) {
      case HabitQuestionType.numeric:
        final current = completion?.numericValue ?? 0;
        return '$current/${habit.targetValue}';
      case HabitQuestionType.time:
        if (_isCompleted) {
          return 'Completed';
        }

        final targetSeconds = habit.timeDurationMinutes * 60;
        final fallbackRemaining =
            targetSeconds - ((completion?.timeMinutes ?? 0) * 60);
        final remaining = (timeRemainingSeconds ?? fallbackRemaining)
            .clamp(0, targetSeconds)
            .toInt();

        if (remaining <= 0) {
          return 'Completed';
        }

        return '${_formatSeconds(remaining)} left${isTimeRunning ? ' • Running' : ' • Paused'}';
      case HabitQuestionType.text:
        return completion?.textAnswer ?? 'No answer yet';
      case HabitQuestionType.yesNo:
        return completion?.isCompleted == true ? 'Completed' : 'Not completed';
    }
  }

  String _formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool get _isCompleted {
    if (completion == null) return false;

    switch (habit.questionType) {
      case HabitQuestionType.yesNo:
        return completion!.isCompleted;
      case HabitQuestionType.numeric:
        return (completion!.numericValue ?? 0) >= habit.targetValue;
      case HabitQuestionType.time:
        return (completion!.timeMinutes ?? 0) >= habit.timeDurationMinutes;
      case HabitQuestionType.text:
        return completion!.textAnswer != null &&
            completion!.textAnswer!.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryIcon = category != null
        ? CategoryIcons.icons[category!.icon]
        : Icons.help_outline;
    final categoryColor = category?.getColor() ?? Colors.grey;
    final isTimeHabit = habit.questionType == HabitQuestionType.time;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 28),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (habit.questionType == HabitQuestionType.time)
                    Obx(() {
                      final homeController = Get.find<HomeController>();
                      final timerRemaining = homeController
                          .getTimeRemainingSeconds(habit, selectedDate);
                      final isRunning = homeController.isTimeCountdownRunning(
                        habit.id,
                        selectedDate,
                      );
                      final targetSeconds = habit.timeDurationMinutes * 60;
                      final remaining = timerRemaining
                          .clamp(0, targetSeconds)
                          .toInt();

                      if (remaining <= 0) {
                        return Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }

                      return Text(
                        '${_formatSeconds(remaining)} left${isRunning ? ' • Running' : ' • Paused'}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    })
                  else
                    Text(
                      _getSubtitle(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Completion status icon - clickable circle
            GestureDetector(
              onTap: !isFutureDate ? onCircleTap : null,
              child: _isCompleted
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.2),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 22,
                      ),
                    )
                  : isTimeHabit
                  ? Obx(() {
                      final homeController = Get.find<HomeController>();
                      final isTimeRunningNow = homeController
                          .isTimeCountdownRunning(habit.id, selectedDate);

                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTimeRunningNow
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: isTimeRunningNow
                                ? Colors.blue
                                : Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isTimeRunningNow ? Icons.pause : Icons.play_arrow,
                          color: isTimeRunningNow
                              ? Colors.blue
                              : Colors.white.withOpacity(0.4),
                          size: 20,
                        ),
                      );
                    })
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white.withOpacity(0.4),
                        size: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
