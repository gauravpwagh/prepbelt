import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../session/data/session_repository.dart';
import 'review_repository.dart';

/// Everything Task detail shows (design/notes/task-detail.md).
final class TaskDetail {
  const TaskDetail({
    required this.info,
    required this.reviews,
    required this.planned,
    this.exam,
    this.examLink,
  });

  final SessionTask info;

  /// The review log, newest first, without undone rows.
  final List<Review> reviews;

  /// Scheduled reviews for this task (its belt target sets it).
  final int planned;
  final Exam? exam;
  final ExamTask? examLink;
}

/// Reads Task detail, re-reading when the task, its reviews or its exam
/// link change. Read-only.
final class TaskDetailRepository {
  TaskDetailRepository(
    this.db, {
    required this.sessions,
    required this.reviews,
  });

  final AppDatabase db;
  final SessionRepository sessions;
  final ReviewRepository reviews;

  /// Null when the task was removed or never existed.
  Stream<TaskDetail?> watch(String taskId) => db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.tasks,
          db.taskStates,
          db.taskChunks,
          db.reviews,
          db.examTasks,
          db.exams,
        },
      )
      .watch()
      .asyncMap((_) => load(taskId));

  Future<TaskDetail?> load(String taskId) async {
    final SessionTask info;
    try {
      info = await sessions.load(taskId);
    } on Object {
      return null;
    }
    final log =
        await (db.select(db.reviews)
              ..where((r) => r.taskId.equals(taskId) & r.deletedAt.isNull())
              ..orderBy([
                (r) => OrderingTerm.desc(r.at),
                (r) => OrderingTerm.desc(r.hlc),
              ]))
            .get();
    final exam =
        await (db.select(db.exams)
              ..where(
                (e) =>
                    e.deletedAt.isNull() &
                    e.status.equalsValue(ExamStatus.upcoming),
              )
              ..limit(1))
            .getSingleOrNull();
    final link = exam == null
        ? null
        : await (db.select(db.examTasks)..where(
                (l) =>
                    l.examId.equals(exam.id) &
                    l.taskId.equals(taskId) &
                    l.deletedAt.isNull(),
              ))
              .getSingleOrNull();
    return TaskDetail(
      info: info,
      reviews: log,
      planned: await reviews.plannedReviews(taskId),
      exam: exam,
      examLink: link,
    );
  }
}
