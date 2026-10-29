import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../engines/game/reminders.dart';
import '../../../platform/notifications/reminder_scheduler.dart';
import '../../settings/state/settings_providers.dart';
import 'today_providers.dart';

part 'reminder_providers.g.dart';

/// Localised reminder text; the caller has a BuildContext, this does not.
typedef ReminderText = ({String title, String body, String channel});

@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) =>
    kIsWeb ? const NoReminders() : SystemReminderScheduler();

/// The daily reminder. Permission is asked once, after the first finished
/// session (when the student has seen what it is for), never on launch.
/// Scheduling is best effort: a failure never interrupts studying.
@Riverpod(keepAlive: true)
class Reminders extends _$Reminders {
  @override
  void build() {}

  /// Re-plans the next week of reminders: none today once a review is in.
  Future<void> sync(ReminderText text) async {
    try {
      final settings = await ref.read(settingsRepositoryProvider).getAll();
      final scheduler = ref.read(reminderSchedulerProvider);
      if (settings[SettingKeys.reminderEnabled] == false) {
        await scheduler.cancelAll();
        return;
      }
      if (settings[SettingKeys.reminderAsked] != true) return;
      final now = ref.read(clockProvider).now().toLocal();
      final times = await ref
          .read(todayRepositoryProvider)
          .watchReviewTimes()
          .first;
      final reviewedToday = times.any((t) {
        final d = fromUtcMs(t).toLocal();
        return d.year == now.year && d.month == now.month && d.day == now.day;
      });
      await scheduler.schedule(
        reminderTimes(
          nowLocal: now,
          minuteOfDay: _minuteOfDay(settings[SettingKeys.reminderTime]),
          reviewedToday: reviewedToday,
          days: Defaults.reminderDaysAhead,
        ),
        title: text.title,
        body: text.body,
        channelName: text.channel,
      );
    } on Object {
      // Reminders are a convenience; never fail a session over them.
    }
  }

  /// After a finished session: ask for permission the first time, then
  /// re-plan.
  Future<void> afterSession(ReminderText text) async {
    try {
      final settings = ref.read(settingsRepositoryProvider);
      if (await settings.get(SettingKeys.reminderAsked) != true) {
        await settings.set(SettingKeys.reminderAsked, true);
        await ref.read(reminderSchedulerProvider).requestPermission();
      }
    } on Object {
      // As above.
    }
    await sync(text);
  }

  static int _minuteOfDay(Object? value) {
    final text = value is String ? value : Defaults.reminderTime;
    final parts = text.split(':');
    final h = int.tryParse(parts.first);
    final m = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return _minuteOfDay(Defaults.reminderTime);
    }
    return h * 60 + m;
  }
}
