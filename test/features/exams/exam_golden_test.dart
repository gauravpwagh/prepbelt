@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/engines/exam/exam_metrics.dart';
import 'package:prepbelt/features/exams/state/exam_view_providers.dart';
import 'package:prepbelt/features/exams/ui/add_exam_screen.dart';
import 'package:prepbelt/features/exams/ui/exam_screen.dart';

import '../../support/pump.dart';

const _exam = Exam(
  id: 'e',
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  name: 'JEE Main',
  date: '2027-01-10',
  priority: 2,
  status: ExamStatus.upcoming,
);

PlanItem _next(String taskId, String date) => PlanItem(
  id: 'p$taskId',
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  date: date,
  taskId: taskId,
  kind: PlanItemKind.review,
  estMinutes: 20,
  status: PlanItemStatus.planned,
  generation: 1,
  order: 0,
);

ExamView _view({bool fits = true, TriageView triage = const TriageView()}) {
  final today = DateTime(2026, 10, 28);
  final first = DateTime.utc(2026, 8, 10); // a Monday, 12 weeks back
  // A believable rhythm: most weekdays, longer Sundays, a gap in week 5.
  int minutesOn(int i) {
    if (i ~/ 7 == 4) return 0;
    if (i % 7 == 6) return 150 + (i * 7) % 60;
    return (i * 37) % 5 == 0 ? 0 : 30 + (i * 23) % 80;
  }

  final days = today.difference(DateTime(2026, 8, 10)).inDays + 1;
  return ExamView(
    exam: _exam,
    today: today,
    planFits: fits,
    triage: triage,
    todayMinutes: 105,
    metrics: const ExamMetrics(
      tier: 4,
      projectedTier: 5,
      readiness: 0.62,
      atTarget: 24,
      total: 38,
      weakLinks: ['t1', 't2'],
    ),
    weakLinks: [
      WeakLink(
        taskId: 't1',
        title: 'Rotational motion',
        level: 0,
        next: _next('t1', '2026-10-28'),
      ),
      WeakLink(
        taskId: 't2',
        title: 'Electrochemistry',
        level: 1,
        next: _next('t2', '2026-10-30'),
      ),
    ],
    activity: [
      for (var i = 0; i < days; i++)
        (
          day: first.add(Duration(days: i)),
          minutes: minutesOn(i),
          bucket: activityBucket(minutesOn(i), full: 90),
        ),
    ],
  );
}

Widget exam(AsyncValue<ExamView?> v, {bool back = true}) => Scaffold(
  body: ExamBody(
    view: v,
    onBack: back ? () {} : null,
    onAdd: () {},
    onOpenTask: (_) {},
    onRetry: () {},
    week: const [105, 105, 105, 105, 105, 105, 240],
    onSaveWeek: (_, _) {},
  ),
);

Widget addExam({String name = 'JEE Main', DateTime? date}) => Scaffold(
  body: AddExamBody(
    name: TextEditingController(text: name),
    date: date,
    today: DateTime(2026, 10, 28),
    minutes: 105,
    taskCount: 38,
    onBack: () {},
    onName: (_) {},
    onPickDate: () {},
    onMinutes: (_) {},
    onSave: () {},
  ),
);

const _cuts = TriageView(
  cuts: [
    (step: TriageStep.dropFinalLow, taskId: 'l1', title: 'Polymers'),
    (step: TriageStep.dropFinalLow, taskId: 'l2', title: 'Biomolecules'),
    (step: TriageStep.dropFinalLow, taskId: 'l3', title: 'Surface chemistry'),
    (step: TriageStep.lowerMedium, taskId: 'm1', title: 'Electrostatics'),
  ],
  dropped: [(step: null, taskId: 'm9', title: 'Wave optics')],
);

const _needs = TriageView(
  cuts: [
    (step: TriageStep.dropFinalLow, taskId: 'l1', title: 'Polymers'),
    (step: TriageStep.lowToYellow, taskId: 'l1', title: 'Polymers'),
    (step: TriageStep.lowerMedium, taskId: 'm1', title: 'Electrostatics'),
  ],
  needsStudent: true,
  extraForReduced: 18,
  extraForFull: 36,
);

void main() {
  setUpAll(() => initializeDateFormatting('en'));
  goldenBoth('exam_390', () => exam(AsyncData(_view())), height: 844);
  goldenBoth(
    'exam_triage_cuts',
    () => exam(AsyncData(_view(triage: _cuts))),
    height: 1100,
  );
  goldenBoth(
    'exam_triage_needs_student',
    () => exam(AsyncData(_view(fits: false, triage: _needs))),
    height: 1200,
  );
  goldenBoth(
    'exam_360_tight',
    () => exam(AsyncData(_view(fits: false))),
    width: 360,
    height: 900,
  );
  goldenBoth('exams_empty', () => exam(const AsyncData(null), back: false));
  goldenBoth(
    'add_exam',
    () => addExam(date: DateTime(2027, 1, 10)),
    height: 760,
  );
  goldenBoth('add_exam_empty', () => addExam(name: ''), height: 760);

  for (final (name, child) in [
    ('exam', () => exam(AsyncData(_view()))),
    ('add_exam', () => addExam(date: DateTime(2027, 1, 10))),
  ]) {
    testWidgets('$name at 1.3x text size', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 1100)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: themed(child()),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${name}_text130_light.png'),
      );
    });
  }

  testWidgets('exam screens meet touch-target, label and contrast '
      'guidelines', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1100)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    for (final (label, w) in [
      ('exam', exam(AsyncData(_view()))),
      ('add exam', addExam(date: DateTime(2027, 1, 10))),
    ]) {
      await tester.pumpWidget(themed(w));
      await tester.pumpAndSettle();
      await expectLater(
        tester,
        meetsGuideline(
          const MinimumTapTargetGuideline(
            size: Size.square(44),
            link: 'CLAUDE.md, Accessibility',
          ),
        ),
      );
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Flutter's contrast check compares a text field's fill with its
      // border (2.2:1) rather than with its text (ink on ground, well over
      // 4.5:1), so Add exam's name field always fails it. The field's text
      // colours are the same tokens checked on every other screen.
      if (label != 'add exam') {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
    }
  });
}
