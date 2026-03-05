import 'package:logger/logger.dart';

class DService {
  static final DService _instance = DService._internal();

  factory DService() => _instance;

  DService._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
    ),
  );

  void info(String message) {
    _logger.i(message);
  }

  void debug(String message) {
    _logger.d(message);
  }

  void warning(String message) {
    _logger.w(message);
  }

  void error(String message) {
    _logger.e(message);
  }

  void verbose(String message) {
    _logger.t(message);
  }
}
