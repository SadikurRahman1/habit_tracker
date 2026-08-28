import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';

class HabitActionBottomSheet extends StatelessWidget {
  final bool isCompleted;
  final Function() onToggleComplete;
  final Function() onEdit;
  final Function() onSetNotification;
  final Function() onDelete;

  const HabitActionBottomSheet({
    Key? key,
    required this.isCompleted,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onSetNotification,
    required this.onDelete,
  }) : super(key: key);

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

          // Title
          Text(
            'Habit Actions',
            style: TextStyle(
              color: AppColors.onMainColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Mark Complete/Incomplete
          _ActionTile(
            icon: isCompleted ? Icons.close : Icons.check_circle,
            title: isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
            color: isCompleted ? Colors.orange : Colors.green,
            onTap: () {
              Get.back();
              onToggleComplete();
            },
          ),

          // Edit Habit
          _ActionTile(
            icon: Icons.edit,
            title: 'Edit Habit',
            color: Colors.blue,
            onTap: () {
              Get.back();
              onEdit();
            },
          ),

          // Set Notification Time
          _ActionTile(
            icon: Icons.notifications_active,
            title: 'Set Notification Time',
            color: Colors.purple,
            onTap: () {
              Get.back();
              onSetNotification();
            },
          ),

          // Delete Habit
          _ActionTile(
            icon: Icons.delete,
            title: 'Delete Habit',
            color: Colors.red,
            onTap: () => onDelete(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.onMainColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
