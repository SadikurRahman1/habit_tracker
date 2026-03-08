enum HabitQuestionType {
  yesNo, // Yes or No
  numeric, // With a numeric value (target)
  time, // Time duration
  text, // Write answer
}

class HabitModel {
  final String id;
  final String name;
  final HabitQuestionType questionType;
  final String categoryId;
  final int targetValue; // For numeric type: e.g., 20
  final int timeDurationMinutes; // For time type: duration in minutes
  final List<bool> repeatDays; // [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
  final DateTime createdAt;
  final bool isActive;
  final List<String> notificationTimes; // Notification times in "HH:mm" format

  HabitModel({
    required this.id,
    required this.name,
    required this.questionType,
    required this.categoryId,
    this.targetValue = 0,
    this.timeDurationMinutes = 0,
    required this.repeatDays, // Must be list of 7 bools
    required this.createdAt,
    this.isActive = true,
    this.notificationTimes = const [],
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questionType': questionType.toString().split('.').last,
      'categoryId': categoryId,
      'targetValue': targetValue,
      'timeDurationMinutes': timeDurationMinutes,
      'repeatDays': repeatDays,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'notificationTimes': notificationTimes,
    };
  }

  // Create from JSON
  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      questionType: _parseQuestionType(json['questionType'] as String),
      categoryId: json['categoryId'] as String,
      targetValue: json['targetValue'] as int? ?? 0,
      timeDurationMinutes: json['timeDurationMinutes'] as int? ?? 0,
      repeatDays: List<bool>.from(json['repeatDays'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      notificationTimes: json['notificationTimes'] != null
          ? List<String>.from(json['notificationTimes'] as List)
          : [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Parse question type from string
  static HabitQuestionType _parseQuestionType(String type) {
    switch (type) {
      case 'yesNo':
        return HabitQuestionType.yesNo;
      case 'numeric':
        return HabitQuestionType.numeric;
      case 'time':
        return HabitQuestionType.time;
      case 'text':
        return HabitQuestionType.text;
      default:
        return HabitQuestionType.yesNo;
    }
  }

  // Get question type display name
  String getQuestionTypeLabel() {
    switch (questionType) {
      case HabitQuestionType.yesNo:
        return 'Yes or No';
      case HabitQuestionType.numeric:
        return 'Numeric Value';
      case HabitQuestionType.time:
        return 'Time Duration';
      case HabitQuestionType.text:
        return 'Write Answer';
    }
  }

  // Get days of week
  List<String> getDaysOfWeek() {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }

  // Get selected days as string
  String getRepeatDaysString() {
    final days = getDaysOfWeek();
    final selected = <String>[];
    for (int i = 0; i < repeatDays.length; i++) {
      if (repeatDays[i]) {
        selected.add(days[i]);
      }
    }
    return selected.isEmpty ? 'Never' : selected.join(', ');
  }
}
