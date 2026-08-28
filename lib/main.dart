import 'package:flutter/services.dart';
import 'core/services/local_notification_service.dart';
import '../../../../../core/exported_files/exported_file.dart';
import 'app/habit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await LocalNotificationService.initialize();

  runApp(const Habit());
  Future<void>.delayed(const Duration(milliseconds: 500), () {
    LocalNotificationService.handlePendingNotificationNavigation();
  });

  
}
