import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class TimerStateModel {
  final String habitId;
  final DateTime date;
  final DateTime startedAt; // When timer started
  final int totalSeconds; // Total duration
  final int? pausedAtElapsedSeconds; // If paused, remaining seconds

  TimerStateModel({
    required this.habitId,
    required this.date,
    required this.startedAt,
    required this.totalSeconds,
    this.pausedAtElapsedSeconds,
  });

  bool get isRunning => pausedAtElapsedSeconds == null;

  int get elapsedSeconds {
    if (pausedAtElapsedSeconds != null) {
      return pausedAtElapsedSeconds!;
    }
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    return (elapsed).clamp(0, totalSeconds);
  }

  int get remainingSeconds {
    return (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);
  }

  Map<String, dynamic> toJson() => {
    'habitId': habitId,
    'date': date.toIso8601String(),
    'startedAt': startedAt.toIso8601String(),
    'totalSeconds': totalSeconds,
    'pausedAtElapsedSeconds': pausedAtElapsedSeconds,
  };

  factory TimerStateModel.fromJson(Map<String, dynamic> json) =>
      TimerStateModel(
        habitId: json['habitId'] as String,
        date: DateTime.parse(json['date'] as String),
        startedAt: DateTime.parse(json['startedAt'] as String),
        totalSeconds: json['totalSeconds'] as int,
        pausedAtElapsedSeconds: json['pausedAtElapsedSeconds'] as int?,
      );
}

class TimerStateService {
  static const String _timerStatesKey = 'habit_timer_states';
  final _storage = GetStorage();

  /// Save active timer state
  Future<void> saveTimerState(TimerStateModel state) async {
    try {
      final states = getAllTimerStates();
      states.removeWhere(
        (s) =>
            s.habitId == state.habitId &&
            s.date.day == state.date.day &&
            s.date.month == state.date.month &&
            s.date.year == state.date.year,
      );
      states.add(state);

      final jsonList = states.map((s) => s.toJson()).toList();
      await _storage.write(_timerStatesKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving timer state: $e');
    }
  }

  /// Get all active timers
  List<TimerStateModel> getAllTimerStates() {
    try {
      final jsonString = _storage.read(_timerStatesKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => TimerStateModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading timer states: $e');
      return [];
    }
  }

  /// Get timer state for specific habit/date
  TimerStateModel? getTimerState(String habitId, DateTime date) {
    try {
      final states = getAllTimerStates();
      return states.firstWhere(
        (s) =>
            s.habitId == habitId &&
            s.date.day == date.day &&
            s.date.month == date.month &&
            s.date.year == date.year,
        orElse: () => throw 'Not found',
      );
    } catch (e) {
      return null;
    }
  }

  /// Remove timer state
  Future<void> removeTimerState(String habitId, DateTime date) async {
    try {
      final states = getAllTimerStates();
      states.removeWhere(
        (s) =>
            s.habitId == habitId &&
            s.date.day == date.day &&
            s.date.month == date.month &&
            s.date.year == date.year,
      );

      final jsonList = states.map((s) => s.toJson()).toList();
      await _storage.write(_timerStatesKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error removing timer state: $e');
    }
  }

  /// Clear all timer states
  Future<void> clearAllTimerStates() async {
    try {
      await _storage.remove(_timerStatesKey);
    } catch (e) {
      print('Error clearing timer states: $e');
    }
  }
}
