import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';

/// Writes and reads [Task] rows and their [TaskState] cache. Every write
/// logs an Event under the task's id.
final class TaskRepository extends EventSourcedRepository {
  TaskRepository(super.ctx);

  static const entity = 'task';

  /// Creates a task and its not-started TaskState (level 0) together.
  Future<Task> create({
    required String title,
    TaskKind kind = TaskKind.learn,
    String? topicId,
    bool needsDetail = false,
  }) {
    final id = ctx.ids.next();
    return mutate(
      entity: entity,
      entityId: id,
      op: EventOp.create,
      body: (rec) async {
        final task = await rec.insert(
          db.tasks,
          TasksCompanion(
            id: Value(id),
            title: Value(title),
            kind: Value(kind),
            status: const Value(TaskStatus.active),
            topicId: Value(topicId),
            needsDetail: Value(needsDetail),
          ),
        );
        await rec.insert(
          db.taskStates,
          TaskStatesCompanion(
            id: Value(rec.newId()),
            taskId: Value(id),
            level: const Value(0),
          ),
        );
        return task;
      },
    );
  }

  /// Rename, retopic or flag a task. No mastery effect.
  Future<Task> update(
    String id, {
    Value<String> title = const Value.absent(),
    Value<String?> topicId = const Value.absent(),
    Value<TaskKind> kind = const Value.absent(),
    Value<bool> needsDetail = const Value.absent(),
  }) => mutate(
    entity: entity,
    entityId: id,
    op: EventOp.update,
    body: (rec) => rec.update(
      db.tasks,
      id,
      TasksCompanion(
        title: title,
        topicId: topicId,
        kind: kind,
        needsDetail: needsDetail,
      ),
    ),
  );

  Future<void> softDelete(String id) => mutate<void>(
    entity: entity,
    entityId: id,
    op: EventOp.delete,
    body: (rec) => rec.softDelete(db.tasks, id),
  );

  /// Reverses the latest change to this task (never a review).
  Future<void> undo(String id) => undoLatest(entity, id);

  Stream<List<Task>> watchAll() =>
      (db.select(db.tasks)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Stream<Task?> watch(String id) => (db.select(
    db.tasks,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).watchSingleOrNull();

  Stream<TaskState?> watchState(String taskId) => (db.select(
    db.taskStates,
  )..where((s) => s.taskId.equals(taskId))).watchSingleOrNull();

  Future<TaskState> getState(String taskId) => (db.select(
    db.taskStates,
  )..where((s) => s.taskId.equals(taskId))).getSingle();
}
