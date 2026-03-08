import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:uuid/uuid.dart';
import '../model/habit_model.dart';
import '../model/habit_completion.dart';

class HabitController extends GetxController {
  final _storage = GetStorage();
  static const String _habitsKey = 'app_habits';
  static const String _completionsKey = 'habit_completions';

  final habits = <HabitModel>[].obs;
  final completions = <HabitCompletion>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHabits();
    loadCompletions();
  }

  // Load habits from storage
  void loadHabits() {
    try {
      isLoading.value = true;
      final saved = _storage.read(_habitsKey);

      if (saved != null && saved is List) {
        final habitList = saved
            .map((item) => HabitModel.fromJson(item as Map<String, dynamic>))
            .toList();
        habits.assignAll(habitList);
      }
    } catch (e) {
      print('Error loading habits: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add new habit
  bool addHabit({
    required String name,
    required HabitQuestionType questionType,
    required String categoryId,
    required List<bool> repeatDays,
    int targetValue = 0,
    int timeDurationMinutes = 0,
  }) {
    if (name.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a habit name',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    if (repeatDays.isEmpty || !repeatDays.any((day) => day)) {
      Get.snackbar(
        'Error',
        'Please select at least one day to repeat',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    // Validate numeric type
    if (questionType == HabitQuestionType.numeric) {
      if (targetValue <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid target value',
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.white,
          backgroundColor: AppColors.orange,
        );
        return false;
      }
    }

    // Validate time type
    if (questionType == HabitQuestionType.time) {
      if (timeDurationMinutes <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid time duration',
          snackPosition: SnackPosition.TOP,
          colorText: AppColors.white,
          backgroundColor: AppColors.orange,
        );
        return false;
      }
    }

    final newHabit = HabitModel(
      id: const Uuid().v4(),
      name: name.trim(),
      questionType: questionType,
      categoryId: categoryId,
      targetValue: targetValue,
      timeDurationMinutes: timeDurationMinutes,
      repeatDays: repeatDays,
      createdAt: DateTime.now(),
      isActive: true,
    );

    habits.add(newHabit);
    _saveHabits();

    return true;
  }

  // Remove habit
  void removeHabit(String habitId) {
    habits.removeWhere((habit) => habit.id == habitId);
    _saveHabits();
  }

  // Update habit
  bool updateHabit({
    required String habitId,
    required String name,
    required HabitQuestionType questionType,
    required String categoryId,
    required List<bool> repeatDays,
    int targetValue = 0,
    int timeDurationMinutes = 0,
  }) {
    final index = habits.indexWhere((habit) => habit.id == habitId);

    if (index == -1) {
      Get.snackbar(
        'Error',
        'Habit not found',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    if (name.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a habit name',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    if (repeatDays.isEmpty || !repeatDays.any((day) => day)) {
      Get.snackbar(
        'Error',
        'Please select at least one day to repeat',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    if (questionType == HabitQuestionType.numeric && targetValue <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid target value',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    if (questionType == HabitQuestionType.time && timeDurationMinutes <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid time duration',
        snackPosition: SnackPosition.TOP,
        colorText: AppColors.white,
        backgroundColor: AppColors.orange,
      );
      return false;
    }

    habits[index] = HabitModel(
      id: habitId,
      name: name.trim(),
      questionType: questionType,
      categoryId: categoryId,
      targetValue: targetValue,
      timeDurationMinutes: timeDurationMinutes,
      repeatDays: repeatDays,
      createdAt: habits[index].createdAt,
      isActive: habits[index].isActive,
      notificationTimes: habits[index].notificationTimes,
    );
    _saveHabits();

    return true;
  }

  // Update habit directly (for notification times, etc.)
  void updateHabitModel(HabitModel habit) {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      _saveHabits();
    }
  }

  // Toggle habit active status
  void toggleHabitStatus(String habitId) {
    final index = habits.indexWhere((habit) => habit.id == habitId);

    if (index != -1) {
      final habit = habits[index];
      habits[index] = HabitModel(
        id: habit.id,
        name: habit.name,
        questionType: habit.questionType,
        categoryId: habit.categoryId,
        targetValue: habit.targetValue,
        timeDurationMinutes: habit.timeDurationMinutes,
        repeatDays: habit.repeatDays,
        createdAt: habit.createdAt,
        isActive: !habit.isActive,
        notificationTimes: habit.notificationTimes,
      );
      _saveHabits();
    }
  }

  // Save habits to storage
  void _saveHabits() {
    final jsonList = habits.map((habit) => habit.toJson()).toList();
    _storage.write(_habitsKey, jsonList);
  }

  // Get habit by id
  HabitModel? getHabitById(String id) {
    try {
      return habits.firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get habits by category
  List<HabitModel> getHabitsByCategory(String categoryId) {
    return habits.where((habit) => habit.categoryId == categoryId).toList();
  }

  // Get active habits
  List<HabitModel> getActiveHabits() {
    return habits.where((habit) => habit.isActive).toList();
  }

  // ===== COMPLETION TRACKING =====

  // Load completions from storage
  void loadCompletions() {
    try {
      final saved = _storage.read(_completionsKey);

      if (saved != null && saved is List) {
        final completionList = saved
            .map(
              (item) => HabitCompletion.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        completions.assignAll(completionList);
      }
    } catch (e) {
      print('Error loading completions: $e');
    }
  }

  // Save completions to storage
  void _saveCompletions() {
    final jsonList = completions.map((c) => c.toJson()).toList();
    _storage.write(_completionsKey, jsonList);
  }

  // Get completion for a habit on a specific date
  HabitCompletion? getCompletion(String habitId, DateTime date) {
    final dateKey = HabitCompletion.createDateKey(date);
    try {
      return completions.firstWhere(
        (c) => c.habitId == habitId && c.getDateKey() == dateKey,
      );
    } catch (e) {
      return null;
    }
  }

  // Update completion
  void updateCompletion({
    required String habitId,
    required DateTime date,
    required bool isCompleted,
    int? numericValue,
    int? timeMinutes,
    String? textAnswer,
  }) {
    final dateKey = HabitCompletion.createDateKey(date);

    // Remove existing completion for this habit and date
    completions.removeWhere(
      (c) => c.habitId == habitId && c.getDateKey() == dateKey,
    );

    // Add new completion
    final completion = HabitCompletion(
      habitId: habitId,
      date: date,
      isCompleted: isCompleted,
      numericValue: numericValue,
      timeMinutes: timeMinutes,
      textAnswer: textAnswer,
    );

    completions.add(completion);
    _saveCompletions();
  }

  // Toggle YesNo type completion
  void toggleYesNoCompletion(String habitId, DateTime date) {
    final existing = getCompletion(habitId, date);
    updateCompletion(
      habitId: habitId,
      date: date,
      isCompleted: !(existing?.isCompleted ?? false),
    );
  }

  // Update numeric completion
  void updateNumericCompletion(String habitId, DateTime date, int value) {
    final habit = getHabitById(habitId);
    if (habit == null) return;

    updateCompletion(
      habitId: habitId,
      date: date,
      isCompleted: value >= habit.targetValue,
      numericValue: value,
    );
  }

  // Update time completion
  void updateTimeCompletion(String habitId, DateTime date, int minutes) {
    final habit = getHabitById(habitId);
    if (habit == null) return;

    updateCompletion(
      habitId: habitId,
      date: date,
      isCompleted: minutes >= habit.timeDurationMinutes,
      timeMinutes: minutes,
    );
  }

  // Update text completion
  void updateTextCompletion(String habitId, DateTime date, String answer) {
    updateCompletion(
      habitId: habitId,
      date: date,
      isCompleted: answer.trim().isNotEmpty,
      textAnswer: answer.trim(),
    );
  }

  // Get habits for a specific date (based on repeatDays)
  List<HabitModel> getHabitsForDate(DateTime date) {
    final weekday = date.weekday % 7; // Convert to 0-6 (Sun-Sat)
    return habits.where((habit) {
      return habit.isActive && habit.repeatDays[weekday];
    }).toList();
  }

  // Get completion percentage for a date
  double getCompletionPercentageForDate(DateTime date, {String? categoryId}) {
    var habitsForDate = getHabitsForDate(date);

    if (categoryId != null) {
      habitsForDate = habitsForDate
          .where((h) => h.categoryId == categoryId)
          .toList();
    }

    if (habitsForDate.isEmpty) return 0;

    int completedCount = 0;
    for (var habit in habitsForDate) {
      final completion = getCompletion(habit.id, date);
      if (completion != null && completion.isCompleted) {
        completedCount++;
      }
    }

    return completedCount / habitsForDate.length;
  }

  // Get completed habits count for date
  int getCompletedCountForDate(DateTime date, {String? categoryId}) {
    var habitsForDate = getHabitsForDate(date);

    if (categoryId != null) {
      habitsForDate = habitsForDate
          .where((h) => h.categoryId == categoryId)
          .toList();
    }

    int count = 0;
    for (var habit in habitsForDate) {
      final completion = getCompletion(habit.id, date);
      if (completion != null && completion.isCompleted) {
        count++;
      }
    }
    return count;
  }
}
