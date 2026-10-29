import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/features/session/data/session_repository.dart';

void main() {
  const source = Source(
    id: 's',
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    type: SourceType.pdf,
    title: 'Law notes',
    unitType: UnitType.page,
    totalUnits: 140,
    progressive: false,
  );
  const chunk = Chunk(
    id: 'c',
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    sourceId: 's',
    title: 'Ch 6',
    order: 5,
  );
  TaskChunk link({int? part, int? parts}) => TaskChunk(
    id: 'l',
    createdAt: 0,
    updatedAt: 0,
    hlc: '0',
    deviceId: 'd',
    taskId: 't',
    chunkId: 'c',
    order: 0,
    part: part,
    parts: parts,
  );

  test('a chapter without page numbers takes its source\'s minutes per '
      'chapter, shared among its parts (D49)', () {
    double estimate(TaskChunk l, {Map<String, double> per = const {}}) =>
        SessionRepository.estimateFirstRead(
          [(chunk: chunk, source: source, link: l)],
          const {},
          chapterMinutes: per,
        );
    expect(estimate(link(), per: {'s': 40}), 40);
    expect(estimate(link(part: 1, parts: 4), per: {'s': 40}), 10);
    expect(estimate(link()), 45, reason: 'the default without a calibration');
  });
}
