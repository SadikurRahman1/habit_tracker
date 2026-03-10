import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../model/task.dart';

class HomeService {
  static const String _tasksKey = 'tasks_data';
  final _storage = GetStorage();

  // Save tasks to local storage
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final jsonList = tasks.map((task) => _taskToJson(task)).toList();
      await _storage.write(_tasksKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Load tasks from local storage
  Future<List<Task>> loadTasks() async {
    try {
      final jsonString = _storage.read(_tasksKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => _taskFromJson(json)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  // Convert Task to JSON
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'description': task.description,
      'categoryId': task.categoryId, // Store categoryId instead of enum
      'priority': task.priority.toString().split('.').last,
      'taskType': task.taskType.toString().split('.').last,
      'question': task.question,
      'targetValue': task.targetValue,
      'selectedDays': task.selectedDays,
      'notificationEnabled': task.notificationEnabled,
      'notificationTimes': task.notificationTimes,
      'progressByDate': task.progressByDate,
      'isCompleted': task.isCompleted,
      'answerText': task.answerText,
      'currentProgress': task.currentProgress,
      'timerDurationInSeconds': task.timerDurationInSeconds,
      'isTimerActive': task.isTimerActive,
      'timerRemainingSeconds': task.timerRemainingSeconds,
      'createdDate': DateTime.now().toIso8601String(),
    };
  }

  // Convert JSON to Task
  Task _taskFromJson(Map<String, dynamic> json) {
    List<int> days = [1, 2, 3, 4, 5, 6, 7];
    if (json['selectedDays'] != null) {
      days = (json['selectedDays'] as List).map((e) => e as int).toList();
    }

    final notificationTimes = json['notificationTimes'] != null
        ? (json['notificationTimes'] as List).map((e) => '$e').toList()
        : <String>[];

    final progressByDate = <String, int>{};
    if (json['progressByDate'] != null) {
      final raw = json['progressByDate'] as Map<String, dynamic>;
      raw.forEach((key, value) {
        progressByDate[key] = (value as num).toInt();
      });
    }

    return Task(
      id: json['id'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String? ?? '', // Load categoryId
      priority: _getPriorityFromString(json['priority'] as String),
      taskType: _getTaskTypeFromString(json['taskType'] as String),
      question: json['question'] as String?,
      targetValue: json['targetValue'] as int? ?? 1,
      selectedDays: days,
      notificationEnabled: json['notificationEnabled'] as bool? ?? false,
      notificationTimes: notificationTimes,
      progressByDate: progressByDate,
      isCompleted: json['isCompleted'] as bool? ?? false,
      answerText: json['answerText'] as String?,
      currentProgress: json['currentProgress'] as int? ?? 0,
      timerDurationInSeconds: json['timerDurationInSeconds'] as int? ?? 0,
      isTimerActive: json['isTimerActive'] as bool? ?? false,
      timerRemainingSeconds: json['timerRemainingSeconds'] as int? ?? 0,
    );
  }

  TaskPriority _getPriorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }

  TaskType _getTaskTypeFromString(String type) {
    switch (type) {
      case 'descriptionOnly':
        return TaskType.descriptionOnly;
      case 'yesNo':
        return TaskType.yesNo;
      case 'writeAnswer':
        return TaskType.writeAnswer;
      case 'integerTarget':
        return TaskType.integerTarget;
      case 'timer':
        return TaskType.timer;
      default:
        return TaskType.descriptionOnly;
    }
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    try {
      await _storage.remove(_tasksKey);
    } catch (e) {
      print('Error clearing tasks: $e');
    }
  }

  // Export tasks as JSON string
  String exportTasksAsJson(List<Task> tasks) {
    try {
      final jsonList = tasks.map((task) => _taskToJson(task)).toList();
      return jsonEncode(jsonList);
    } catch (e) {
      print('Error exporting tasks: $e');
      return '';
    }
  }

  // Import tasks from JSON string
  Future<List<Task>> importTasksFromJson(String jsonString) async {
    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => _taskFromJson(json)).toList();
    } catch (e) {
      print('Error importing tasks: $e');
      return [];
    }
  }
}
