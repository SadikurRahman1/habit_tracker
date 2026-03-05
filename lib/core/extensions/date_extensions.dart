extension DateTimeExtension on DateTime {
  /// Format: 2025-11-14
  String get yMd =>
      "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  /// Format: 14-11-2025
  String get dMy =>
      "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-${year.toString().padLeft(4, '0')}";

  /// Human readable: 14 Nov 2025
  String get readable =>
      "$day ${_monthName(month)} $year";

  /// Only time: 12:45 PM
  String get time =>
      "${hour == 0 ? 12 : hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, "0")} ${hour >= 12 ? "PM" : "AM"}";

  /// Add only days
  DateTime addDays(int days) => add(Duration(days: days));

  String _monthName(int m) {
    const names = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m - 1];
  }
}
