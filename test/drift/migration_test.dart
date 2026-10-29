import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';

import '../support/test_db.dart';
import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    configureTestSqlite();
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('a fresh database matches the current snapshot', () async {
    final connection = await verifier.startAt(4);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 4);
    await db.close();
  });

  test('v1 to v2 adds the triage columns and keeps existing rows', () async {
    final schema = await verifier.schemaAt(1);
    // An exam task as a v1 install stored it.
    final old = v1.DatabaseAtV1(schema.newConnection());
    await old.customStatement(
      'INSERT INTO exams (id, created_at, updated_at, hlc, device_id, name, '
      "date, priority, status) VALUES ('e', 0, 0, '0', 'd', 'JEE Main', "
      "'2027-01-10', 2, 'upcoming')",
    );
    await old.customStatement(
      'INSERT INTO tasks (id, created_at, updated_at, hlc, device_id, title, '
      "kind, status, needs_detail) VALUES ('t', 0, 0, '0', 'd', 'Units', "
      "'learn', 'active', 0)",
    );
    await old.customStatement(
      'INSERT INTO exam_tasks (id, created_at, updated_at, hlc, device_id, '
      'exam_id, task_id, importance, target_level, importance_overridden) '
      "VALUES ('x', 0, 0, '0', 'd', 'e', 't', 'high', 7, 0)",
    );
    await old.close();

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 4);
    final link = await db.select(db.examTasks).getSingle();
    expect(
      (link.importance, link.targetLevel, link.triageKeep, link.dropped),
      (Importance.high, 7, false, false),
    );
    await db.close();
  });

  test('v2 to v3 adds progressive and finishedAt to sources', () async {
    final schema = await verifier.schemaAt(2);
    final old = v2.DatabaseAtV2(schema.newConnection());
    await old.customStatement(
      'INSERT INTO sources (id, created_at, updated_at, hlc, device_id, type, '
      "title, unit_type, total_units) VALUES ('s', 0, 0, '0', 'd', 'book', "
      "'HC Verma', 'page', 300)",
    );
    await old.close();

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 4);
    final source = await db.select(db.sources).getSingle();
    expect(
      (source.title, source.progressive, source.finishedAt),
      ('HC Verma', false, null),
    );
    await db.close();
  });

  test('v3 to v4 adds reading by chapter and parts of chapters', () async {
    final schema = await verifier.schemaAt(3);
    final old = v3.DatabaseAtV3(schema.newConnection());
    await old.customStatement(
      'INSERT INTO sources (id, created_at, updated_at, hlc, device_id, type, '
      "title, unit_type, progressive) VALUES ('s', 0, 0, '0', 'd', 'book', "
      "'HC Verma', 'page', 0)",
    );
    await old.customStatement(
      'INSERT INTO reading_sessions (id, created_at, updated_at, hlc, '
      'device_id, source_id, started_at, start_unit, status) VALUES '
      "('r', 0, 0, '0', 'd', 's', 0, 1, 'open')",
    );
    await old.close();

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 4);
    final sitting = await db.select(db.readingSessions).getSingle();
    expect((sitting.startUnit, sitting.inChapter), (1, false));
    await db.close();
  });

  test('every schema version up to the current one has a snapshot', () {
    final db = openTestDatabase();
    addTearDown(db.close);
    expect(GeneratedHelper.versions, contains(db.schemaVersion));
    expect(GeneratedHelper.versions.first, 1);
  });

  test('the schema has the 27 tables of the data model', () {
    final db = openTestDatabase();
    addTearDown(db.close);
    expect(db.allTables.length, 27);
  });
}
