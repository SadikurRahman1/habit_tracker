import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/feature/habit_flow/screens/habit_creation_screen.dart';
import 'package:habit/feature/habit_flow/bindings/habit_flow_binding.dart';
import 'package:habit/feature/task_flow/bindings/task_flow_binding.dart';
import 'package:habit/feature/task_flow/screens/task_creation_screen.dart';

class AddItemBottomSheet extends StatelessWidget {
  const AddItemBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Habit Option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.to(
                  () => const HabitCreationScreen(),
                  binding: HabitFlowBinding(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Habit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onMainColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Create a recurring habit',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.onMainSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Task Option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.to(
                  () => const TaskCreationScreen(),
                  binding: TaskFlowBinding(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onMainColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Create a measurable daily task',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.onMainSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
