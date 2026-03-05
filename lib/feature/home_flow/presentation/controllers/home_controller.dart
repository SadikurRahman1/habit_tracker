import 'package:uuid/uuid.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../../model/task.dart';
import '../../service/home_service.dart';

class HomeController extends GetxController {
  final tasks = <Task>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedCategory = Rx<String?>(null); // null = all categories
  final homeService = HomeService();

  @override
  void onInit() {
    super.onInit();
    loadInitialTasks();
  }

  Future<void> loadInitialTasks() async {
    try {
      final loadedTasks = await homeService.loadTasks();
      tasks.assignAll(loadedTasks);
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
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
      timerDurationInSeconds: taskType == TaskType.timer ? timerDurationInSeconds : 0,
      selectedDays: selectedDays ?? [1, 2, 3, 4, 5, 6, 7],
    );
    tasks.add(task);
    await homeService.saveTasks(tasks);
  }

  Future<void> deleteTask(String taskId) async {
    tasks.removeWhere((task) => task.id == taskId);
    await homeService.saveTasks(tasks);
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      tasks.refresh();
      await homeService.saveTasks(tasks);
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
    return getTasksForSelectedDay().where((task) => task.isFullyCompleted).length;
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
    // This is a placeholder - in real scenario you'd store creation date
    // For now, return all tasks
    return tasks;
  }

  List<Task> getTasksForSelectedDay() {
    final dayOfWeek = selectedDate.value.weekday; // 1=Mon, 7=Sun
    var filtered = tasks.where((task) => task.selectedDays.contains(dayOfWeek)).toList();
    
    // Filter by category if selected
    if (selectedCategory.value != null) {
      filtered = filtered.where((task) => task.category.label == selectedCategory.value).toList();
    }
    
    return filtered;
  }
}
