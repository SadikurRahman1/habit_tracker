import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';

class TaskActionBottomSheet extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final Function() onUndoProgress;
  final Function() onEdit;
  final Function() onSetNotification;
  final Function() onDelete;

  const TaskActionBottomSheet({
    Key? key,
    required this.completedCount,
    required this.totalCount,
    required this.onUndoProgress,
    required this.onEdit,
    required this.onSetNotification,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasProgress = completedCount > 0;

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
            'Task Actions',
            style: TextStyle(
              color: AppColors.onMainColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Undo Progress (only if has progress)
          if (hasProgress)
            _ActionTile(
              icon: Icons.undo,
              title: 'Undo Progress',
              color: Colors.orange,
              onTap: () {
                Get.back();
                onUndoProgress();
              },
            ),

          // Edit Task
          _ActionTile(
            icon: Icons.edit,
            title: 'Edit Task',
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

          // Delete Task
          _ActionTile(
            icon: Icons.delete,
            title: 'Delete Task',
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
                color: color.withValues(alpha: 0.2),
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
