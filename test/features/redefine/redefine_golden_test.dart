@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/engines/review/review_engine.dart';
import 'package:prepbelt/features/redefine/state/redefine_providers.dart';
import 'package:prepbelt/features/redefine/ui/redefine_sheet.dart';
import 'package:prepbelt/features/session/state/session_providers.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';

import '../../support/pump.dart';

final _now = DateTime.utc(2026, 10, 28, 12);
const _day = Duration.millisecondsPerDay;

RedefineView _view({bool paused = false, int level = 4}) {
  const source = Source(
    id: 's',
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    type: SourceType.book,
    title: 'HC Verma Vol 2',
    unitType: UnitType.page,
    totalUnits: 480,
  );
  final state = TaskState(
    id: 'st',
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    taskId: 't',
    level: level,
    step: level - 1,
    dim: 0,
    reps: level,
    lapses: 0,
    lastReviewAt: _now.millisecondsSinceEpoch - 9 * _day,
    dueAt: DateTime.utc(2026, 10, 30).millisecondsSinceEpoch,
    pausedAt: paused ? _now.millisecondsSinceEpoch : null,
  );
  final info = SessionTask(
    task: Task(
      id: 't',
      createdAt: 0,
      updatedAt: 0,
      hlc: '0',
      deviceId: 'd',
      title: 'Thermodynamics, 2nd law',
      kind: TaskKind.learn,
      status: paused ? TaskStatus.paused : TaskStatus.active,
      needsDetail: false,
    ),
    state: state,
    parts: [
      (
        chunk: const Chunk(
          id: 'c',
          createdAt: 0,
          updatedAt: 0,
          hlc: '0',
          deviceId: 'd',
          sourceId: 's',
          title: 'Thermodynamics',
          order: 0,
          startUnit: 210,
          endUnit: 228,
        ),
        source: source,
        link: const TaskChunk(
          id: 'l',
          createdAt: 0,
          updatedAt: 0,
          hlc: '0',
          deviceId: 'd',
          taskId: 't',
          chunkId: 'c',
          order: 0,
        ),
      ),
    ],
  );
  return RedefineView(
    info: info,
    display: ReviewEngine(
      const ReviewConfig(),
    ).display(ReviewRepository.toReviewState(state), _now),
    planned: 4,
    examId: 'e',
    examName: 'JEE Main',
    importance: Importance.medium,
  );
}

final _noop = RedefineCallbacks(
  save: (_, _) async {},
  setScope: (_, _, _) async {},
  split: (_, _, _) async {},
  togglePause: () async {},
  cancel: () {},
);

Widget sheet(RedefineMode mode, {RedefineView? view}) => Scaffold(
  backgroundColor: const Color(0xFF5B6072),
  body: Align(
    alignment: Alignment.bottomCenter,
    child: Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: RedefineSheetBody(
          view: view ?? _view(),
          nowMs: _now.millisecondsSinceEpoch,
          callbacks: _noop,
          initialMode: mode,
        ),
      ),
    ),
  ),
);

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  goldenBoth('redefine_split', () => sheet(RedefineMode.split), height: 844);
  goldenBoth(
    'redefine_split_360',
    () => sheet(RedefineMode.split),
    width: 360,
    height: 900,
  );
  goldenBoth('redefine_edit', () => sheet(RedefineMode.edit), height: 700);
  goldenBoth('redefine_scope', () => sheet(RedefineMode.scope), height: 760);
  goldenBoth(
    'redefine_resume',
    () => sheet(RedefineMode.pause, view: _view(paused: true)),
    height: 520,
  );

  testWidgets('redefine split at 1.3x text size', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1100)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: themed(sheet(RedefineMode.split)),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/redefine_split_text130_light.png'),
    );
  });

  testWidgets('the split handle moves by drag and by screen reader', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    int? after;
    await tester.pumpWidget(
      themed(
        Scaffold(
          body: RedefineSheetBody(
            view: _view(),
            nowMs: _now.millisecondsSinceEpoch,
            initialMode: RedefineMode.split,
            callbacks: RedefineCallbacks(
              save: (_, _) async {},
              setScope: (_, _, _) async {},
              split: (a, _, _) async => after = a,
              togglePause: () async {},
              cancel: () {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('after p. 219'), findsOneWidget);
    final bar = find.bySemanticsLabel(RegExp('^Split after'));
    final semantics = tester.getSemantics(bar);
    expect(semantics.value, 'Split after p. 219');
    // Drag to the far left: the split can't go below the first page.
    await tester.drag(bar, const Offset(-400, 0));
    await tester.pump();
    expect(find.text('after p. 210'), findsOneWidget);
    await tester.tap(find.text('Split into 2 tasks'));
    await tester.pump();
    expect(after, 210);
  });
}
