import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:habit/core/app_routes/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static String? _pendingHabitPayload;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _pendingHabitPayload = launchDetails?.notificationResponse?.payload;
    }

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _isInitialized = true;
  }

  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    _navigateToHabitFromNotification(payload);
  }

  static void handlePendingNotificationNavigation() {
    final payload = _pendingHabitPayload;
    if (payload == null || payload.isEmpty) return;
    _navigateToHabitFromNotification(payload);
  }

  static void _navigateToHabitFromNotification(String habitId) {
    if (Get.key.currentState == null) {
      _pendingHabitPayload = habitId;
      return;
    }

    _pendingHabitPayload = null;
    Get.offAllNamed(
      AppRoutes.mainBottomNavScreen,
      arguments: {'habitId': habitId},
    );

    Get.snackbar(
      'Habit Reminder',
      'Open your habit and complete it now.',
      snackPosition: SnackPosition.TOP,
    );
  }

  static Future<void> scheduleDailyTaskNotification({
    required String taskId,
    required String title,
    required String body,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'habit_task_channel',
      'Habit Task Notifications',
      channelDescription: 'Task reminders for habits',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.periodicallyShow(
      _notificationId(taskId),
      title,
      body,
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedule notifications at specific times for a habit
  static Future<void> scheduleHabitNotifications({
    required String habitId,
    required String habitName,
    required List<String> times, // Times in "HH:mm" format
    required List<bool> repeatDays, // [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
  }) async {
    await initialize();

    // Cancel existing notifications for this habit first
    await cancelHabitNotifications(habitId);

    if (times.isEmpty) return;

    const androidDetails = AndroidNotificationDetails(
      'habit_reminder_channel',
      'Habit Reminders',
      channelDescription: 'Daily reminders for your habits',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule notification for each time
    for (var i = 0; i < times.length; i++) {
      final timeParts = times[i].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Schedule for each day of the week that habit is active
      for (var dayIndex = 0; dayIndex < repeatDays.length; dayIndex++) {
        if (!repeatDays[dayIndex]) continue;

        final scheduledDate = _nextInstanceOfDayAndTime(
          dayIndex, // 0 = Sunday
          hour,
          minute,
        );

        await _plugin.zonedSchedule(
          _habitNotificationId(habitId, i, dayIndex),
          'Time for: $habitName',
          'Don\'t forget to complete your habit!',
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: habitId,
        );
      }
    }
  }

  /// Get next occurrence of a specific day and time
  static tz.TZDateTime _nextInstanceOfDayAndTime(
    int day, // 0 = Sunday, 6 = Saturday
    int hour,
    int minute,
  ) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Adjust to target day of week
    while (scheduledDate.weekday % 7 != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If the scheduled time is in the past, move to next week
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  /// Cancel all notifications for a habit
  static Future<void> cancelHabitNotifications(String habitId) async {
    await initialize();

    // Cancel up to 7 days * 10 times per day = 70 possible notifications
    for (var timeIndex = 0; timeIndex < 10; timeIndex++) {
      for (var dayIndex = 0; dayIndex < 7; dayIndex++) {
        await _plugin.cancel(
          _habitNotificationId(habitId, timeIndex, dayIndex),
        );
      }
    }
  }

  static int _habitNotificationId(String habitId, int timeIndex, int dayIndex) {
    // Create unique ID: habitId hash + timeIndex * 7 + dayIndex
    final baseId = habitId.hashCode & 0x0FFFFFFF; // Keep lower 28 bits
    return (baseId + (timeIndex * 7) + dayIndex) & 0x7FFFFFFF;
  }

  static Future<void> cancelTaskNotification(String taskId) async {
    await _plugin.cancel(_notificationId(taskId));
  }

  static int _notificationId(String taskId) {
    return taskId.hashCode & 0x7fffffff;
  }
}
