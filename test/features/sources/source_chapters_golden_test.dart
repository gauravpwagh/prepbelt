@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/engines/reading/reading_math.dart';
import 'package:prepbelt/features/sources/state/reading_providers.dart';
import 'package:prepbelt/features/sources/ui/add_task_sheet.dart';
import 'package:prepbelt/features/sources/ui/reading_sheet.dart';
import 'package:prepbelt/features/sources/ui/source_chapters_screen.dart';

import '../../support/pump.dart';

const _source = Source(
  id: 's',
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  type: SourceType.pdf,
  title: 'HC Verma Vol 1',
  unitType: UnitType.page,
  totalUnits: 480,
  progressive: false,
);

Chunk _chunk(String id, String title, int start, int end) => Chunk(
  id: id,
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  sourceId: 's',
  title: title,
  order: 0,
  startUnit: start,
  endUnit: end,
);

ChunkSurvey _survey(String chunkId, int d, int f) => ChunkSurvey(
  id: 'v$chunkId',
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  chunkId: chunkId,
  difficulty: d,
  familiarity: f,
  surveyedAt: 0,
);

ReadingSession _sitting(int start, int end, int minutes) => ReadingSession(
  id: 'r$start',
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  sourceId: 's',
  startedAt: 0,
  startUnit: start,
  endUnit: end,
  minutes: minutes,
  status: ReadingStatus.saved,
);

/// Ch 1–2 read as one task, Ch 3 read with its own task, Ch 4 partly read,
/// the rest untouched.
SourceProgress _progress({bool fresh = false}) {
  final chapters = [
    _chunk('c1', 'Ch 1 Introduction', 1, 3),
    _chunk('c2', 'Ch 2 Physics and mathematics', 4, 39),
    _chunk('c3', 'Ch 3 Rest and motion', 40, 62),
    _chunk('c4', 'Ch 4 The forces', 63, 120),
    _chunk('c5', 'Ch 5 Newton’s laws of motion', 121, 160),
    _chunk('c6', 'Ch 6 Friction', 161, 188),
  ];
  final sittings = fresh
      ? <ReadingSession>[]
      : [_sitting(1, 39, 95), _sitting(40, 80, 110)];
  final explored = unionOf([
    for (final s in sittings) UnitRange(s.startUnit, s.endUnit!),
  ]);
  ChapterProgress ch(
    int i, {
    String? task,
    int order = 0,
    int level = 0,
    int dim = 0,
    Importance? importance,
    ChunkSurvey? survey,
  }) {
    final c = chapters[i];
    return ChapterProgress(
      chunk: c,
      survey: survey,
      importance: importance,
      taskId: task,
      taskTitle: task,
      taskLevel: level,
      taskDim: dim,
      taskOrder: order,
      readUnits: coveredUnits(explored, UnitRange(c.startUnit!, c.endUnit!)),
    );
  }

  return SourceProgress(
    source: _source,
    sittings: sittings,
    explored: explored,
    chapters: fresh
        ? [for (var i = 0; i < chapters.length; i++) ch(i)]
        : [
            ch(0, task: 't1', level: 2, importance: Importance.high),
            ch(1, task: 't1', order: 1, level: 2),
            ch(
              2,
              task: 't2',
              level: 1,
              dim: 1,
              importance: Importance.medium,
              survey: _survey('c3', 3, 1),
            ),
            ch(3, survey: _survey('c4', 2, 0), importance: Importance.high),
            ch(4),
            ch(5),
          ],
  );
}

SourceChaptersView _view({bool fresh = false}) => SourceChaptersView(
  progress: _progress(fresh: fresh),
  pace: 2.5,
  examId: 'e',
  examName: 'JEE Main',
);

Widget chapters(AsyncValue<SourceChaptersView?> v) => Scaffold(
  body: SourceChaptersBody(
    view: v,
    onBack: () {},
    onRead: () {},
    onFinish: () {},
    onSurvey: () {},
    onCreateAll: (_) {},
    onAddTask: (_, _) {},
    onOpenTask: (_) {},
    onRetry: () {},
  ),
);

Widget addTask() => Scaffold(
  body: Align(
    alignment: Alignment.bottomCenter,
    child: AddTaskSheet(view: _view(), index: 3, onCreate: (_) {}),
  ),
);

Widget readingSheet() => ProviderScope(
  child: Scaffold(
    body: Align(
      alignment: Alignment.bottomCenter,
      child: ReadingSheetBody(
        reading: OpenReading(
          sessionId: 'r',
          progress: _progress(),
          startUnit: 81,
          awayMinutes: 120,
          pace: 2.5,
          config: const ReadingConfig(),
          examId: 'e',
        ),
        onSave: (_) async {},
        onDiscard: () {},
      ),
    ),
  ),
);

void main() {
  goldenBoth('chapters_390', () => chapters(AsyncData(_view())), height: 960);
  goldenBoth(
    'chapters_360',
    () => chapters(AsyncData(_view())),
    width: 360,
    height: 1000,
  );
  goldenBoth(
    'chapters_new',
    () => chapters(AsyncData(_view(fresh: true))),
    height: 900,
  );
  goldenBoth(
    'chapters_loading',
    () => chapters(const AsyncLoading()),
    height: 420,
  );
  goldenBoth(
    'chapters_error',
    () => chapters(const AsyncError('x', StackTrace.empty)),
    height: 300,
  );
  goldenBoth('add_task_sheet', addTask, height: 700);
  goldenBoth('reading_sheet', readingSheet, height: 900);
  goldenBoth('reading_sheet_360', readingSheet, width: 360, height: 940);

  for (final (name, child) in [
    ('chapters', () => chapters(AsyncData(_view()))),
    ('reading_sheet', readingSheet),
  ]) {
    testWidgets('$name at 1.3x text size', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 1200)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: themed(child()),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${name}_text130_light.png'),
      );
    });
  }

  testWidgets('chapter rows meet touch-target and label guidelines', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1100)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(themed(chapters(AsyncData(_view()))));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('the reading sheet previews the save as the page changes', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    ReadingChoice? saved;
    await tester.pumpWidget(
      themed(
        Scaffold(
          body: ReadingSheetBody(
            reading: OpenReading(
              sessionId: 'r',
              progress: _progress(),
              startUnit: 81,
              awayMinutes: 120,
              pace: 2.5,
              config: const ReadingConfig(),
            ),
            onSave: (choice) async => saved = choice,
            onDiscard: () {},
          ),
        ),
      ),
    );
    // 120 min at 2.5 min a page from p. 81: up to p. 128.
    expect(find.text('p. 128'), findsOneWidget);
    expect(
      find.textContaining('Creates task Ch 4 The forces (pp. 63–120)'),
      findsOneWidget,
    );
    expect(find.textContaining('Ch 5 Newton’s laws'), findsWidgets);

    await tester.tap(find.text('End of Ch 4 The forces · p. 120'));
    await tester.pump();
    expect(find.text('p. 120'), findsOneWidget);
    expect(find.textContaining('Ch 5'), findsNothing);

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(
      (saved?.endUnit, saved?.minutes, saved?.taskNow.isEmpty, saved?.readOn),
      (120, 120, true, false),
    );
  });
}
