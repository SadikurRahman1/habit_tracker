import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class RepeatDaysSelector extends StatelessWidget {
  final List<bool> repeatDays;
  final Function(List<bool>) onDaysChanged;

  const RepeatDaysSelector({
    Key? key,
    required this.repeatDays,
    required this.onDaysChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat Days *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            final isSelected = repeatDays[index];
            return GestureDetector(
              onTap: () {
                final newDays = List<bool>.from(repeatDays);
                newDays[index] = !newDays[index];
                onDaysChanged(newDays);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : AppColors.inputFillColor,
                  border: Border.all(
                    color: isSelected ? Colors.blue : AppColors.borderColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
