import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the daily study reminder. An interface so tests and web can
/// run without the platform plugin.
abstract interface class ReminderScheduler {
  /// Asks the OS for permission to notify. True when granted.
  Future<bool> requestPermission();

  /// Replaces every scheduled reminder with one at each of [times] (local
  /// wall-clock times).
  Future<void> schedule(
    List<DateTime> times, {
    required String title,
    required String body,
    required String channelName,
  });

  Future<void> cancelAll();
}

/// Does nothing: web (no reminders in 1.0) and tests.
final class NoReminders implements ReminderScheduler {
  const NoReminders();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedule(
    List<DateTime> times, {
    required String title,
    required String body,
    required String channelName,
  }) async {}

  @override
  Future<void> cancelAll() async {}
}

/// flutter_local_notifications with inexact alarms, so Android needs no
/// exact-alarm permission. Reminders survive a reboot through the plugin's
/// boot receiver.
final class SystemReminderScheduler implements ReminderScheduler {
  SystemReminderScheduler();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channelId = 'daily_reminder';

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object {
      tz.setLocalLocation(tz.UTC);
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        // A white silhouette (res/drawable/ic_notification.xml).
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _init();
    if (Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    if (Platform.isIOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true) ??
          false;
    }
    return false;
  }

  @override
  Future<void> schedule(
    List<DateTime> times, {
    required String title,
    required String body,
    required String channelName,
  }) async {
    await _init();
    await _plugin.cancelAll();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        channelName,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    for (var i = 0; i < times.length; i++) {
      final t = times[i];
      await _plugin.zonedSchedule(
        id: i + 1,
        scheduledDate: tz.TZDateTime(
          tz.local,
          t.year,
          t.month,
          t.day,
          t.hour,
          t.minute,
        ),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
