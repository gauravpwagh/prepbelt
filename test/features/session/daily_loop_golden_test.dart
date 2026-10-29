@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/engines/review/review_engine.dart';
import 'package:prepbelt/features/session/state/session_providers.dart';
import 'package:prepbelt/features/session/ui/session_screen.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';
import 'package:prepbelt/features/tasks/state/task_detail_providers.dart';
import 'package:prepbelt/features/tasks/ui/task_detail_screen.dart';
import 'package:prepbelt/features/today/state/today_providers.dart';
import 'package:prepbelt/features/today/ui/today_screen.dart';

import '../../support/pump.dart';

final _now = DateTime.utc(2026, 10, 28, 12);
final _nowMs = _now.millisecondsSinceEpoch;
final _engine = ReviewEngine(const ReviewConfig());
const _day = Duration.millisecondsPerDay;

Source _source(String id, String title, {UnitType unit = UnitType.page}) =>
    Source(
      id: id,
      createdAt: 0,
      updatedAt: 0,
      hlc: '0',
      deviceId: 'd',
      type: SourceType.book,
      title: title,
      unitType: unit,
      totalUnits: 480,
    );

SessionTask _task(
  String id,
  String title, {
  required Source source,
  int start = 1,
  int end = 20,
  int level = 0,
  int step = 0,
  int dim = 0,
  int reps = 0,
  int? dueAt,
  int? resume,
}) => SessionTask(
  task: Task(
    id: id,
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    title: title,
    kind: TaskKind.learn,
    status: TaskStatus.active,
    needsDetail: false,
  ),
  state: TaskState(
    id: 's$id',
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    taskId: id,
    level: level,
    step: step,
    dim: dim,
    reps: reps,
    lapses: 0,
    lastReviewAt: reps == 0 ? null : _nowMs - 9 * _day,
    dueAt: dueAt,
  ),
  parts: [
    (
      chunk: Chunk(
        id: 'c$id',
        createdAt: 0,
        updatedAt: 0,
        hlc: '0',
        deviceId: 'd',
        sourceId: source.id,
        title: title,
        order: 0,
        startUnit: start,
        endUnit: end,
      ),
      source: source,
      link: TaskChunk(
        id: 'l$id',
        createdAt: 0,
        updatedAt: 0,
        hlc: '0',
        deviceId: 'd',
        taskId: id,
        chunkId: 'c$id',
        order: 0,
      ),
    ),
  ],
  resumeUnit: resume,
);

LevelDisplay _display(SessionTask t) =>
    _engine.display(ReviewRepository.toReviewState(t.state), _now);

final _hcv2 = _source('s1', 'HC Verma Vol 2');
final _thermo = _task(
  't1',
  'Thermodynamics, 2nd law',
  source: _hcv2,
  start: 210,
  end: 228,
  level: 4,
  step: 3,
  reps: 3,
  dueAt: _nowMs - 3600000,
);

SessionView _sessionView(SessionTask t) {
  final state = ReviewRepository.toReviewState(t.state);
  return SessionView(
    info: t,
    display: _display(t),
    outcomes: {
      for (final r in Rating.values)
        r: _engine.applyReview(
          state,
          r,
          _now,
          deadline: DateTime.utc(2027, 1, 10),
          planned: 5,
        ),
    },
    maxMinutes: 180,
    session: ActiveSession(
      id: 'a',
      taskId: t.task.id,
      startedAt: _nowMs - 22 * 60000,
      createdAt: 0,
      updatedAt: 0,
    ),
  );
}

Widget session(SessionTask t, {Rating? rating, int? stop}) {
  final v = _sessionView(t);
  return Scaffold(
    body: SessionBody(
      view: v,
      minutes: 22,
      nowMs: _nowMs,
      rating: rating,
      stop: stop,
      onRate: (_) {},
      onStop: (_) {},
      onDone: () {},
      onClose: () {},
      onOpenAgain: () {},
      onBackToToday: () {},
    ),
  );
}

TodayView _todayView({List<TodayCard>? cards, bool hasTasks = true}) {
  final items = [
    TodayItem(kind: TodayKind.review, info: _thermo, minutes: 20),
    TodayItem(
      kind: TodayKind.review,
      info: _task(
        't2',
        'SN1 and SN2 reactions',
        source: _source('s2', 'MS Chouhan'),
        start: 60,
        end: 81,
        level: 3,
        step: 2,
        dim: 1,
        reps: 3,
        dueAt: _nowMs - 3600000,
      ),
      minutes: 15,
    ),
    TodayItem(
      kind: TodayKind.overdue,
      overdueDays: 2,
      info: _task(
        't3',
        'Electrostatics',
        source: _source('s3', 'Class notes'),
        end: 14,
        level: 2,
        step: 1,
        reps: 2,
        dueAt: _nowMs - 6 * _day,
      ),
      minutes: 25,
    ),
    TodayItem(
      kind: TodayKind.firstRead,
      info: _task(
        't4',
        'Rotational motion',
        source: _source('s4', 'HC Verma Vol 1'),
        start: 166,
        end: 197,
      ),
      minutes: 45,
    ),
  ];
  return TodayView(
    today: DateTime(2026, 10, 28),
    streak: 12,
    hasTasks: hasTasks,
    exam: const Exam(
      id: 'e',
      createdAt: 0,
      updatedAt: 0,
      hlc: '0',
      deviceId: 'd',
      name: 'JEE Main',
      date: '2027-01-10',
      priority: 2,
      status: ExamStatus.upcoming,
    ),
    cards:
        cards ?? [for (final i in items) (item: i, display: _display(i.info!))],
  );
}

Widget today(AsyncValue<TodayView> v) => Scaffold(
  body: TodayBody(
    view: v,
    onStart: (_) {},
    onStartReading: (_) {},
    onOpenTask: (_) {},
    onOpenSource: (_) {},
    onOpenExam: (_) {},
    onAddSource: () {},
    onRetry: () {},
  ),
);

Review _review(int daysAgo, Rating r, int before, int after, int step) =>
    Review(
      id: 'r$daysAgo',
      createdAt: 0,
      updatedAt: 0,
      hlc: '$daysAgo',
      deviceId: 'd',
      taskId: 't1',
      at: _nowMs - daysAgo * _day,
      kind: before == 0 ? ReviewKind.firstRead : ReviewKind.review,
      rating: r.value,
      durationSec: 22 * 60,
      levelBefore: before,
      levelAfter: after,
      stepAfter: step,
    );

TaskDetailView _detail(SessionTask t, List<Review> log) => TaskDetailView(
  detail: TaskDetail(
    info: t,
    reviews: log,
    planned: 5,
    exam: _todayView().exam,
    examLink: const ExamTask(
      id: 'x',
      createdAt: 0,
      updatedAt: 0,
      hlc: '0',
      deviceId: 'd',
      examId: 'e',
      taskId: 't1',
      importance: Importance.high,
      targetLevel: 7,
      importanceOverridden: false,
    ),
  ),
  display: _display(t),
  firstReadMinutes: 45,
  now: _now,
);

Widget detail(AsyncValue<TaskDetailView?> v) => Scaffold(
  body: TaskDetailBody(
    view: v,
    onBack: () {},
    onStart: () {},
    onOpenSource: (_) {},
    onRetry: () {},
  ),
);

final _history = [
  _review(1, Rating.good, 3, 4, 3),
  _review(9, Rating.good, 2, 3, 2),
  _review(12, Rating.forgot, 2, 2, 1),
  _review(20, Rating.good, 1, 2, 1),
  _review(30, Rating.easy, 0, 1, 0),
];

void main() {
  goldenBoth('session_390', () => session(_thermo, stop: 226), height: 844);
  goldenBoth(
    'session_rated_good_390',
    () => session(_thermo, rating: Rating.good),
    height: 900,
  );
  goldenBoth(
    'session_rated_forgot_360',
    () => session(_thermo, rating: Rating.forgot),
    width: 360,
    height: 940,
  );
  goldenBoth(
    'session_first_read',
    () => session(
      _task('t4', 'Rotational motion', source: _hcv2, start: 166, end: 197),
      rating: Rating.hard,
    ),
    height: 940,
  );
  goldenBoth('today_390', () => today(AsyncData(_todayView())), height: 844);
  goldenBoth(
    'today_360',
    () => today(AsyncData(_todayView())),
    width: 360,
    height: 880,
  );
  goldenBoth(
    'today_done',
    () => today(AsyncData(_todayView(cards: const []))),
    height: 600,
  );
  goldenBoth(
    'today_empty',
    () => today(AsyncData(_todayView(cards: const [], hasTasks: false))),
    height: 640,
  );
  goldenBoth('today_loading', () => today(const AsyncLoading()), height: 420);
  goldenBoth(
    'task_detail_390',
    () => detail(AsyncData(_detail(_thermo, _history))),
    height: 1100,
  );
  goldenBoth(
    'task_detail_new',
    () => detail(
      AsyncData(
        _detail(
          _task('t4', 'Rotational motion', source: _hcv2, start: 166, end: 197),
          const [],
        ),
      ),
    ),
    height: 760,
  );
  goldenBoth(
    'task_detail_removed',
    () => detail(const AsyncData(null)),
    height: 400,
  );

  for (final (name, child) in [
    ('session', () => session(_thermo, rating: Rating.good)),
    ('today', () => today(AsyncData(_todayView()))),
    ('task_detail', () => detail(AsyncData(_detail(_thermo, _history)))),
  ]) {
    testWidgets('$name at 1.3x text size', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 1300)
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

  testWidgets('daily-loop screens meet touch-target, label and contrast '
      'guidelines', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1300)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    for (final w in [
      session(_thermo, rating: Rating.good),
      today(AsyncData(_todayView())),
      detail(AsyncData(_detail(_thermo, _history))),
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
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
  });
}
