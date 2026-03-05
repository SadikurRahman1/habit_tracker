import 'package:flutter/material.dart';

enum TaskCategory {
  health,
  work,
  exercise,
  learning,
  personal,
  other,
}

extension TaskCategoryExt on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.exercise:
        return 'Exercise';
      case TaskCategory.learning:
        return 'Learning';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.other:
        return 'Other';
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.health:
        return Colors.green;
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.exercise:
        return Colors.orange;
      case TaskCategory.learning:
        return Colors.purple;
      case TaskCategory.personal:
        return Colors.pink;
      case TaskCategory.other:
        return Colors.grey;
    }
  }
}

class Task {
  final String id;
  final String description; // Now used as title/task name
  final TaskCategory category;
  final TaskPriority priority;
  final TaskType taskType; // 1: Description Only, 2: Yes/No, 3: Write Answer, 4: Integer Target, 5: Timer
  final String? question; // For types 2, 3, 4
  final int targetValue; // For type 4
  final List<int> selectedDays; // Days of week: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
  bool notificationEnabled;
  bool isCompleted; // For type 1
  String? answerText; // For type 3
  int currentProgress; // For type 4
  final int timerDurationInSeconds; // For timer type
  bool isTimerActive; // Is timer currently running
  int timerRemainingSeconds; // Remaining seconds on timer

  Task({
    required this.id,
    required this.description,
    this.category = TaskCategory.other,
    required this.priority,
    required this.taskType,
    this.question,
    this.targetValue = 1,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    this.notificationEnabled = false,
    this.isCompleted = false,
    this.answerText,
    this.currentProgress = 0,
    this.timerDurationInSeconds = 0,
    this.isTimerActive = false,
    this.timerRemainingSeconds = 0,
  });

  double get completionPercentage {
    if (taskType != TaskType.integerTarget || targetValue == 0) return 0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }

  bool get isFullyCompleted {
    switch (taskType) {
      case TaskType.descriptionOnly:
        return isCompleted;
      case TaskType.yesNo:
        return isCompleted;
      case TaskType.writeAnswer:
        return answerText != null && answerText!.isNotEmpty;
      case TaskType.integerTarget:
        return currentProgress >= targetValue;
      case TaskType.timer:
        return isCompleted;
    }
  }

  Task copyWith({
    String? id,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    TaskType? taskType,
    String? question,
    int? targetValue,
    List<int>? selectedDays,
    bool? notificationEnabled,
    bool? isCompleted,
    String? answerText,
    int? currentProgress,
    int? timerDurationInSeconds,
    bool? isTimerActive,
    int? timerRemainingSeconds,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      taskType: taskType ?? this.taskType,
      question: question ?? this.question,
      targetValue: targetValue ?? this.targetValue,
      selectedDays: selectedDays ?? this.selectedDays,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
      answerText: answerText ?? this.answerText,
      currentProgress: currentProgress ?? this.currentProgress,
      timerDurationInSeconds: timerDurationInSeconds ?? this.timerDurationInSeconds,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      timerRemainingSeconds: timerRemainingSeconds ?? this.timerRemainingSeconds,
    );
  }
}

enum TaskPriority { low, medium, high }

enum TaskType { descriptionOnly, yesNo, writeAnswer, integerTarget, timer }

extension TaskPriorityExt on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}

extension TaskTypeExt on TaskType {
  String get label {
    switch (this) {
      case TaskType.descriptionOnly:
        return 'Task Description';
      case TaskType.yesNo:
        return 'Yes/No Question';
      case TaskType.writeAnswer:
        return 'Write Answer';
      case TaskType.integerTarget:
        return 'Integer Target';
      case TaskType.timer:
        return 'Timer Task';
    }
  }

  String get description {
    switch (this) {
      case TaskType.descriptionOnly:
        return 'Simple task with checkbox';
      case TaskType.yesNo:
        return 'Answer yes or no';
      case TaskType.writeAnswer:
        return 'Write your answer';
      case TaskType.integerTarget:
        return 'Track progress to target';
      case TaskType.timer:
        return 'Task with timer countdown';
    }
  }
}
