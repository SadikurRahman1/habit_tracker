import 'package:habit/core/wrappers/responsive_card.dart';

import '../../../../core/exported_files/exported_file.dart';
import '../controllers/home_controller.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(
      () {
        final monday = controller.getMonday(controller.selectedDate.value);
            final weekDays = List.generate(
              7,
              (index) => monday.add(Duration(days: index)),
            );

            return Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: AppBar(
                backgroundColor: AppColors.mainColor,
                elevation: 0,
                title: const Text(
                  'Habit Tracker',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: () => Get.toNamed('/settings'),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.settings_outlined,
                          color: Colors.white70),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddTaskDialog(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.add_circle_outline,
                          color: Colors.blue.shade300),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Week Calendar
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.updateSelectedDate(
                                        controller.selectedDate.value
                                            .subtract(const Duration(days: 7)),
                                      );
                                    },
                                    child: Icon(Icons.chevron_left,
                                        color: Colors.white70),
                                  ),
                                  Text(
                                    'This Week',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.updateSelectedDate(
                                        controller.selectedDate.value
                                            .add(const Duration(days: 7)),
                                      );
                                    },
                                    child: Icon(Icons.chevron_right,
                                        color: Colors.white70),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Week Days
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(7, (index) {
                                  final day = weekDays[index];
                                  final isToday = day.year ==
                                          DateTime.now().year &&
                                      day.month == DateTime.now().month &&
                                      day.day == DateTime.now().day;
                                  final dayName = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun'
                                  ][index];

                                  return GestureDetector(
                                    onTap: () {
                                      controller.updateSelectedDate(day);
                                    },
                                    child: Container(
                                      width: 45,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isToday
                                            ? Colors.blue
                                            : (controller.selectedDate.value
                                                        .year ==
                                                    day.year &&
                                                controller.selectedDate.value
                                                        .month ==
                                                    day.month &&
                                                controller.selectedDate.value
                                                        .day ==
                                                    day.day)
                                            ? Colors.blue.shade900
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isToday
                                              ? Colors.blue
                                              : AppColors.borderColor,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            dayName,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isToday
                                                  ? Colors.white
                                                  : Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${day.day}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: isToday
                                                  ? Colors.white
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Category Filter
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildCategoryFilter(
                                    'All',
                                    null,
                                    controller,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCategoryFilter(
                                    'Health',
                                    'Health',
                                    controller,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCategoryFilter(
                                    'Work',
                                    'Work',
                                    controller,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCategoryFilter(
                                    'Exercise',
                                    'Exercise',
                                    controller,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCategoryFilter(
                                    'Learning',
                                    'Learning',
                                    controller,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCategoryFilter(
                                    'Personal',
                                    'Personal',
                                    controller,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Progress Bar
                        Obx(
                          () {
                            final total =
                              controller.getTotalTasksForSelectedDay();
                            final completed =
                              controller.getCompletedTasksForSelectedDay();
                            final percentage = total == 0
                                ? 0.0
                                : (completed / total);

                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '$completed / $total',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: percentage,
                                    minHeight: 8,
                                    backgroundColor:
                                        Colors.white12,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      percentage > 0.7
                                          ? Colors.green
                                          : percentage > 0.3
                                          ? Colors.orange
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Tasks List or Empty State
                        Obx(
                          () {
                            final todayTasks = controller.getTasksForSelectedDay();
                            
                            if (todayTasks.isEmpty) {
                              return ResponsiveCard(
                                padding: const EdgeInsets.all(16),
                                borderColor: AppColors.borderColor,
                                backgroundColor: AppColors.mainColor,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 48,
                                      color: Colors.white38,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "No tasks for this day",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Add a task to get started!",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Tasks',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: todayTasks.length,
                                  itemBuilder: (context, index) {
                                    final task = todayTasks[index];
                                    return Column(
                                      children: [
                                        TaskCard(
                                          task: task,
                                          onDelete: () {
                                            _showDeleteConfirmation(context, () {
                                              controller.deleteTask(task.id);
                                              Get.snackbar(
                                                'Task Deleted',
                                                'Task has been removed',
                                                backgroundColor: Colors.orange,
                                                colorText: Colors.white,
                                              );
                                            });
                                          },
                                          onTaskUpdate: (updatedTask) {
                                            controller.updateTask(updatedTask);
                                          },
                                        ),
                                        if (index < todayTasks.length - 1)
                                          const SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_rounded,
                color: Colors.orange,
                size: 40,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Task?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to delete this task? This action cannot be undone.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(String label, String? category, HomeController controller) {
    return Obx(
      () {
        final isSelected = controller.selectedCategory.value == category;
        return GestureDetector(
          onTap: () {
            controller.selectedCategory.value = category;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white10,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.blue : AppColors.borderColor,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ),
        );
      },
    );
  }
}
