import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';

import '../support/test_db.dart';
import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    configureTestSqlite();
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('a fresh database matches the current snapshot', () async {
    final connection = await verifier.startAt(2);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 2);
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
    await verifier.migrateAndValidate(db, 2);
    final link = await db.select(db.examTasks).getSingle();
    expect(
      (link.importance, link.targetLevel, link.triageKeep, link.dropped),
      (Importance.high, 7, false, false),
    );
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
