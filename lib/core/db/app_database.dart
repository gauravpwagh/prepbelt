import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'enums.dart';
import 'tables.dart';

export 'enums.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Topics,
    Sources,
    SourceFiles,
    Chunks,
    ChunkSurveys,
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
