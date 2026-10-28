@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/features/sources/state/add_source_controller.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/sources/ui/add_source_screen.dart';
import 'package:prepbelt/features/sources/ui/sources_screen.dart';

import '../../support/pump.dart';

Source _source(String id, SourceType type, String title, int? units) => Source(
  id: id,
  createdAt: 0,
  updatedAt: 0,
  hlc: '0',
  deviceId: 'd',
  type: type,
  title: title,
  unitType: AddSourceState.unitTypeFor(type),
  totalUnits: units,
);

final _filled = [
  SourceSummary(
    source: _source('1', SourceType.pdf, 'HC Verma Vol 1', 480),
    chapterCount: 22,
    surveyedCount: 14,
  ),
  SourceSummary(
    source: _source('2', SourceType.video, 'Kinematics one-shot lecture', 95),
    chapterCount: 4,
    surveyedCount: 0,
  ),
  SourceSummary(
    source: _source(
      '3',
      SourceType.book,
      'NCERT Physics Part 1 — a long title that wraps to two lines',
      310,
    ),
    chapterCount: 8,
    surveyedCount: 8,
  ),
];

Widget sources(AsyncValue<List<SourceSummary>> value) => Scaffold(
  body: SourcesBody(
    summaries: value,
    onOpen: (_) {},
    onSurvey: (_) {},
    onAdd: () {},
    onRetry: () {},
    onMore: (_) {},
  ),
);

/// The Add source form after choosing a PDF with bookmarks.
Widget addSource() => ProviderScope(
  child: Consumer(
    builder: (context, ref, _) {
      final ctl = ref.read(addSourceControllerProvider.notifier);
      return Scaffold(
        body: AddSourceBody(
          state: const AddSourceState(
            type: SourceType.pdf,
            title: 'HC Verma Vol 1',
            totalUnits: 480,
            pdf: PdfSummary(
              name: 'HC Verma Vol 1.pdf',
              bytes: 18400000,
              pageCount: 480,
            ),
            bookmarksFound: true,
            mode: SplitMode.bookmarks,
            chapters: [
              ChapterPreview(
                title: 'Ch 1 Introduction',
                depth: 0,
                startUnit: 1,
                endUnit: 3,
                isShort: true,
              ),
              ChapterPreview(
                title: 'Ch 2 Physics and mathematics',
                depth: 0,
                startUnit: 4,
                endUnit: 39,
              ),
              ChapterPreview(
                title: 'Ch 3 Rest and motion',
                depth: 0,
                startUnit: 40,
                endUnit: 62,
              ),
              ChapterPreview(
                title: '3.1 Distance and displacement',
                depth: 1,
                startUnit: 40,
                endUnit: 47,
              ),
              ChapterPreview(
                title: 'Ch 4 The forces',
                depth: 0,
                startUnit: 63,
                endUnit: 120,
                sessions: 3,
              ),
            ],
          ),
          title: TextEditingController(text: 'HC Verma Vol 1'),
          units: TextEditingController(),
          link: TextEditingController(),
          paste: TextEditingController(),
          controller: ctl,
          onSave: () {},
          onSaveAndSurvey: () {},
          onOpenDuplicate: (_) {},
        ),
      );
    },
  ),
);

Widget addSourceEmpty() => ProviderScope(
  child: Consumer(
    builder: (context, ref, _) => Scaffold(
      body: AddSourceBody(
        state: const AddSourceState(),
        title: TextEditingController(),
        units: TextEditingController(),
        link: TextEditingController(),
        paste: TextEditingController(),
        controller: ref.read(addSourceControllerProvider.notifier),
        onSave: () {},
        onSaveAndSurvey: () {},
        onOpenDuplicate: (_) {},
      ),
    ),
  ),
);

void main() {
  goldenBoth('sources_390', () => sources(AsyncData(_filled)), height: 844);
  goldenBoth(
    'sources_360',
    () => sources(AsyncData(_filled)),
    width: 360,
    height: 780,
  );
  goldenBoth('sources_empty', () => sources(const AsyncData([])), height: 844);
  goldenBoth(
    'sources_error',
    () => sources(const AsyncError('x', StackTrace.empty)),
    height: 400,
  );
  goldenBoth('add_source_pdf_390', addSource, height: 1300);
  goldenBoth('add_source_pdf_360', addSource, width: 360, height: 1350);
  goldenBoth('add_source_empty', addSourceEmpty, height: 500);

  for (final (name, child) in [
    ('sources', () => sources(AsyncData(_filled))),
    ('add_source', addSource),
  ]) {
    testWidgets('$name at 1.3x text size', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 1500)
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
}
