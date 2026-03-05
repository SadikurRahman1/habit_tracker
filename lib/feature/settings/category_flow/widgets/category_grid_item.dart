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
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Category Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            
            // Hint Text
            Text(
              'Long press to delete',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white38,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
