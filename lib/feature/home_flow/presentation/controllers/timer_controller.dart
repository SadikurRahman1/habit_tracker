import 'dart:async';
import 'package:get/get.dart';
import '../../model/task.dart';
import 'home_controller.dart';

class TimerController extends GetxController {
  final Map<String, Timer> _activeTimers = {};
  final HomeController homeController = Get.find<HomeController>();

  @override
  void onClose() {
    // Cancel all timers when controller is disposed
    for (var timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
    super.onClose();
  }

  void startTimer(Task task) {
    // Cancel existing timer if any
    _activeTimers[task.id]?.cancel();

    // Update task to be active
    _updateTask(task.copyWith(isTimerActive: true));

    // Start new timer
    _activeTimers[task.id] = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      final currentTask = _getTaskById(task.id);
      if (currentTask == null) {
        timer.cancel();
        _activeTimers.remove(task.id);
        return;
      }

      if (currentTask.timerRemainingSeconds > 0) {
        _updateTask(
          currentTask.copyWith(
            timerRemainingSeconds: currentTask.timerRemainingSeconds - 1,
          ),
        );
      } else {
        // Timer completed
        completeTimer(currentTask);
      }
    });
  }

  void pauseTimer(Task task) {
    _activeTimers[task.id]?.cancel();
    _activeTimers.remove(task.id);
    _updateTask(task.copyWith(isTimerActive: false));
  }

  void completeTimer(Task task) {
    _activeTimers[task.id]?.cancel();
    _activeTimers.remove(task.id);
    _updateTask(
      task.copyWith(
        isCompleted: true,
        isTimerActive: false,
        timerRemainingSeconds: 0,
      ),
    );

    Get.snackbar(
      'Completed!',
      'Timer finished - Task completed',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 2),
    );
  }

  void resetTimer(Task task) {
    _activeTimers[task.id]?.cancel();
    _activeTimers.remove(task.id);
    _updateTask(
      task.copyWith(
        isTimerActive: false,
        timerRemainingSeconds: task.timerDurationInSeconds,
        isCompleted: false,
      ),
    );
  }

  void _updateTask(Task updatedTask) {
    homeController.updateTask(updatedTask);
  }

  Task? _getTaskById(String taskId) {
    try {
      return homeController.tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  bool isTimerActive(String taskId) {
    return _activeTimers.containsKey(taskId);
  }

  // Auto-start timer for a task if conditions are met
  void autoStartTimerIfNeeded(Task task) {
    if (task.taskType == TaskType.timer &&
        !task.isCompleted &&
        task.timerRemainingSeconds > 0 &&
        !task.isTimerActive) {
      Future.delayed(const Duration(milliseconds: 100), () {
        startTimer(task);
      });
    }
  }
}
