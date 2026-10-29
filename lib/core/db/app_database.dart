import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.steps.dart';
import 'enums.dart';
import 'tables.dart';

export 'enums.dart';

part 'app_database.drift.dart';

@DriftDatabase(
  tables: [
    Topics,
    Sources,
    SourceFiles,
    Chunks,
    ChunkSurveys,
    ReadingSessions,
    Tasks,
    TaskChunks,
    TaskStates,
    Reviews,
    TaskLineages,
    Cards,
    CardResults,
    Exams,
    ExamChunks,
    ExamTasks,
    Availabilities,
    AvailabilityOverrides,
    PlanItems,
    Quests,
    Achievements,
    RestTokens,
    Templates,
    ImportMaps,
    Settings,
    Events,
    ActiveSessions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// The on-device database file.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'prepbelt'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // v1 was edited in place before any install kept data (D21); from v2 on
    // every change is a migration (D39).
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // Triage choices on ExamTask (docs/04-planner-spec.md, "Triage").
        await m.addColumn(schema.examTasks, schema.examTasks.triageKeep);
        await m.addColumn(schema.examTasks, schema.examTasks.dropped);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
