// import 'package:intl/intl.dart';
//
// String convertToIsoDate(String dateString) {
//   final parts = dateString.split('/');
//   final day = int.parse(parts[0]);
//   final month = int.parse(parts[1]);
//   final year = int.parse(parts[2]);
//   final date = DateTime(year, month, day, 12, 48, 56, 471);
//   return date.toUtc().toIso8601String();
// }
//
// class DateAndTimeFormatter {
//   static String toReadable(DateTime date) {
//     try {
//       final formatter = DateFormat('dd MMM yyyy, hh:mm a');
//       return formatter.format(date);
//     } catch (e) {
//       return date.toString();
//     }
//   }
//
//   static String fromString(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       final formatter = DateFormat('dd MMM yyyy');
//       return formatter.format(date);
//     } catch (e) {
//       return dateString;
//     }
//   }
//
//   /// Convert formatted date string (dd MMM yyyy) back to ISO-8601 format
//   static String toIso8601(String formattedDateString) {
//     try {
//       final formatter = DateFormat('dd MMM yyyy');
//       final date = formatter.parse(formattedDateString);
//       return date.toUtc().toIso8601String();
//     } catch (e) {
//       // If parsing fails, try to parse as ISO-8601 directly
//       try {
//         final date = DateTime.parse(formattedDateString);
//         return date.toUtc().toIso8601String();
//       } catch (e2) {
//         return formattedDateString;
//       }
//     }
//   }
// }
//