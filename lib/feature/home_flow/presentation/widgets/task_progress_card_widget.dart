import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/constants/category_icons.dart';
import 'package:habit/feature/home_flow/model/task.dart';
import 'package:habit/feature/settings/category_flow/controllers/category_controller.dart';

class TaskProgressCardWidget extends StatelessWidget {
  const TaskProgressCardWidget({
    super.key,
    required this.task,
    required this.completedCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReminderTap,
    required this.onDelete,
    required this.onLongPress,
  });

  final Task task;
  final int completedCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReminderTap;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final category = task.categoryId.isNotEmpty
        ? categoryController.categories.firstWhereOrNull(
            (c) => c.id == task.categoryId,
          )
        : null;

    final categoryIcon = category != null
        ? CategoryIcons.icons[category.icon]
        : Icons.task_alt;
    final categoryColor = category?.getColor() ?? Colors.grey;
    final categoryName = category?.name ?? 'No Category';

    final total = task.frequency;
    final ratio = (completedCount / total).clamp(0.0, 1.0);
    final isCompleted = completedCount >= total;

    final textPrimary = AppColors.primaryText;
    final textSecondary = AppColors.secondaryText;

    return GestureDetector(
      onTap: onIncrement,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.overlayColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Column(
          children: [
            // Main content with matching habit card layout
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category icon - matching habit card style
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(categoryIcon, color: categoryColor, size: 28),
                  ),
                  const SizedBox(width: 16),

                  // Title and subtitle - matching habit card style
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.description,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedCount / $total • $categoryName',
                          style: TextStyle(color: textSecondary, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Completion status circle - matching habit card design
                  GestureDetector(
                    onTap: onIncrement,
                    child: isCompleted
                        ? Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withValues(alpha: 0.2),
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 22,
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.overlayColor,
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.inActiveColor,
                              size: 20,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Progress bar at bottom border - matching the task requirement
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 4,
                  backgroundColor: AppColors.weakOverlayColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
