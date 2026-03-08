import '../../../../core/exported_files/exported_file.dart';
import '../../../habit_flow/controllers/habit_controller.dart';
import '../../../home_flow/presentation/controllers/home_controller.dart';

class DayCompletionData {
  final DateTime date;
  final String label;
  final int completed;
  final int total;

  const DayCompletionData({
    required this.date,
    required this.label,
    required this.completed,
    required this.total,
  });

  double get percentage {
    if (total == 0) return 0;
    return (completed / total) * 100;
  }
}

class AnalyticsController extends GetxController {
  late final HomeController _homeController;
  late final HabitController _habitController;
  final List<Worker> _workers = [];

  final completedHabits = 0.obs;
  final totalHabits = 0.obs;
  final completedTasks = 0.obs;
  final totalTasks = 0.obs;
  final dailyCompletion = 0.0.obs;
  final currentStreak = 0.obs;
  final longestStreak = 0.obs;
  final weeklyCompletion = 0.0.obs;
  final monthlyCompletion = 0.0.obs;
  final weeklyBreakdown = <DayCompletionData>[].obs;
  final selectedDate = DateTime.now().obs;

  HomeController get homeController => _homeController;

  @override
  void onInit() {
    super.onInit();
    _homeController = Get.find<HomeController>();
    _habitController = Get.find<HabitController>();

    final initialDate = _normalizeDate(_homeController.selectedDate.value);
    selectedDate.value = initialDate;

    _workers.add(
      ever<DateTime>(_homeController.selectedDate, (date) {
        final normalized = _normalizeDate(date);
        if (_isSameDate(selectedDate.value, normalized)) return;
        selectedDate.value = normalized;
        refreshAnalytics();
      }),
    );
    _workers.add(ever(_homeController.tasks, (_) => refreshAnalytics()));
    _workers.add(ever(_habitController.habits, (_) => refreshAnalytics()));
    _workers.add(ever(_habitController.completions, (_) => refreshAnalytics()));

    refreshAnalytics();
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _workers.clear();
    super.onClose();
  }

  void refreshAnalytics() {
    _computeSelectedDayStats();
    _computeWeeklyBreakdown();
    _computePeriodCompletions();
    _computeStreaks();
  }

  void _computeSelectedDayStats() {
    final date = selectedDate.value;
    final habitsForDate = _habitController.getHabitsForDate(date);
    final habitCompleted = _habitController.getCompletedCountForDate(date);

    final tasksForDate = _homeController.tasks
        .where((task) => task.selectedDays.contains(date.weekday))
        .toList();

    totalHabits.value = habitsForDate.length;
    completedHabits.value = habitCompleted;
    totalTasks.value = tasksForDate.length;
    completedTasks.value = tasksForDate
        .where((task) => task.isFullyCompleted)
        .length;

    final totalItems = totalHabits.value + totalTasks.value;
    final completedItems = completedHabits.value + completedTasks.value;

    if (totalItems == 0) {
      dailyCompletion.value = 0;
      return;
    }

    dailyCompletion.value = (completedItems / totalItems) * 100;
  }

  void _computeWeeklyBreakdown() {
    final monday = _startOfWeek(selectedDate.value);
    final breakdown = <DayCompletionData>[];

    for (int index = 0; index < 7; index++) {
      final day = monday.add(Duration(days: index));
      final total = _habitController.getHabitsForDate(day).length;
      final completed = _habitController.getCompletedCountForDate(day);

      breakdown.add(
        DayCompletionData(
          date: day,
          label: _dayLabel(day.weekday),
          completed: completed,
          total: total,
        ),
      );
    }

    weeklyBreakdown.assignAll(breakdown);
  }

  void _computePeriodCompletions() {
    final selected = selectedDate.value;
    final weekStart = _startOfWeek(selected);
    final weekEnd = weekStart.add(const Duration(days: 6));
    weeklyCompletion.value = _calculateRangeCompletion(weekStart, weekEnd);

    final monthStart = DateTime(selected.year, selected.month, 1);
    final monthEnd = DateTime(selected.year, selected.month + 1, 0);
    monthlyCompletion.value = _calculateRangeCompletion(monthStart, monthEnd);
  }

  double _calculateRangeCompletion(DateTime start, DateTime end) {
    int completedSum = 0;
    int totalSum = 0;

    var cursor = _normalizeDate(start);
    final endDate = _normalizeDate(end);

    while (!cursor.isAfter(endDate)) {
      final total = _habitController.getHabitsForDate(cursor).length;
      if (total > 0) {
        totalSum += total;
        completedSum += _habitController.getCompletedCountForDate(cursor);
      }

      cursor = cursor.add(const Duration(days: 1));
    }

    if (totalSum == 0) return 0;
    return (completedSum / totalSum) * 100;
  }

  void _computeStreaks() {
    if (_habitController.habits.isEmpty) {
      currentStreak.value = 0;
      longestStreak.value = 0;
      return;
    }

    final startDate = _getAnalyticsStartDate();
    final streakDate = _normalizeDate(selectedDate.value);
    final longestEndDate = _normalizeDate(DateTime.now());

    currentStreak.value = _calculateCurrentStreak(startDate, streakDate);
    longestStreak.value = _calculateLongestStreak(startDate, longestEndDate);
  }

  DateTime _getAnalyticsStartDate() {
    final starts = <DateTime>[];

    if (_habitController.habits.isNotEmpty) {
      final earliestHabitDate = _habitController.habits
          .map((habit) => _normalizeDate(habit.createdAt))
          .reduce((a, b) => a.isBefore(b) ? a : b);
      starts.add(earliestHabitDate);
    }

    if (_habitController.completions.isNotEmpty) {
      final earliestCompletionDate = _habitController.completions
          .map((completion) => _normalizeDate(completion.date))
          .reduce((a, b) => a.isBefore(b) ? a : b);
      starts.add(earliestCompletionDate);
    }

    if (starts.isEmpty) return _normalizeDate(DateTime.now());
    return starts.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  int _calculateCurrentStreak(DateTime startDate, DateTime selected) {
    int streak = 0;
    var cursor = _normalizeDate(selected);

    while (!cursor.isBefore(startDate)) {
      final total = _habitController.getHabitsForDate(cursor).length;

      if (total == 0) {
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }

      final completed = _habitController.getCompletedCountForDate(cursor);
      if (completed == total) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }

      break;
    }

    return streak;
  }

  int _calculateLongestStreak(DateTime startDate, DateTime endDate) {
    int longest = 0;
    int running = 0;
    var cursor = _normalizeDate(startDate);

    while (!cursor.isAfter(endDate)) {
      final total = _habitController.getHabitsForDate(cursor).length;

      if (total == 0) {
        cursor = cursor.add(const Duration(days: 1));
        continue;
      }

      final completed = _habitController.getCompletedCountForDate(cursor);
      if (completed == total) {
        running++;
        if (running > longest) {
          longest = running;
        }
      } else {
        running = 0;
      }

      cursor = cursor.add(const Duration(days: 1));
    }

    return longest;
  }

  void updateSelectedDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    selectedDate.value = normalizedDate;
    _homeController.updateSelectedDate(normalizedDate);
    refreshAnalytics();
  }

  String getFormattedSelectedDate() {
    final date = selectedDate.value;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _startOfWeek(DateTime date) {
    return _normalizeDate(date).subtract(Duration(days: date.weekday - 1));
  }

  String _dayLabel(int weekday) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[weekday - 1];
  }
}
