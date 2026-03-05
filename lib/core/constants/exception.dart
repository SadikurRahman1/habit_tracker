// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:simonverdin/core/services/message_helper.dart';
//
// void handleAllExceptions(dynamic e) {
//   if (e is SocketException) {
//     log("SocketException: No Internet connection");
//     MessageHelper().showWarning(
//       title: "Error",
//       message: "No Internet connection. Please check your network.",
//     );
//   } else if (e is TimeoutException) {
//     log("TimeoutException: Request timed out");
//     MessageHelper().showWarning(
//       title: "Error",
//       message: "Server is taking too long to respond. Please try again later.",
//     );
//   } else if (e is FormatException) {
//     log("FormatException: ${e.message}");
//     MessageHelper().showWarning(
//       title: "Error",
//       message: "Server response format is invalid.",
//     );
//   } else if (e is OSError) {
//     log("OSError: ${e.message}");
//     MessageHelper().showWarning(
//       title: "Error",
//       message: "Operating system error occurred.",
//     );
//   } else if (e is Exception) {
//     log("Generic Exception: ${e.toString()}");
//     MessageHelper().showWarning(
//       title: "Error",
//       message: "An error occurred. Please try again.",
//     );
//   } else {
//     log("Unknown Error: $e");
//     MessageHelper().showWarning(
//       title: "Error",
//       message: "An unexpected error occurred.",
//     );
//   }
// }
