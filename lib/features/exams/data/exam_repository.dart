import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';

/// Writes and reads [Exam] rows. Every write logs an Event.
///
/// 1.0 allows one upcoming exam at a time (CLAUDE.md, decisions).
final class ExamRepository extends EventSourcedRepository {
  ExamRepository(super.ctx);

  static const entity = 'exam';

  /// [date] is the exam's calendar day as `YYYY-MM-DD`.
  Future<Exam> create({
    required String name,
    required String date,
    int priority = 2,
  }) async {
    if (await _upcoming().getSingleOrNull() != null) {
      throw const InvalidOperationError(
        'PrepBelt 1.0 supports one upcoming exam at a time',
      );
    }
    final id = ctx.ids.next();
    return mutate(
      entity: entity,
      entityId: id,
      op: EventOp.create,
      body: (rec) => rec.insert(
        db.exams,
        ExamsCompanion(
          id: Value(id),
          name: Value(name),
          date: Value(date),
          priority: Value(priority),
          status: const Value(ExamStatus.upcoming),
        ),
      ),
    );
  }

  Future<Exam> update(
    String id, {
    Value<String> name = const Value.absent(),
    Value<String> date = const Value.absent(),
    Value<int> priority = const Value.absent(),
    Value<ExamStatus> status = const Value.absent(),
    Value<String?> resultNote = const Value.absent(),
  }) => mutate(
    entity: entity,
    entityId: id,
    op: EventOp.update,
    body: (rec) => rec.update(
      db.exams,
      id,
      ExamsCompanion(
        name: name,
        date: date,
        priority: priority,
        status: status,
        resultNote: resultNote,
      ),
    ),
  );

  Future<void> softDelete(String id) => mutate<void>(
    entity: entity,
    entityId: id,
    op: EventOp.delete,
    body: (rec) => rec.softDelete(db.exams, id),
  );

  Future<void> undo(String id) => undoLatest(entity, id);

  Stream<List<Exam>> watchAll() =>
      (db.select(db.exams)
            ..where((e) => e.deletedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .watch();

  Stream<Exam?> watch(String id) => (db.select(
    db.exams,
  )..where((e) => e.id.equals(id) & e.deletedAt.isNull())).watchSingleOrNull();

  /// The one upcoming exam of 1.0, if any.
  Stream<Exam?> watchCurrent() => _upcoming().watchSingleOrNull();

  SimpleSelectStatement<$ExamsTable, Exam> _upcoming() => db.select(db.exams)
    ..where(
      (e) => e.deletedAt.isNull() & e.status.equalsValue(ExamStatus.upcoming),
    )
    ..orderBy([(e) => OrderingTerm.asc(e.date)])
    ..limit(1);
}
