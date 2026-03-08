import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:habit/core/wrappers/responsive_card.dart';

class DatePickerCalendar extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const DatePickerCalendar({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerCalendar> createState() => _DatePickerCalendarState();
}

class _DatePickerCalendarState extends State<DatePickerCalendar> {
  late DateTime displayedMonth;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
    selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(covariant DatePickerCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isSameDate(oldWidget.initialDate, widget.initialDate)) return;

    selectedDate = widget.initialDate;
    displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
  }

  void _previousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    });
  }

  List<DateTime> _getDaysInMonth(DateTime dateTime) {
    final first = DateTime(dateTime.year, dateTime.month, 1);
    final last = DateTime(dateTime.year, dateTime.month + 1, 0);
    final days = <DateTime>[];

    // Sunday-first alignment (Sun=0, Mon=1 ... Sat=6)
    final leadingDays = first.weekday % 7;
    for (int i = leadingDays; i > 0; i--) {
      days.add(first.subtract(Duration(days: i)));
    }

    // Add actual days
    for (int i = 1; i <= last.day; i++) {
      days.add(DateTime(dateTime.year, dateTime.month, i));
    }

    // Enforce fixed 6 rows (42 cells)
    final nextMonthFirst = DateTime(dateTime.year, dateTime.month + 1, 1);
    int trailingDay = 1;
    while (days.length < 42) {
      days.add(
        DateTime(nextMonthFirst.year, nextMonthFirst.month, trailingDay),
      );
      trailingDay++;
    }

    return days;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(displayedMonth);
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return ResponsiveCard(
      borderColor: AppColors.borderColor,
      backgroundColor: AppColors.mainColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Month and Year header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _previousMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.overlayColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.onMainColor,
                    size: 16,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    months[displayedMonth.month - 1],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onMainColor,
                    ),
                  ),
                  Text(
                    displayedMonth.year.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onMainSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.overlayColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.onMainColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Week day headers
          Row(
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onMainSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: days.map((day) {
              final isCurrentMonth = day.month == displayedMonth.month;
              final isSelected =
                  isCurrentMonth &&
                  day.day == selectedDate.day &&
                  day.month == selectedDate.month &&
                  day.year == selectedDate.year;
              final isToday =
                  day.day == DateTime.now().day &&
                  day.month == DateTime.now().month &&
                  day.year == DateTime.now().year;

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          selectedDate = day;
                        });
                        widget.onDateSelected(day);
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? AppColors.isDarkMode
                                ? [AppColors.primaryDark, AppColors.primary]
                                : [AppColors.primary, AppColors.primaryLight]
                          : isToday
                          ? [
                              AppColors.primary.withValues(alpha: 0.25),
                              AppColors.primary.withValues(alpha: 0.25),
                            ]
                          : isCurrentMonth
                          ? [AppColors.overlayColor, AppColors.overlayColor]
                          : [AppColors.transparent, AppColors.transparent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    // color: isSelected
                    //     ? AppColors.primary
                    //     : isToday
                    //     ? AppColors.primary.withValues(alpha: 0.25)
                    //     : isCurrentMonth
                    //     ? AppColors.overlayColor
                    //     : AppColors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                          ? AppColors.primary
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isCurrentMonth
                            ? isSelected
                                  ? AppColors.white
                                  : AppColors.onMainColor
                            : AppColors.inActiveColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
