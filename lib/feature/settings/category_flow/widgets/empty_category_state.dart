import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class EmptyCategoryState extends StatelessWidget {
  const EmptyCategoryState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppColors.inActiveColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No categories yet',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to create one',
            style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}
