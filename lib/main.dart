
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'core/services/local_notification_service.dart';
import '../../../../../core/exported_files/exported_file.dart';
import 'app/habit.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firebase - with error handling for development
  // try {
  //   await Firebase.initializeApp();
  //   DService().info('Firebase initialized successfully');
  // } catch (e) {
  //   DService().warning('Firebase initialization failed: $e');
  //   DService().warning('Continuing without Firebase. Configure google-services.json for production.');
  // }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await LocalNotificationService.initialize();


  runApp(Habit());
}
