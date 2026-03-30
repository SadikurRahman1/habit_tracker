import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';
import '../model/habit_model.dart';

class QuestionTypeSelector extends StatelessWidget {
  final HabitQuestionType? selectedType;
  final Function(HabitQuestionType) onSelected;
  final bool isEnabled;

  const QuestionTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onSelected,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = [
      ('Yes or No', HabitQuestionType.yesNo),
      ('Numeric Value', HabitQuestionType.numeric),
      ('Time Duration', HabitQuestionType.time),
      ('Write Answer', HabitQuestionType.text),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Value Type *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          final label = option.$1;
          final type = option.$2;
          final isSelected = selectedType == type;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: isEnabled ? () => onSelected(type) : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.2)
                      : AppColors.inputFillColor,
                  border: Border.all(
                    color: isSelected ? Colors.blue : AppColors.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : AppColors.borderColor,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isEnabled
                            ? (isSelected
                                  ? Colors.blue
                                  : AppColors.secondaryText)
                            : (isSelected
                                  ? Colors.blue.withOpacity(0.75)
                                  : AppColors.inActiveColor),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
