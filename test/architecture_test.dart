import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/check_imports.dart';

void main() {
  test('lib/ follows the import rules of CLAUDE.md', () {
    expect(checkImports(Directory('lib')), isEmpty);
  });

  test('the checker catches each kind of violation', () {
    final tmp = Directory.systemTemp.createTempSync('imports');
    addTearDown(() => tmp.deleteSync(recursive: true));
    void write(String rel, String content) => File('${tmp.path}/$rel')
      ..createSync(recursive: true)
      ..writeAsStringSync(content);

    write('engines/planner/a.dart', "import 'package:flutter/material.dart';");
    write('engines/exam/b.dart', "import 'package:drift/drift.dart';");
    write('engines/exam/c.dart', "import '../../core/db/app_database.dart';");
    write(
      'engines/review/ok.dart',
      "import 'package:fsrs/fsrs.dart';\nimport '../../core/time/clock.dart';",
    );
    write('features/tasks/data/d.dart', "import 'package:fsrs/fsrs.dart';");
    write(
      'features/today/ui/e.dart',
      "import '../../tasks/data/task_repository.dart';",
    );
    write('app/f.dart', 'final t = DateTime.now();');

    final found = checkImports(tmp);
    expect(found, hasLength(6), reason: found.join('\n'));
    expect(found.where((v) => v.startsWith('engines/review/')), isEmpty);
  });
}
