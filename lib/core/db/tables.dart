/// The 26 tables of docs/02-data-model.md.
///
/// Calendar dates (exam day, plan day, override day) are stored as
/// `YYYY-MM-DD` text in the student's local calendar; instants are UTC
/// milliseconds. See docs/07-decisions.md (D11, D12).
// Drift check constraints refer to their own column getter.
// ignore_for_file: recursive_getters
library;

import 'package:drift/drift.dart';

import 'enums.dart';

/// Convention columns shared by every syncable table.
mixin SyncColumns on Table {
  /// UUIDv7.
  TextColumn get id => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  /// Soft delete; rows are never physically removed in phase 1.
  IntColumn get deletedAt => integer().nullable()();
  TextColumn get hlc => text()();
  TextColumn get deviceId => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ------------------------------------------------- Syllabus and sources

class Topics extends Table with SyncColumns {
  TextColumn get parentId => text().nullable().references(Topics, #id)();
  TextColumn get name => text()();
  TextColumn get subject => text().nullable()();
  IntColumn get order => integer().named('sort_order')();
}

class Sources extends Table with SyncColumns {
  TextColumn get type => textEnum<SourceType>()();
  TextColumn get title => text()();
  TextColumn get uri => text().nullable()();
  TextColumn get unitType => textEnum<UnitType>()();
  IntColumn get totalUnits => integer().nullable()();
}

class SourceFiles extends Table with SyncColumns {
  TextColumn get sourceId => text().references(Sources, #id)();

  /// Relative to the app documents directory.
  TextColumn get localPath => text()();
  IntColumn get bytes => integer()();
  TextColumn get sha256 => text()();
}

class Chunks extends Table with SyncColumns {
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get parentChunkId => text().nullable().references(Chunks, #id)();
  TextColumn get title => text()();
  IntColumn get order => integer().named('sort_order')();
  IntColumn get startUnit => integer().nullable()();
  IntColumn get endUnit => integer().nullable()();
  IntColumn get sizeUnits => integer().nullable()();
}

class ChunkSurveys extends Table with SyncColumns {
  TextColumn get chunkId => text().unique().references(Chunks, #id)();

  /// 1 Easy, 2 Medium, 3 Hard.
  IntColumn get difficulty =>
      integer().check(difficulty.isBetweenValues(1, 3))();

  /// 0 New, 1 Seen it, 2 Comfortable.
  IntColumn get familiarity =>
      integer().check(familiarity.isBetweenValues(0, 2))();
  IntColumn get surveyedAt => integer()();
}

// ------------------------------------------------------ Tasks and mastery

@DataClassName('Task')
class Tasks extends Table with SyncColumns {
  TextColumn get topicId => text().nullable().references(Topics, #id)();
  TextColumn get title => text()();
  TextColumn get kind => textEnum<TaskKind>()();
  TextColumn get status => textEnum<TaskStatus>()();
  BoolColumn get needsDetail => boolean().withDefault(const Constant(false))();
}

@TableIndex(name: 'task_chunks_task', columns: {#taskId})
class TaskChunks extends Table with SyncColumns {
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get chunkId => text().references(Chunks, #id)();
  IntColumn get startUnit => integer().nullable()();
  IntColumn get endUnit => integer().nullable()();
  IntColumn get order => integer().named('sort_order')();
}

/// Cache of the review engine's state, rebuildable from [Reviews].
class TaskStates extends Table with SyncColumns {
  TextColumn get taskId => text().unique().references(Tasks, #id)();

  /// 0 = not started, 1..7 = belt.
  IntColumn get level => integer().check(level.isBetweenValues(0, 7))();
  RealColumn get fsrsStability => real().nullable()();
  RealColumn get fsrsDifficulty => real().nullable()();
  IntColumn get lastReviewAt => integer().nullable()();
  IntColumn get dueAt => integer().nullable()();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  IntColumn get pausedAt => integer().nullable()();
}

/// Append-only. The source of truth for mastery.
@TableIndex(name: 'reviews_task_at', columns: {#taskId, #at})
class Reviews extends Table with SyncColumns {
  TextColumn get taskId => text().references(Tasks, #id)();
  IntColumn get at => integer()();
  TextColumn get kind => textEnum<ReviewKind>()();

  /// 1 Forgot, 2 Hard, 3 Good, 4 Easy.
  IntColumn get rating => integer().check(rating.isBetweenValues(1, 4))();
  IntColumn get durationSec => integer()();
  IntColumn get resumeUnit => integer().nullable()();
  IntColumn get levelBefore => integer()();
  IntColumn get levelAfter => integer()();
  RealColumn get stabilityAfter => real()();
  IntColumn get dueAfter => integer()();
}

class TaskLineages extends Table with SyncColumns {
  @ReferenceName('childLineages')
  TextColumn get childTaskId => text().references(Tasks, #id)();
  @ReferenceName('parentLineages')
  TextColumn get parentTaskId => text().references(Tasks, #id)();
  TextColumn get op => textEnum<LineageOp>()();
  IntColumn get at => integer()();
}

/// Optional flashcards and questions (1.2). Named `StudyCard` to avoid
/// clashing with Flutter's `Card` widget.
@DataClassName('StudyCard')
class Cards extends Table with SyncColumns {
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get type => textEnum<CardType>()();
  TextColumn get front => text()();
  TextColumn get back => text()();

  /// JSON array of options for multiple choice.
  TextColumn get options => text().nullable()();
  IntColumn get order => integer().named('sort_order')();
}

class CardResults extends Table with SyncColumns {
  TextColumn get cardId => text().references(Cards, #id)();
  TextColumn get reviewId => text().references(Reviews, #id)();
  BoolColumn get correct => boolean()();
  IntColumn get answerMs => integer()();
}

// ---------------------------------------------------- Exams and planning

class Exams extends Table with SyncColumns {
  TextColumn get name => text()();

  /// `YYYY-MM-DD`.
  TextColumn get date => text()();

  /// 1 low, 2 normal, 3 high.
  IntColumn get priority => integer().check(priority.isBetweenValues(1, 3))();
  TextColumn get status => textEnum<ExamStatus>()();
  TextColumn get resultNote => text().nullable()();
}

class ExamChunks extends Table with SyncColumns {
  TextColumn get examId => text().references(Exams, #id)();
  TextColumn get chunkId => text().references(Chunks, #id)();
  TextColumn get importance => textEnum<Importance>()();
}

@TableIndex(name: 'exam_tasks_exam', columns: {#examId})
class ExamTasks extends Table with SyncColumns {
  TextColumn get examId => text().references(Exams, #id)();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get importance => textEnum<Importance>()();
  IntColumn get targetLevel =>
      integer().check(targetLevel.isBetweenValues(1, 7))();
  BoolColumn get importanceOverridden =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {examId, taskId},
  ];
}

class Availabilities extends Table with SyncColumns {
  /// 0 Monday .. 6 Sunday (ISO order, `DateTime.weekday - 1`).
  IntColumn get weekday => integer().check(weekday.isBetweenValues(0, 6))();
  IntColumn get minutes => integer()();
  TextColumn get lockedExamId => text().nullable().references(Exams, #id)();
}

class AvailabilityOverrides extends Table with SyncColumns {
  /// `YYYY-MM-DD`.
  TextColumn get date => text()();
  IntColumn get minutes => integer()();
  TextColumn get lockedExamId => text().nullable().references(Exams, #id)();
}

@TableIndex(name: 'plan_items_date', columns: {#date})
class PlanItems extends Table with SyncColumns {
  /// `YYYY-MM-DD`.
  TextColumn get date => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get examId => text().nullable().references(Exams, #id)();
  TextColumn get kind => textEnum<PlanItemKind>()();
  IntColumn get estMinutes => integer()();
  TextColumn get status => textEnum<PlanItemStatus>()();
  IntColumn get generation => integer()();

  /// Position within the day (planner spec, "Output").
  IntColumn get order => integer().named('sort_order')();
}

// ------------------------------------------------------------ Gamification

class Quests extends Table with SyncColumns {
  /// `YYYY-MM-DD`.
  TextColumn get date => text()();
  TextColumn get type => text()();
  IntColumn get target => integer()();
  IntColumn get progress => integer()();
  IntColumn get completedAt => integer().nullable()();
}

class Achievements extends Table with SyncColumns {
  TextColumn get code => text().unique()();
  IntColumn get unlockedAt => integer()();
}

class RestTokens extends Table with SyncColumns {
  IntColumn get earnedAt => integer()();

  /// `YYYY-MM-DD`.
  TextColumn get usedOn => text().nullable()();
}

// --------------------------------------------------- Templates and settings

class Templates extends Table with SyncColumns {
  TextColumn get kind => textEnum<TemplateKind>()();
  TextColumn get name => text()();
  TextColumn get author => text().nullable()();
  IntColumn get version => integer()();
  TextColumn get origin => textEnum<TemplateOrigin>()();

  /// JSON.
  TextColumn get payload => text()();
  IntColumn get importedAt => integer().nullable()();
}

class ImportMaps extends Table with SyncColumns {
  TextColumn get templateId => text().references(Templates, #id)();
  TextColumn get externalId => text()();
  TextColumn get localTable => text()();
  TextColumn get localId => text()();
}

class Settings extends Table with SyncColumns {
  TextColumn get key => text().unique()();

  /// JSON.
  TextColumn get value => text()();
}

// ----------------------------------------------------------- Sync and undo

@TableIndex(name: 'events_entity', columns: {#entity, #entityId})
class Events extends Table with SyncColumns {
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get op => textEnum<EventOp>()();

  /// JSON: `{"changes": [{"table", "id", "before", "after"}], "undoOf"?}`.
  TextColumn get payload => text()();
}

// ----------------------------------------------------------------- Session

/// At most one row. Not synced, so it has no hlc or soft delete.
class ActiveSessions extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  IntColumn get startedAt => integer()();
  IntColumn get resumeUnit => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
