import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class WeekDaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekDaySelector({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  List<DateTime> _getWeekDates() {
    // Get Monday of the current week
    final now = selectedDate;
    final monday = now.subtract(Duration(days: now.weekday - 1));

    // Generate 7 days starting from Monday
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = _getWeekDates();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDates.map((date) {
          final isToday = _isToday(date);
          final isSelected = _isSelected(date);

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 45,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : isToday
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppColors.primary.withOpacity(0.5),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    _getDayName(date.weekday),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.secondaryText,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.primaryText,
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
