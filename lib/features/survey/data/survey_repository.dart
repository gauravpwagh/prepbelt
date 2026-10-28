import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../sources/data/source_repository.dart';

/// One chapter as the survey shows it: the chunk, the student's answers
/// (null until surveyed) and its importance for the exam (null without an
/// exam or before it is set).
final class SurveyItem {
  const SurveyItem({required this.chunk, this.survey, this.importance});

  final Chunk chunk;
  final ChunkSurvey? survey;
  final Importance? importance;

  bool get surveyed => survey != null;
}

/// Writes survey answers: difficulty and familiarity (personal, on
/// ChunkSurvey) and importance (per exam, on ExamChunk). Answers for one
/// chapter are one undoable operation under the chunk's id.
final class SurveyRepository extends EventSourcedRepository {
  SurveyRepository(super.ctx);

  static const entity = 'chunk';

  /// Sets any of the three answers for [chunkId]. A chapter counts as
  /// surveyed once it has difficulty and familiarity; missing ones default
  /// to Medium and New (docs/04-planner-spec.md).
  Future<void> answer(
    String chunkId, {
    int? difficulty,
    int? familiarity,
    String? examId,
    Importance? importance,
  }) => mutate<void>(
    entity: entity,
    entityId: chunkId,
    op: EventOp.update,
    body: (rec) => _answer(
      rec,
      chunkId,
      difficulty: difficulty,
      familiarity: familiarity,
      examId: examId,
      importance: importance,
    ),
  );

  /// "Mark the other N as …": answers every chapter of [sourceId] that is
  /// not yet surveyed, in one undoable operation under the source's id.
  /// Returns how many chapters it answered.
  Future<int> answerRemaining(
    String sourceId, {
    required int difficulty,
    required int familiarity,
    String? examId,
    Importance? importance,
  }) async {
    final pending = [
      for (final item in await items(sourceId, examId: examId))
        if (!item.surveyed) item.chunk.id,
    ];
    if (pending.isEmpty) return 0;
    await mutate<void>(
      entity: SourceRepository.entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': 'surveyRemaining', 'count': pending.length},
      body: (rec) async {
        for (final id in pending) {
          await _answer(
            rec,
            id,
            difficulty: difficulty,
            familiarity: familiarity,
            examId: examId,
            importance: importance,
          );
        }
      },
    );
    return pending.length;
  }

  /// Undoes the latest survey change to one chapter.
  Future<void> undo(String chunkId) => undoLatest(entity, chunkId);

  Future<void> _answer(
    ChangeRecorder rec,
    String chunkId, {
    int? difficulty,
    int? familiarity,
    String? examId,
    Importance? importance,
  }) async {
    if (difficulty != null || familiarity != null) {
      final existing = await (db.select(
        db.chunkSurveys,
      )..where((s) => s.chunkId.equals(chunkId))).getSingleOrNull();
      if (existing == null) {
        await rec.insert(
          db.chunkSurveys,
          ChunkSurveysCompanion(
            id: Value(rec.newId()),
            chunkId: Value(chunkId),
            difficulty: Value(difficulty ?? 2),
            familiarity: Value(familiarity ?? 0),
            surveyedAt: Value(rec.now),
          ),
        );
      } else {
        await rec.update(
          db.chunkSurveys,
          existing.id,
          ChunkSurveysCompanion(
            difficulty: difficulty == null
                ? const Value.absent()
                : Value(difficulty),
            familiarity: familiarity == null
                ? const Value.absent()
                : Value(familiarity),
            surveyedAt: Value(rec.now),
            deletedAt: const Value(null),
          ),
        );
      }
    }
    if (examId != null && importance != null) {
      final existing =
          await (db.select(db.examChunks)..where(
                (l) => l.examId.equals(examId) & l.chunkId.equals(chunkId),
              ))
              .getSingleOrNull();
      if (existing == null) {
        await rec.insert(
          db.examChunks,
          ExamChunksCompanion(
            id: Value(rec.newId()),
            examId: Value(examId),
            chunkId: Value(chunkId),
            importance: Value(importance),
          ),
        );
      } else {
        await rec.update(
          db.examChunks,
          existing.id,
          ExamChunksCompanion(
            importance: Value(importance),
            deletedAt: const Value(null),
          ),
        );
      }
    }
  }

  /// The source's chapters with their answers, in reading order. Parts
  /// nested under a chapter are left out: the survey asks per chapter.
  Future<List<SurveyItem>> items(String sourceId, {String? examId}) =>
      _query(sourceId, examId).get().then(_items);

  Stream<List<SurveyItem>> watchItems(String sourceId, {String? examId}) =>
      _query(sourceId, examId).watch().map(_items);

  JoinedSelectStatement<HasResultSet, dynamic> _query(
    String sourceId,
    String? examId,
  ) {
    final query =
        db.select(db.chunks).join([
            leftOuterJoin(
              db.chunkSurveys,
              db.chunkSurveys.chunkId.equalsExp(db.chunks.id) &
                  db.chunkSurveys.deletedAt.isNull(),
            ),
            leftOuterJoin(
              db.examChunks,
              db.examChunks.chunkId.equalsExp(db.chunks.id) &
                  db.examChunks.examId.equals(examId ?? '') &
                  db.examChunks.deletedAt.isNull(),
            ),
          ])
          ..where(
            db.chunks.sourceId.equals(sourceId) &
                db.chunks.parentChunkId.isNull() &
                db.chunks.deletedAt.isNull(),
          )
          ..orderBy([
            OrderingTerm.asc(db.chunks.startUnit, nulls: NullsOrder.last),
            OrderingTerm.asc(db.chunks.order),
          ]);
    return query;
  }

  List<SurveyItem> _items(List<TypedResult> rows) => [
    for (final r in rows)
      SurveyItem(
        chunk: r.readTable(db.chunks),
        survey: r.readTableOrNull(db.chunkSurveys),
        importance: r.readTableOrNull(db.examChunks)?.importance,
      ),
  ];
}
