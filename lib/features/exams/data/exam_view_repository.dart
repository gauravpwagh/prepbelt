import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';

/// One task of the exam with its current state.
typedef ExamTaskRow = ({Task task, TaskState state, ExamTask link});

/// Reads what the Exam screen shows. Read-only.
final class ExamViewRepository {
  ExamViewRepository(this.db);

  final AppDatabase db;

  Stream<Exam?> watchExam(String id) => (db.select(
    db.exams,
  )..where((e) => e.id.equals(id) & e.deletedAt.isNull())).watchSingleOrNull();

  /// The exam's active tasks, re-read when tasks, states or links change.
  Stream<List<ExamTaskRow>> watchTasks(String examId) =>
      (db.select(db.examTasks).join([
            innerJoin(db.tasks, db.tasks.id.equalsExp(db.examTasks.taskId)),
            innerJoin(
              db.taskStates,
              db.taskStates.taskId.equalsExp(db.examTasks.taskId),
            ),
          ])..where(
            db.examTasks.examId.equals(examId) &
                db.examTasks.deletedAt.isNull() &
                db.tasks.deletedAt.isNull() &
                db.tasks.status.isNotValue(TaskStatus.archived.name),
          ))
          .watch()
          .map(
            (rows) => [
              for (final r in rows)
                (
                  task: r.readTable(db.tasks),
                  state: r.readTable(db.taskStates),
                  link: r.readTable(db.examTasks),
                ),
            ],
          );

  /// Review times and durations since [fromMs], for the activity grid.
  Stream<List<(int at, int seconds)>> watchStudy(int fromMs) {
    final at = db.reviews.at;
    final sec = db.reviews.durationSec;
    return (db.selectOnly(db.reviews)
          ..addColumns([at, sec])
          ..where(
            db.reviews.deletedAt.isNull() &
                db.reviews.at.isBiggerOrEqualValue(fromMs),
          ))
        .map((r) => (r.read(at)!, r.read(sec)!))
        .watch();
  }

  /// Study minutes per weekday, Monday first; [fallback] where unset.
  Stream<List<int>> watchWeek(int fallback) =>
      (db.select(
        db.availabilities,
      )..where((a) => a.deletedAt.isNull())).watch().map((rows) {
        final week = List.filled(7, fallback);
        for (final r in rows) {
          week[r.weekday] = r.minutes;
        }
        return week;
      });

  /// Planned items from [date] (`YYYY-MM-DD`) on, for "next step" and
  /// today's minutes.
  Stream<List<PlanItem>> watchPlanFrom(String date) =>
      (db.select(db.planItems)
            ..where(
              (p) =>
                  p.date.isBiggerOrEqualValue(date) &
                  p.status.equalsValue(PlanItemStatus.planned) &
                  p.deletedAt.isNull(),
            )
            ..orderBy([
              (p) => OrderingTerm.asc(p.date),
              (p) => OrderingTerm.asc(p.order),
            ]))
          .watch();
}
