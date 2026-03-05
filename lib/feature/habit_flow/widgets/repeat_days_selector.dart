import 'package:flutter/material.dart';

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
        const Text(
          'Repeat Days *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            7,
            (index) {
              final isSelected = repeatDays[index];
              return GestureDetector(
                onTap: () {
                  final newDays = List<bool>.from(repeatDays);
                  newDays[index] = !newDays[index];
                  onDaysChanged(newDays);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white10,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.white24,
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
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
