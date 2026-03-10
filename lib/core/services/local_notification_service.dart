import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:habit/core/app_routes/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static String? _pendingNotificationPayload;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone with local timezone
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print('Error setting timezone: $e');
      // Fallback to UTC if unable to get local timezone
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

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
      _pendingNotificationPayload =
          launchDetails?.notificationResponse?.payload;
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
    _navigateFromNotificationPayload(payload);
  }

  static void handlePendingNotificationNavigation() {
    final payload = _pendingNotificationPayload;
    if (payload == null || payload.isEmpty) return;
    _navigateFromNotificationPayload(payload);
  }

  static void _navigateFromNotificationPayload(String payload) {
    if (Get.key.currentState == null) {
      _pendingNotificationPayload = payload;
      return;
    }

    _pendingNotificationPayload = null;

    String? taskId;
    String? habitId;

    if (payload.startsWith('task:')) {
      taskId = payload.substring(5);
    } else if (payload.startsWith('habit:')) {
      habitId = payload.substring(6);
    } else {
      habitId = payload;
    }

    Get.offAllNamed(
      AppRoutes.mainBottomNavScreen,
      arguments: {
        if (habitId != null && habitId.isNotEmpty) 'habitId': habitId,
        if (taskId != null && taskId.isNotEmpty) 'taskId': taskId,
      },
    );

    Get.snackbar(
      taskId != null ? 'Task Reminder' : 'Habit Reminder',
      taskId != null
          ? 'Open your task and complete it now.'
          : 'Open your habit and complete it now.',
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

  /// Schedule multiple weekly notifications at selected times for a task.
  /// selectedDays format: 1=Mon ... 7=Sun
  static Future<void> scheduleTaskNotifications({
    required String taskId,
    required String taskName,
    required List<String> times,
    required List<int> selectedDays,
  }) async {
    await initialize();

    await cancelTaskNotifications(taskId);

    if (times.isEmpty || selectedDays.isEmpty) return;

    final uniqueTimes = times.toSet().toList()..sort();
    final uniqueDays = selectedDays.toSet().toList()..sort();

    const androidDetails = AndroidNotificationDetails(
      'task_reminder_channel',
      'Task Reminders',
      channelDescription: 'Time-based reminders for tasks',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      channelShowBadge: true,
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

    for (var timeIndex = 0; timeIndex < uniqueTimes.length; timeIndex++) {
      final parts = uniqueTimes[timeIndex].split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      for (final day in uniqueDays) {
        final dayIndex = day % 7; // Sunday=0, Monday=1 ... Saturday=6

        final scheduledDate = _nextInstanceOfDayAndTime(dayIndex, hour, minute);

        await _plugin.zonedSchedule(
          _taskNotificationId(taskId, timeIndex, dayIndex),
          'Task Reminder',
          taskName,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: 'task:$taskId',
        );
      }
    }
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
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      channelShowBadge: true,
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
          payload: 'habit:$habitId',
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
    await initialize();
    await _plugin.cancel(_notificationId(taskId));
  }

  static Future<void> cancelTaskNotifications(String taskId) async {
    await initialize();

    for (var timeIndex = 0; timeIndex < 10; timeIndex++) {
      for (var dayIndex = 0; dayIndex < 7; dayIndex++) {
        await _plugin.cancel(_taskNotificationId(taskId, timeIndex, dayIndex));
      }
    }
  }

  static int _taskNotificationId(String taskId, int timeIndex, int dayIndex) {
    final baseId = (taskId.hashCode ^ 0x15555555) & 0x0FFFFFFF;
    return (baseId + (timeIndex * 7) + dayIndex) & 0x7FFFFFFF;
  }

  static int _notificationId(String taskId) {
    return taskId.hashCode & 0x7fffffff;
  }
}
