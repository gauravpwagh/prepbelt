import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/engines/game/reminders.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/settings/data/settings_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';

import '../../support/test_db.dart';

class _Scheduler implements ReminderScheduler {
  int asked = 0;
  List<DateTime>? scheduled;
  bool cancelled = false;

  @override
  Future<bool> requestPermission() async {
    asked++;
    return true;
  }

  @override
  Future<void> schedule(
    List<DateTime> times, {
    required String title,
    required String body,
    required String channelName,
  }) async => scheduled = times;

  @override
  Future<void> cancelAll() async => cancelled = true;
}

const _text = (title: 't', body: 'b', channel: 'c');

void main() {
  test('reminders start today unless done or past, then daily', () {
    List<int> days(DateTime now, {bool done = false}) => [
      for (final t in reminderTimes(
        nowLocal: now,
        minuteOfDay: 19 * 60,
        reviewedToday: done,
        days: 3,
      ))
        t.day,
    ];
    expect(days(DateTime(2026, 10, 28, 9)), [28, 29, 30]);
    expect(days(DateTime(2026, 10, 28, 9), done: true), [29, 30, 31]);
    expect(days(DateTime(2026, 10, 28, 20)), [29, 30, 31]);
    expect(
      reminderTimes(
        nowLocal: DateTime(2026, 10, 28, 9),
        minuteOfDay: 7 * 60 + 30,
        reviewedToday: false,
        days: 1,
      ).single,
      DateTime(2026, 10, 29, 7, 30),
    );
  });

  test('nothing is scheduled before permission was asked; after the first '
      'session it asks once and skips today once a review is in', () async {
    final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
    addTearDown(t.db.close);
    final scheduler = _Scheduler();
    final c = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(t.clock),
        appDatabaseProvider.overrideWithValue(t.db),
        writeContextProvider.overrideWithValue(t.ctx),
        reminderSchedulerProvider.overrideWithValue(scheduler),
      ],
    );
    addTearDown(c.dispose);
    final reminders = c.read(remindersProvider.notifier);

    await reminders.sync(_text);
    expect((scheduler.asked, scheduler.scheduled), (0, null));

    await reminders.afterSession(_text);
    expect(scheduler.asked, 1);
    expect(scheduler.scheduled, hasLength(Defaults.reminderDaysAhead));
    expect(scheduler.scheduled!.first, DateTime(2026, 10, 28, 19));

    // A review today moves the first reminder to tomorrow.
    final src = await SourceRepository(t.ctx).createWithChunks(
      type: SourceType.book,
      title: 'Book',
      unitType: UnitType.page,
      totalUnits: 10,
      chapters: const [ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 10)],
    );
    await SurveyRepository(t.ctx).createTasks(src.id);
    final task = await t.db.select(t.db.tasks).getSingle();
    await ReviewRepository(
      t.ctx,
      config: () async => const ReviewConfig(),
    ).record(taskId: task.id, rating: Rating.good, kind: ReviewKind.firstRead);
    await reminders.afterSession(_text);
    expect(scheduler.asked, 1, reason: 'asked only once');
    expect(scheduler.scheduled!.first, DateTime(2026, 10, 29, 19));

    await SettingsRepository(t.ctx).set(SettingKeys.reminderEnabled, false);
    await reminders.sync(_text);
    expect(scheduler.cancelled, isTrue);
  });
}
