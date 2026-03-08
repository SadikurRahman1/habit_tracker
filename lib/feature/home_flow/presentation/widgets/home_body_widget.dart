import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/habit_flow/controllers/habit_controller.dart';
import 'package:habit/feature/habit_flow/model/habit_model.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/home_flow/presentation/widgets/category_filter_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/habit_card_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/progress_bar_widget.dart';
import 'package:habit/feature/home_flow/presentation/widgets/week_day_selector.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({
    super.key,
    required this.homeController,
    required this.habitController,
    required this.categoryController,
    required this.onHabitTap,
    required this.onCircleTap,
    required this.onHabitLongPress,
  });

  final HomeController homeController;
  final HabitController habitController;
  final CategoryController categoryController;
  final ValueChanged<HabitModel> onHabitTap;
  final ValueChanged<HabitModel> onCircleTap;
  final ValueChanged<HabitModel> onHabitLongPress;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final habits = homeController.getHabitsForSelectedDate();
      final habitsForDate = habitController.getHabitsForDate(
        homeController.selectedDate.value,
      );
      final hasCategorizedHabits = habitsForDate.any(
        (habit) => habit.categoryId.trim().isNotEmpty,
      );
      final availableCategories = homeController
          .getAvailableCategoriesForSelectedDate();
      final totalHabits = homeController.getTotalHabitsForSelectedDate();
      final completedHabits = homeController
          .getCompletedHabitsForSelectedDate();

      if (!hasCategorizedHabits &&
          homeController.selectedCategoryId.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (homeController.selectedCategoryId.value != null) {
            homeController.selectCategory(null);
          }
        });
      }

      return Column(
        children: [
          WeekDaySelector(
            selectedDate: homeController.selectedDate.value,
            onDateSelected: (date) {
              homeController.updateSelectedDate(date);
            },
          ),
          if (hasCategorizedHabits && availableCategories.isNotEmpty)
            CategoryFilterWidget(
              selectedCategoryId: homeController.selectedCategoryId.value,
              categories: availableCategories,
              onCategorySelected: (categoryId) {
                homeController.selectCategory(categoryId);
              },
            ),
          if (totalHabits > 0)
            ProgressBarWidget(
              completedCount: completedHabits,
              totalCount: totalHabits,
            ),
          Expanded(
            child: habits.isEmpty
                ? const _EmptyHabitsView()
                : _HabitListView(
                    habits: habits,
                    homeController: homeController,
                    habitController: habitController,
                    categoryController: categoryController,
                    onHabitTap: onHabitTap,
                    onCircleTap: onCircleTap,
                    onHabitLongPress: onHabitLongPress,
                  ),
          ),
        ],
      );
    });
  }
}

class _EmptyHabitsView extends StatelessWidget {
  const _EmptyHabitsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 64, color: AppColors.inActiveColor),
          const SizedBox(height: 16),
          Text(
            'No habits for this day',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _HabitListView extends StatelessWidget {
  const _HabitListView({
    required this.habits,
    required this.homeController,
    required this.habitController,
    required this.categoryController,
    required this.onHabitTap,
    required this.onCircleTap,
    required this.onHabitLongPress,
  });

  final List<HabitModel> habits;
  final HomeController homeController;
  final HabitController habitController;
  final CategoryController categoryController;
  final ValueChanged<HabitModel> onHabitTap;
  final ValueChanged<HabitModel> onCircleTap;
  final ValueChanged<HabitModel> onHabitLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        final category = categoryController.getCategoryById(habit.categoryId);
        final timerRemainingSeconds =
            habit.questionType == HabitQuestionType.time
            ? homeController.getTimeRemainingSeconds(
                habit,
                homeController.selectedDate.value,
              )
            : null;
        final isTimeRunning = habit.questionType == HabitQuestionType.time
            ? homeController.isTimeCountdownRunning(
                habit.id,
                homeController.selectedDate.value,
              )
            : false;
        final completion = habitController.getCompletion(
          habit.id,
          homeController.selectedDate.value,
        );

        return HabitCardWidget(
          habit: habit,
          category: category,
          completion: completion,
          selectedDate: homeController.selectedDate.value,
          isFutureDate: homeController.isFutureDate,
          timeRemainingSeconds: timerRemainingSeconds,
          isTimeRunning: isTimeRunning,
          onTap: () => onHabitTap(habit),
          onCircleTap: () => onCircleTap(habit),
          onLongPress: () => onHabitLongPress(habit),
        );
      },
    );
  }
}
