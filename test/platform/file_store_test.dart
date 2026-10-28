import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/ids/ids.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/platform/files/file_store.dart';

void main() {
  late Directory tmp;
  late FileStore store;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('filestore');
    store = FileStore(
      root: Directory('${tmp.path}/docs'),
      ids: IdGenerator(FakeClock(DateTime.utc(2026, 10, 28))),
    );
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  test('copies into sources/<uuid>.pdf with size and SHA-256', () async {
    final src = File('${tmp.path}/Book.PDF')..writeAsStringSync('hello');
    final stored = await store.copyIn(src);
    expect(
      stored.relativePath,
      matches(RegExp(r'^sources/[0-9a-f-]{36}\.pdf$')),
    );
    expect(stored.bytes, 5);
    expect(
      stored.sha256,
      '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
    );
    expect(store.resolve(stored.relativePath).readAsStringSync(), 'hello');

    await store.remove(stored.relativePath);
    expect(store.resolve(stored.relativePath).existsSync(), isFalse);
  });

  test(
    'the same content hashes the same, so duplicates can be found',
    () async {
      final a = File('${tmp.path}/a.pdf')..writeAsStringSync('same');
      final b = File('${tmp.path}/b.pdf')..writeAsStringSync('same');
      expect(await store.hash(a), await store.hash(b));
    },
  );
}
