import 'package:flutter/material.dart';
import 'package:habit/core/constants/category_icons.dart';
import 'package:habit/core/models/category_model.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onLongPress;

  const CategoryGridItem({
    Key? key,
    required this.category,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = category.getColor();
    final icon = CategoryIcons.getIcon(category.icon);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          border: Border.all(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ),

            // Category Name
            Expanded(
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
