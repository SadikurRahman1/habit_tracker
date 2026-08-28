import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/habit_flow/controllers/habit_controller.dart';
import 'package:habit/feature/home_flow/presentation/controllers/home_controller.dart';
import 'package:habit/feature/home_flow/presentation/helpers/home_habit_action_helper.dart';
import 'package:habit/feature/home_flow/presentation/widgets/add_item_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/calendar_bottom_sheet.dart';
import 'package:habit/feature/home_flow/presentation/widgets/home_body_widget.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openCalendarBottomSheet(HomeController homeController) {
    Get.bottomSheet(
      CalendarBottomSheet(
        selectedDate: homeController.selectedDate.value,
        onDateSelected: homeController.updateSelectedDate,
      ),
      isScrollControlled: true,
    );
  }

  void _openAddItemBottomSheet() {
    Get.bottomSheet(const AddItemBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final habitController = Get.find<HabitController>();
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        title: Text(
          'Habit Tracker',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.onMainColor,
          ),
        ),
        centerTitle: true,
        actions: [
          // Calendar icon
          GestureDetector(
            onTap: () => _openCalendarBottomSheet(homeController),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.calendar_today, color: AppColors.primary),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.isDarkMode
                ? [AppColors.primaryDark, AppColors.primary]
                : [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _openAddItemBottomSheet,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ),
      body: SafeArea(
        child: HomeBodyWidget(
          homeController: homeController,
          habitController: habitController,
          categoryController: categoryController,
          onHabitTap: (habit) => HomeHabitActionHelper.handleHabitTap(
            context: context,
            habitController: habitController,
            homeController: homeController,
            habit: habit,
          ),
          onCircleTap: (habit) => HomeHabitActionHelper.handleHabitTap(
            context: context,
            habitController: habitController,
            homeController: homeController,
            habit: habit,
          ),
          onHabitLongPress: (habit) =>
              HomeHabitActionHelper.handleHabitLongPress(
                habitController: habitController,
                homeController: homeController,
                habit: habit,
              ),
        ),
      ),
    );
  }
}
