import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/result/result.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/session/data/session_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/reading_repository.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';

import '../../support/test_db.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late SessionRepository sessions;
  late ReadingRepository reading;
  late SourceRepository sources;
  late SurveyRepository survey;

  setUp(() {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    final reviews = ReviewRepository(
      t.ctx,
      config: () async => const ReviewConfig(),
    );
    sessions = SessionRepository(t.ctx, reviews: reviews);
    reading = ReadingRepository(t.ctx, reviews: reviews);
    sources = SourceRepository(t.ctx);
    survey = SurveyRepository(t.ctx);
  });
  tearDown(() => db.close());

  /// A book with two chapters, each its own task. Returns the task ids.
  Future<(Source, List<String>)> book() async {
    final s = await sources.createWithChunks(
      type: SourceType.book,
      title: 'HC Verma Vol 2',
      unitType: UnitType.page,
      totalUnits: 40,
      chapters: const [
        ChunkDraft(title: 'Thermodynamics', startUnit: 1, endUnit: 18),
        ChunkDraft(title: 'Kinetic theory', startUnit: 19, endUnit: 40),
      ],
    );
    await survey.createTasks(s.id);
    final links = await db.select(db.taskChunks).get();
    final chunks = await db.select(db.chunks).get();
    String taskOf(String title) => links
        .firstWhere(
          (l) => l.chunkId == chunks.firstWhere((c) => c.title == title).id,
        )
        .taskId;
    return (s, [taskOf('Thermodynamics'), taskOf('Kinetic theory')]);
  }

  test('a first read: start, stop early, finish; the next session resumes '
      'where it stopped', () async {
    final (_, ids) = await book();
    final info = await sessions.load(ids.first);
    expect(
      (info.firstRead, info.range, info.source?.title),
      (true, (start: 1, end: 18), 'HC Verma Vol 2'),
    );

    final s = await sessions.start(ids.first);
    expect((s.taskId, s.resumeUnit), (ids.first, 1));
    clock.advance(const Duration(minutes: 22));
    expect(
      SessionRepository.minutesSince(
        s.startedAt,
        clock.nowMs(),
        maxMinutes: 180,
      ),
      22,
    );

    final preview = await sessions.preview(ids.first);
    expect(
      preview.values.map((o) => o.levelAfter).toSet(),
      {1},
      reason: 'any first read earns White',
    );

    final review = await sessions.finish(
      rating: Rating.hard,
      minutes: 22,
      stopUnit: 12,
    );
    expect(
      (review.kind, review.durationSec, review.resumeUnit, review.levelAfter),
      (ReviewKind.firstRead, 22 * 60, 12, 1),
    );
    expect(await sessions.active(), isNull);

    final again = await sessions.load(ids.first);
    expect(
      (again.firstRead, again.resumeUnit, again.startUnit),
      (false, 12, 12),
    );
  });

  test(
    'Good on a review promotes; the rest dims and comes back tomorrow',
    () async {
      final (_, ids) = await book();
      await sessions.start(ids.first);
      await sessions.finish(rating: Rating.good, minutes: 30);
      clock.advance(const Duration(days: 1));

      final preview = await sessions.preview(ids.first);
      expect(preview[Rating.good]!.levelAfter, 2);
      expect(preview[Rating.forgot]!.levelAfter, 1);
      expect(preview[Rating.forgot]!.state.dim, 1);
      expect(
        preview[Rating.forgot]!.dueAfter,
        clock.now().add(const Duration(days: 1)),
      );

      await sessions.start(ids.first);
      final r = await sessions.finish(rating: Rating.good, minutes: 8);
      expect((r.kind, r.levelBefore, r.levelAfter), (ReviewKind.review, 1, 2));
    },
  );

  test('leaving records nothing', () async {
    final (_, ids) = await book();
    await sessions.start(ids.first);
    await sessions.discard();
    expect(await sessions.active(), isNull);
    expect(await db.select(db.reviews).get(), isEmpty);
  });

  test('a review and a reading sitting never run at once', () async {
    final (src, ids) = await book();
    await sessions.start(ids.first);
    expect(() => reading.start(src.id), throwsA(isA<InvalidOperationError>()));
    await sessions.discard();

    await reading.start(src.id);
    expect(
      () => sessions.start(ids.first),
      throwsA(isA<InvalidOperationError>()),
    );
  });

  test('starting again replaces an abandoned session', () async {
    final (_, ids) = await book();
    await sessions.start(ids.first);
    await sessions.start(ids.last);
    expect((await sessions.active())?.taskId, ids.last);
    expect(await db.select(db.activeSessions).get(), hasLength(1));
  });
}
