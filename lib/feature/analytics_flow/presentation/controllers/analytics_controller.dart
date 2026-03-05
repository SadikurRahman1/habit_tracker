import '../../../../core/exported_files/exported_file.dart';

class AnalyticsController extends GetxController {
  // Observable data
  final completedHabits = 0.obs;
  final totalHabits = 0.obs;
  final currentStreak = 0.obs;
  final longestStreak = 0.obs;
  final weeklyCompletion = 0.0.obs;
  final monthlyCompletion = 0.0.obs;
  final selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadAnalyticsData();
  }

  void loadAnalyticsData() {
    // Placeholder for loading analytics data from service
    completedHabits.value = 8;
    totalHabits.value = 12;
    currentStreak.value = 7;
    longestStreak.value = 21;
    weeklyCompletion.value = 75.0;
    monthlyCompletion.value = 68.0;
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  String getFormattedSelectedDate() {
    final date = selectedDate.value;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
