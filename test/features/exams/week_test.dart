@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/exams/ui/week_sheet.dart';
import 'package:prepbelt/l10n/gen/app_localizations_en.dart';

import '../../support/pump.dart';
import '../../support/test_db.dart';

void main() {
  final l10n = AppLocalizationsEn();
  setUpAll(() => initializeDateFormatting('en'));

  test('the week reads as runs of equal days', () {
    expect(
      weekSummary(l10n, 'en', List.filled(7, 90)),
      'Every day · 1 h 30 min',
    );
    expect(
      weekSummary(l10n, 'en', [105, 105, 105, 105, 105, 105, 240]),
      'Mon–Sat 1 h 45 min · Sun 4 h',
    );
    expect(
      weekSummary(l10n, 'en', [60, 60, 0, 60, 60, 120, 120]),
      'Mon–Tue 1 h · Wed Off · Thu–Fri 1 h · Sat–Sun 2 h',
    );
  });

  test('saving the week writes all seven days and can be undone', () async {
    final t = openTestContext();
    addTearDown(t.db.close);
    final exams = ExamRepository(t.ctx);
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    await exams.setWeek(exam.id, [105, 105, 105, 105, 105, 105, 240]);
    List<int> week(List<Availability> rows) => [
      for (final r in rows..sort((a, b) => a.weekday.compareTo(b.weekday)))
        r.minutes,
    ];
    expect(week(await t.db.select(t.db.availabilities).get()), [
      105, 105, 105, 105, 105, 105, 240, //
    ]);
    await exams.setWeek(exam.id, [105, 105, 105, 105, 105, 105, 120]);
    await exams.undo(exam.id);
    expect(week(await t.db.select(t.db.availabilities).get()).last, 240);
  });

  goldenBoth(
    'week_sheet',
    () => Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: WeekSheet(
          week: const [105, 105, 105, 105, 105, 105, 240],
          onSave: (_) {},
        ),
      ),
    ),
    height: 700,
  );
}
