import '../../exported_files/exported_file.dart';

class STService {
  static final STService _instance = STService._internal();

  factory STService() => _instance;

  STService._internal();

  final GetStorage _storage = GetStorage();

  Future<void> saveData(String key, String value) async {
    await _storage.write(key, value);
  }

  String? getData(String key) {
    try {
      return _storage.read<String>(key);
    } catch (e) {
      debugPrint("Error reading data for key $key: $e");
      return null;
    }
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }

  Future<void> saveBool(String key, bool value) async {
    await _storage.write(key, value);
  }

  bool? getBool(String key) {
    try {
      return _storage.read<bool>(key);
    } catch (e) {
      debugPrint("Error reading bool for key $key: $e");
      return null;
    }
  }
}
