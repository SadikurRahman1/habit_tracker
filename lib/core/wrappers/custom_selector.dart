
import '../exported_files/exported_file.dart';

class SimpleWeekDaySelector extends StatefulWidget {
  final List<String>? initialSelectedDays;
  final Function(List<String> selectedDays)? onSelectionChanged;
  final List<String>? availableDays;
  final double itemSize;
  final double spacing;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final double fontSize;

  const SimpleWeekDaySelector({
    Key? key,
    this.initialSelectedDays,
    this.onSelectionChanged,
    this.availableDays,
    this.itemSize = 48.0,
    this.spacing = 8.0,
    this.selectedColor = AppColors.mainColor,
    this.unselectedColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black,
    this.fontSize = 14.0,
  }) : super(key: key);

  @override
  _SimpleWeekDaySelectorState createState() => _SimpleWeekDaySelectorState();
}

class _SimpleWeekDaySelectorState extends State<SimpleWeekDaySelector> {
  late List<String> _selectedDays;
  final List<String> _defaultDays = [];

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialSelectedDays ?? [];
  }

  List<String> _getAvailableDays() {
    return widget.availableDays ?? _defaultDays;
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });

    widget.onSelectionChanged?.call(List.from(_selectedDays));
  }

  bool _isDaySelected(String day) {
    return _selectedDays.contains(day);
  }

  @override
  Widget build(BuildContext context) {
    final availableDays = _getAvailableDays();

    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.spacing,
      children: availableDays.map((day) {
        final isSelected = _isDaySelected(day);

        return GestureDetector(
          onTap: () => _toggleDay(day),
          child: ResponsiveContainer(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? widget.selectedColor : widget.unselectedColor,

              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.mainColor, width: 1.5),
            ),
            child: ResponsiveText(
              text: day,
              color: isSelected
                  ? widget.selectedTextColor
                  : widget.unselectedTextColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}
