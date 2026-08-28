class HabitCompletion {
  final String habitId;
  final DateTime date;
  final bool isCompleted;
  final int? numericValue; // For numeric type
  final int? timeMinutes; // For time type (actual time spent)
  final String? textAnswer; // For text type

  HabitCompletion({
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.numericValue,
    this.timeMinutes,
    this.textAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'numericValue': numericValue,
      'timeMinutes': timeMinutes,
      'textAnswer': textAnswer,
    };
  }

  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      habitId: json['habitId'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool,
      numericValue: json['numericValue'] as int?,
      timeMinutes: json['timeMinutes'] as int?,
      textAnswer: json['textAnswer'] as String?,
    );
  }

  // Get date key for storage (yyyy-MM-dd format)
  String getDateKey() {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Create date key from DateTime
  static String createDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
