import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter_timezone/flutter_timezone.dart';

class PushNotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool get _isInitialized => false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: initSettingAndroid);
    await notificationPlugin.initialize(settings);
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "daily_channel_id",
        'Daily notifications',
        channelDescription: "Daily notification channel",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  Future<void> localNotification(
    int id,
    String title,
    String body,
  ) async {
    return notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> schedulleNotification(
    int id,
    String title,
    String body,
    int hour,
    int minute,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      notificationDetails(),
      // IOS specific
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // Android specific: Allow notificaiton while device is in low-power mode
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Make notification repeat DAILY at same time
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() async {
    await notificationPlugin.cancelAll();
  }
}
