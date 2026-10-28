import 'dart:math';

import '../../core/config/defaults.dart';

/// Arithmetic of reading a source as you go (D27, D28, D30). Pure: the
/// repository and screens pass in units, chapters and sittings.

/// Units [start] to [end], both inclusive.
final class UnitRange {
  const UnitRange(this.start, this.end);

  final int start;
  final int end;

  int get size => max(0, end - start + 1);

  /// How many units the two ranges share.
  int overlap(UnitRange other) =>
      max(0, min(end, other.end) - max(start, other.start) + 1).toInt();

  @override
  bool operator ==(Object other) =>
      other is UnitRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'UnitRange($start, $end)';
}

/// One saved sitting: the units read and the minutes it took.
final class Sitting {
  const Sitting(this.range, this.minutes);

  final UnitRange range;
  final int minutes;
}

/// [ranges] merged into sorted, disjoint ranges. Touching ranges (1–5 and
/// 6–9) merge too.
List<UnitRange> unionOf(Iterable<UnitRange> ranges) {
  final sorted = [
    for (final r in ranges)
      if (r.size > 0) r,
  ]..sort((a, b) => a.start.compareTo(b.start));
  final out = <UnitRange>[];
  for (final r in sorted) {
    if (out.isNotEmpty && r.start <= out.last.end + 1) {
      if (out.last.end < r.end) out.last = UnitRange(out.last.start, r.end);
    } else {
      out.add(r);
    }
  }
  return out;
}

/// Units of [range] inside [union] (a result of [unionOf]).
int coveredUnits(List<UnitRange> union, UnitRange range) =>
    union.fold(0, (sum, u) => sum + u.overlap(range));

/// The first unit of [whole] not in [union], or null when all of it is.
int? firstUncovered(List<UnitRange> union, UnitRange whole) {
  var next = whole.start;
  for (final u in union) {
    if (u.end < next) continue;
    if (u.start > next) break;
    next = u.end + 1;
  }
  return next > whole.end ? null : next;
}

/// Minutes spent on [range], apportioned from each sitting by the share of
/// its units that fall inside [range].
double minutesOn(UnitRange range, Iterable<Sitting> sittings) => sittings.fold(
  0,
  (sum, s) => s.range.size == 0
      ? sum
      : sum + s.minutes * s.range.overlap(range) / s.range.size,
);

/// The guessed last unit read after [minutes] at [pace] minutes per unit,
/// starting at [start]; never past [last] or before [start].
int guessEndUnit({
  required int start,
  required int minutes,
  required double pace,
  required int last,
}) {
  if (pace <= 0) return start;
  final units = (minutes / pace).round();
  return (start + units - 1).clamp(start, max(start, last));
}

/// The pace for the guess (D30): the median minutes per unit of [recent]
/// sittings, blended with [defaultPace] while there are few of them.
double paceFrom(
  List<Sitting> recent, {
  required double defaultPace,
  int calibrateAfter = Defaults.paceCalibrationSessions,
  int fullyPersonalAfter = Defaults.paceFullyPersonalSessions,
  double blend = Defaults.paceBlendWeight,
}) {
  final rates = [
    for (final s in recent)
      if (s.range.size > 0 && s.minutes > 0) s.minutes / s.range.size,
  ]..sort();
  if (rates.length < calibrateAfter) return defaultPace;
  final mid = rates.length ~/ 2;
  final median = rates.length.isOdd
      ? rates[mid]
      : (rates[mid - 1] + rates[mid]) / 2;
  if (rates.length >= fullyPersonalAfter) return median;
  return blend * median + (1 - blend) * defaultPace;
}

/// What a chapter looks like to a save: its range, whether it has a task
/// and whether that task has its first read.
final class ChapterState {
  const ChapterState({
    required this.range,
    this.hasTask = false,
    this.read = false,
  });

  final UnitRange range;
  final bool hasTask;
  final bool read;
}

/// The outcome of saving a sitting, by chapter index.
final class SavePlan {
  const SavePlan({
    this.newTasks = const [],
    this.firstReads = const [],
    this.partial = const [],
  });

  /// Runs of consecutive finished chapters without a task; each run
  /// becomes one task.
  final List<List<int>> newTasks;

  /// Finished chapters whose task has no first read yet.
  final List<int> firstReads;

  /// Chapters the sitting touched but did not finish.
  final List<int> partial;

  bool get isEmpty => newTasks.isEmpty && firstReads.isEmpty && partial.isEmpty;
}

/// Plans a save of [sitting] over [chapters] (in reading order), given the
/// [explored] ranges before it.
SavePlan planSave({
  required List<ChapterState> chapters,
  required List<UnitRange> explored,
  required UnitRange sitting,
}) {
  final after = unionOf([...explored, sitting]);
  final runs = <List<int>>[];
  final reads = <int>[];
  final partial = <int>[];
  List<int>? run;
  for (var i = 0; i < chapters.length; i++) {
    final c = chapters[i];
    final touched = c.range.overlap(sitting) > 0;
    final finished = coveredUnits(after, c.range) >= c.range.size;
    if (touched && finished && !c.hasTask) {
      (run ??= []).add(i);
      continue;
    }
    if (run != null) runs.add(run);
    run = null;
    if (!touched || c.read) continue;
    if (!finished) {
      partial.add(i);
    } else if (c.hasTask) {
      reads.add(i);
    }
  }
  if (run != null) runs.add(run);
  return SavePlan(newTasks: runs, firstReads: reads, partial: partial);
}

/// A task title for consecutive chapters: the title itself for one,
/// "first – last" for more.
String taskTitleFor(List<String> titles) =>
    titles.length == 1 ? titles.single : '${titles.first} – ${titles.last}';
