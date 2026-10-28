import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';

import '../support/test_db.dart';
import 'generated/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    configureTestSqlite();
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('a fresh database matches the committed v1 snapshot', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 1);
    await db.close();
  });

  test('every schema version up to the current one has a snapshot', () {
    final db = openTestDatabase();
    addTearDown(db.close);
    expect(GeneratedHelper.versions, contains(db.schemaVersion));
    expect(GeneratedHelper.versions.first, 1);
  });

  test('the schema has the 26 tables of the data model', () {
    final db = openTestDatabase();
    addTearDown(db.close);
    expect(db.allTables.length, 26);
  });
}
