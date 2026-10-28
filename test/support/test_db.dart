import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:sqlite3/open.dart';

bool _configured = false;

/// Makes the host's SQLite loadable in plain `flutter test` runs. Windows
/// has no `sqlite3.dll` on the path by default but ships `winsqlite3.dll`.
void configureTestSqlite() {
  if (_configured) return;
  _configured = true;
  if (Platform.isWindows) {
    open.overrideFor(OperatingSystem.windows, () {
      try {
        return DynamicLibrary.open('sqlite3.dll');
      } on ArgumentError {
        return DynamicLibrary.open('winsqlite3.dll');
      }
    });
  }
}

/// A fresh in-memory database.
AppDatabase openTestDatabase() {
  configureTestSqlite();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}
