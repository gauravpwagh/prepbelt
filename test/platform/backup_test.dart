import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/db/event_log.dart';
import 'package:prepbelt/core/ids/ids.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/settings/data/backup_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/platform/files/backup.dart';
import 'package:prepbelt/platform/files/file_store.dart';

import '../support/test_db.dart';

void main() {
  late Directory phoneA;
  late Directory phoneB;

  setUp(() {
    configureTestSqlite();
    phoneA = Directory.systemTemp.createTempSync('phoneA');
    phoneB = Directory.systemTemp.createTempSync('phoneB');
  });
  tearDown(() {
    phoneA.deleteSync(recursive: true);
    phoneB.deleteSync(recursive: true);
  });

  AppDatabase open(Directory docs) =>
      AppDatabase(NativeDatabase(File(p.join(docs.path, Backup.dbName))));

  test('backup on one phone, restore on a fresh one: everything comes '
      'back, the PDF included', () async {
    final clock = FakeClock(DateTime.utc(2026, 10, 29, 9));
    final db = open(phoneA);
    final ctx = WriteContext(
      db: db,
      clock: clock,
      ids: IdGenerator(clock),
      deviceId: 'phone-a',
    );
    final pdf = File(p.join(phoneA.path, 'in.pdf'))
      ..writeAsBytesSync([37, 80, 68, 70, 1, 2, 3]);
    final stored = await FileStore(root: phoneA, ids: ctx.ids).copyIn(pdf);
    final source = await SourceRepository(ctx).createWithChunks(
      type: SourceType.pdf,
      title: 'HC Verma Vol 1',
      unitType: UnitType.page,
      totalUnits: 40,
      chapters: const [
        ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 20),
        ChunkDraft(title: 'Ch 2', startUnit: 21, endUnit: 40),
      ],
      file: stored,
    );
    final exam = await ExamRepository(
      ctx,
    ).create(name: 'JEE Main', date: '2027-01-10');
    await SurveyRepository(ctx).createTasks(source.id, examId: exam.id);

    final bytes = await BackupRepository(
      db,
      documents: phoneA,
      clock: clock,
    ).export();
    final before = {
      for (final t in db.allTables)
        t.actualTableName:
            (await db
                    .customSelect(
                      'SELECT COUNT(*) AS n FROM ${t.actualTableName}',
                    )
                    .getSingle())
                .read<int>('n'),
    };
    await db.close();

    // Phone B: a fresh install stages the backup, then restarts.
    final fresh = open(phoneB);
    final made = BackupRepository(
      fresh,
      documents: phoneB,
      clock: clock,
    ).stageRestore(bytes);
    expect(made, DateTime.utc(2026, 10, 29, 9));
    await fresh.close();
    expect(Backup.applyPendingRestore(phoneB), isTrue);
    expect(Backup.applyPendingRestore(phoneB), isFalse, reason: 'once');

    final restored = open(phoneB);
    final after = {
      for (final t in restored.allTables)
        t.actualTableName:
            (await restored
                    .customSelect(
                      'SELECT COUNT(*) AS n FROM ${t.actualTableName}',
                    )
                    .getSingle())
                .read<int>('n'),
    };
    expect(after, before);
    final file = await restored.select(restored.sourceFiles).getSingle();
    expect(File(p.join(phoneB.path, file.localPath)).readAsBytesSync(), [
      37,
      80,
      68,
      70,
      1,
      2,
      3,
    ]);
    expect(
      (await restored.select(restored.exams).getSingle()).name,
      'JEE Main',
    );
    await restored.close();
  });

  test('a file that is not a backup, or one from a newer app, is refused', () {
    expect(
      () => Backup.stage(
        Uint8List.fromList([1, 2, 3]),
        documents: phoneB,
        currentSchema: 2,
      ),
      throwsA(
        isA<BackupError>().having(
          (e) => e.problem,
          'problem',
          BackupProblem.notABackup,
        ),
      ),
    );
    final newer = Archive()
      ..addFile(
        ArchiveFile.string(
          'manifest.json',
          '{"format":"prepbelt-backup","version":1,"schemaVersion":9,'
              '"createdAt":"2027-01-01T00:00:00Z"}',
        ),
      )
      ..addFile(ArchiveFile.bytes(Backup.dbName, [0]));
    expect(
      () => Backup.stage(
        Uint8List.fromList(ZipEncoder().encode(newer)),
        documents: phoneB,
        currentSchema: 2,
      ),
      throwsA(
        isA<BackupError>().having(
          (e) => e.problem,
          'problem',
          BackupProblem.tooNew,
        ),
      ),
    );
    expect(Backup.applyPendingRestore(phoneB), isFalse);
  });
}
