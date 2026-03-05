import 'dart:io';

// Mobile/Desktop version – dart:io File support
class XFileLoader {
  bool exists(String path) => File(path).existsSync();
  File load(String path) => File(path);
}
