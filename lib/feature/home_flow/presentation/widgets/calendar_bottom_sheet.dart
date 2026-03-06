import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/core/constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  final focusedDay = Rx<DateTime>(DateTime.now());
  final selectedDay = Rx<DateTime>(DateTime.now());

  CalendarBottomSheet({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key) {
    focusedDay.value = selectedDate;
    selectedDay.value = selectedDate;
  }

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

          // Calendar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => TableCalendar(
                firstDay: DateTime(2020, 1, 1),
                lastDay: DateTime(2030, 12, 31),
                focusedDay: focusedDay.value,
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay.value, day);
                },
                onDaySelected: (selected, focused) {
                  selectedDay.value = selected;
                  focusedDay.value = focused;
                  onDateSelected(selected);
                  Get.back();
                },
                onPageChanged: (focused) {
                  focusedDay.value = focused;
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: AppColors.onMainColor),
                  weekendTextStyle: TextStyle(color: AppColors.onMainSecondary),
                  outsideTextStyle: TextStyle(
                    color: AppColors.onMainSecondary.withOpacity(0.6),
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: AppColors.onMainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.onMainColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.onMainColor,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: AppColors.onMainSecondary),
                  weekendStyle: TextStyle(color: AppColors.onMainSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
