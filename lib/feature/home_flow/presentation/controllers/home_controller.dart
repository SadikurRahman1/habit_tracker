import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/category_model.dart';
import '../../../habit_flow/controllers/habit_controller.dart';
import '../../../habit_flow/model/habit_model.dart';
import '../../../settings/category_flow/controllers/category_controller.dart';
import '../../model/task.dart';
import '../../service/home_service.dart';

class HomeController extends GetxController {
  final tasks = <Task>[].obs;
  late final selectedDate = Rx<DateTime>(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ));
  final selectedCategoryId = Rx<String?>(null); // null = all categories
  final homeService = HomeService();
  final _timeRemainingSecondsByHabitDate = <String, int>{}.obs;
  final _timeRunningByHabitDate = <String, bool>{}.obs;
  final Map<String, Timer> _timeTickers = {};

  HabitController get habitController => Get.find<HabitController>();
  CategoryController get categoryController => Get.find<CategoryController>();

  @override
  void onInit() {
    super.onInit();
    loadInitialTasks();
  }

  @override
  void onClose() {
    for (final ticker in _timeTickers.values) {
      ticker.cancel();
    }
    _timeTickers.clear();
    super.onClose();
  }

  Future<void> loadInitialTasks() async {
    try {
      final loadedTasks = await homeService.loadTasks();
      tasks.assignAll(loadedTasks);
      _syncSelectedCategoryWithAvailableCategories();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
    _syncSelectedCategoryWithAvailableCategories();
  }

  void selectCategory(String? categoryId) {
    if (categoryId == null) {
      selectedCategoryId.value = null;
      return;
    }

    final availableIds = getAvailableCategoriesForSelectedDate()
        .map((cat) => cat.id)
        .toSet();

    selectedCategoryId.value = availableIds.contains(categoryId)
        ? categoryId
        : null;
  }

  bool get isFutureDate {
    final now = DateTime.now();
    final selected = selectedDate.value;
    return selected.isAfter(DateTime(now.year, now.month, now.day));
  }

  String _timerKey(String habitId, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return '${habitId}_${normalizedDate.toIso8601String()}';
  }

  int getTimeRemainingSeconds(HabitModel habit, DateTime date) {
    final key = _timerKey(habit.id, date);
    final cached = _timeRemainingSecondsByHabitDate[key];
    if (cached != null) return cached;

    final completion = habitController.getCompletion(habit.id, date);
    final elapsedMinutes = completion?.timeMinutes ?? 0;
    final targetSeconds = habit.timeDurationMinutes * 60;
    final elapsedSeconds = (elapsedMinutes * 60)
        .clamp(0, targetSeconds)
        .toInt();
    return targetSeconds - elapsedSeconds;
  }

  bool isTimeCountdownRunning(String habitId, DateTime date) {
    final key = _timerKey(habitId, date);
    return _timeRunningByHabitDate[key] ?? false;
  }

  void toggleTimeCountdown(HabitModel habit, DateTime date) {
    final key = _timerKey(habit.id, date);

    if (_timeRunningByHabitDate[key] == true) {
      _pauseTimeCountdown(habit, date);
      return;
    }

    final initialRemaining = getTimeRemainingSeconds(habit, date);
    if (initialRemaining <= 0) {
      habitController.updateTimeCompletion(
        habit.id,
        date,
        habit.timeDurationMinutes,
      );
      _timeRemainingSecondsByHabitDate[key] = 0;
      _timeRunningByHabitDate[key] = false;
      return;
    }

    _timeRemainingSecondsByHabitDate[key] = initialRemaining;
    _timeRunningByHabitDate[key] = true;

    _timeTickers[key]?.cancel();
    _timeTickers[key] = Timer.periodic(const Duration(seconds: 1), (ticker) {
      if (!(_timeRunningByHabitDate[key] ?? false)) {
        ticker.cancel();
        _timeTickers.remove(key);
        return;
      }

      final currentRemaining =
          _timeRemainingSecondsByHabitDate[key] ?? initialRemaining;
      final nextRemaining = currentRemaining - 1;

      if (nextRemaining <= 0) {
        _timeRemainingSecondsByHabitDate[key] = 0;
        _timeRunningByHabitDate[key] = false;
        ticker.cancel();
        _timeTickers.remove(key);

        habitController.updateTimeCompletion(
          habit.id,
          date,
          habit.timeDurationMinutes,
        );
        return;
      }

      _timeRemainingSecondsByHabitDate[key] = nextRemaining;

      final elapsedSeconds = habit.timeDurationMinutes * 60 - nextRemaining;
      final elapsedMinutes = elapsedSeconds ~/ 60;
      final savedMinutes =
          habitController.getCompletion(habit.id, date)?.timeMinutes ?? 0;

      if (elapsedMinutes > savedMinutes) {
        habitController.updateTimeCompletion(habit.id, date, elapsedMinutes);
      }
    });
  }

  void stopTimeCountdown(String habitId, DateTime date) {
    final key = _timerKey(habitId, date);
    _timeRunningByHabitDate[key] = false;
    _timeTickers[key]?.cancel();
    _timeTickers.remove(key);
  }

  void _pauseTimeCountdown(HabitModel habit, DateTime date) {
    final key = _timerKey(habit.id, date);
    _timeRunningByHabitDate[key] = false;
    _timeTickers[key]?.cancel();
    _timeTickers.remove(key);

    final remaining =
        _timeRemainingSecondsByHabitDate[key] ??
        getTimeRemainingSeconds(habit, date);
    final elapsedSeconds = habit.timeDurationMinutes * 60 - remaining;
    final elapsedMinutes = (elapsedSeconds / 60).floor();
    habitController.updateTimeCompletion(habit.id, date, elapsedMinutes);
  }

  DateTime getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  Future<void> addTask({
    required String description,
    required TaskCategory category,
    required TaskPriority priority,
    required TaskType taskType,
    String? question,
    int targetValue = 1,
    int timerDurationInSeconds = 0,
    List<int>? selectedDays,
  }) async {
    final task = Task(
      id: const Uuid().v4(),
      description: description,
      category: category,
      priority: priority,
      taskType: taskType,
      question: question,
      targetValue: taskType == TaskType.integerTarget ? targetValue : 1,
      timerDurationInSeconds: taskType == TaskType.timer
          ? timerDurationInSeconds
          : 0,
      selectedDays: selectedDays ?? [1, 2, 3, 4, 5, 6, 7],
    );

    tasks.add(task);
    await homeService.saveTasks(tasks);
    _syncSelectedCategoryWithAvailableCategories();
  }

  Future<void> deleteTask(String taskId) async {
    tasks.removeWhere((task) => task.id == taskId);
    await homeService.saveTasks(tasks);
    _syncSelectedCategoryWithAvailableCategories();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      tasks.refresh();
      await homeService.saveTasks(tasks);
      _syncSelectedCategoryWithAvailableCategories();
    }
  }

  int getTotalTasksCount() => tasks.length;

  int getCompletedTasksCount() {
    int count = 0;
    for (var task in tasks) {
      if (task.isFullyCompleted) {
        count++;
      }
    }
    return count;
  }

  int getTotalTasksForSelectedDay() {
    return getTasksForSelectedDay().length;
  }

  int getCompletedTasksForSelectedDay() {
    return getTasksForSelectedDay()
        .where((task) => task.isFullyCompleted)
        .length;
  }

  double getCompletionPercentage() {
    if (tasks.isEmpty) return 0;
    return (getCompletedTasksCount() / getTotalTasksCount() * 100);
  }

  double getCompletionPercentageForSelectedDay() {
    final todayTasks = getTasksForSelectedDay();
    if (todayTasks.isEmpty) return 0;
    final completed = todayTasks.where((task) => task.isFullyCompleted).length;
    return (completed / todayTasks.length);
  }

  String exportTasks() {
    return homeService.exportTasksAsJson(tasks);
  }

  List<Task> getTasksByDate(DateTime date) {
    return tasks;
  }

  List<Task> getTasksForSelectedDay({bool applyCategoryFilter = true}) {
    final dayOfWeek = selectedDate.value.weekday; // 1=Mon, 7=Sun
    var filtered = tasks
        .where((task) => task.selectedDays.contains(dayOfWeek))
        .toList();

    if (applyCategoryFilter && selectedCategoryId.value != null) {
      final selectedCategory = categoryController.getCategoryById(
        selectedCategoryId.value!,
      );

      if (selectedCategory != null) {
        filtered = filtered
            .where(
              (task) =>
                  task.category.label.toLowerCase().trim() ==
                  selectedCategory.name.toLowerCase().trim(),
            )
            .toList();
      }
    }

    return filtered;
  }

  List<HabitModel> getHabitsForSelectedDate() {
    var habits = habitController.getHabitsForDate(selectedDate.value);

    if (selectedCategoryId.value != null) {
      habits = habits
          .where((habit) => habit.categoryId == selectedCategoryId.value)
          .toList();
    }

    return habits;
  }

  List<CategoryModel> getAvailableCategoriesForSelectedDate() {
    final habitsForDate = habitController.getHabitsForDate(selectedDate.value);
    final habitCategoryIds = habitsForDate
        .map((habit) => habit.categoryId)
        .toSet();

    final taskCategoryNames = getTasksForSelectedDay(
      applyCategoryFilter: false,
    ).map((task) => task.category.label.toLowerCase().trim()).toSet();

    final availableCategories = categoryController.categories.where((category) {
      final matchesHabit = habitCategoryIds.contains(category.id);
      final matchesTask = taskCategoryNames.contains(
        category.name.toLowerCase().trim(),
      );
      return matchesHabit || matchesTask;
    }).toList();

    final selectedId = selectedCategoryId.value;
    if (selectedId != null &&
        !availableCategories.any((category) => category.id == selectedId)) {
      selectedCategoryId.value = null;
    }

    return availableCategories;
  }

  void _syncSelectedCategoryWithAvailableCategories() {
    getAvailableCategoriesForSelectedDate();
  }

  int getTotalHabitsForSelectedDate() {
    return getHabitsForSelectedDate().length;
  }

  int getCompletedHabitsForSelectedDate() {
    return habitController.getCompletedCountForDate(
      selectedDate.value,
      categoryId: selectedCategoryId.value,
    );
  }
}
