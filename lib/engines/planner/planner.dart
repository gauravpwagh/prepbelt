import 'dart:math';

import '../../core/config/defaults.dart';
import '../review/review_engine.dart';
import '../review/review_types.dart';

/// How much a task matters for the exam. Mirrors `Importance` without the
/// database layer.
enum PlanImportance { high, medium, low }

/// What a plan item is for. Mirrors `PlanItemKind`.
enum PlanKind { firstRead, review, finalReview, explore }

/// Tunable numbers of the planner (docs/04-planner-spec.md, "Configuration
/// defaults").
final class PlannerConfig {
  const PlannerConfig({
    this.maxSession = Defaults.maxReadingSessionMinutes,
    this.sessionFloor = Defaults.newSessionFloorMinutes,
    this.maxOverrun = Defaults.maxDayOverrunMinutes,
    this.taperDays = Defaults.taperDays,
    this.smoothEarlier = Defaults.smoothingDaysEarlier,
    this.maxFirstReadsPerSubject = Defaults.maxFirstReadsPerSubjectPerDay,
    this.finalWindows = const [
      Defaults.finalWindowHigh,
      Defaults.finalWindowMedium,
      Defaults.finalWindowLow,
    ],
  });

  final int maxSession;
  final int sessionFloor;
  final int maxOverrun;
  final int taperDays;

  /// A review may be pulled this many days early onto a day with room.
  final int smoothEarlier;
  final int maxFirstReadsPerSubject;

  /// Days before the exam a final review may land in, `[near, far]`, for
  /// High, Medium and Low (docs/04-planner-spec.md).
  final List<List<int>> finalWindows;
}

/// One task as the planner sees it.
final class PlanTask {
  const PlanTask({
    required this.id,
    required this.state,
    required this.importance,
    required this.planned,
    required this.firstReadMinutes,
    required this.reviewMinutes,
    this.remainingReadMinutes,
    this.difficulty = 2,
    this.subject = '',
    this.sourceKey = '',
    this.sourceOrder = 0,
    this.startedReading = false,
    this.keep = false,
    this.reviewLimit,
  });

  final String id;

  /// The review engine's state (level, step, dim, due date).
  final ReviewState state;
  final PlanImportance importance;

  /// Scheduled reviews for this task (its belt target sets it).
  final int planned;

  /// The whole first read's estimate.
  final double firstReadMinutes;

  /// What is left of the first read (less after a partial session).
  final double? remainingReadMinutes;

  /// Length of review [step] (0 = first review).
  final int Function(int step) reviewMinutes;

  /// 1 Easy .. 3 Hard.
  final int difficulty;

  /// For variety: at most a few first reads of one subject a day.
  final String subject;

  /// Source order: a chapter is never read before an earlier unread one of
  /// the same source.
  final String sourceKey;
  final int sourceOrder;

  /// A first read already in progress continues before new ones.
  final bool startedReading;

  /// The student chose to keep this task in full: triage never cuts it.
  final bool keep;

  /// Triage: stop after this many scheduled reviews. The reviews keep the
  /// dates they had for [planned]; the last ones are simply dropped, so a
  /// cut frees the crowded days before the exam.
  final int? reviewLimit;

  /// Scheduled reviews this plan will hold.
  int get reviews => reviewLimit ?? planned;

  PlanTask copyWith({
    int? planned,
    double? firstReadMinutes,
    int? reviewLimit,
  }) => PlanTask(
    id: id,
    state: state,
    importance: importance,
    planned: planned ?? this.planned,
    firstReadMinutes: firstReadMinutes ?? this.firstReadMinutes,
    remainingReadMinutes: firstReadMinutes == null
        ? remainingReadMinutes
        : null,
    reviewMinutes: reviewMinutes,
    difficulty: difficulty,
    subject: subject,
    sourceKey: sourceKey,
    sourceOrder: sourceOrder,
    startedReading: startedReading,
    keep: keep,
    reviewLimit: reviewLimit ?? this.reviewLimit,
  );

  bool get started => state.started;
  double get toRead => remainingReadMinutes ?? firstReadMinutes;
}

/// A source's unexplored part (D27): read like a Medium first read, after
/// the source's own unread tasks, with no reviews.
final class PlanExplore {
  const PlanExplore({
    required this.sourceId,
    required this.minutes,
    this.subject = '',
  });

  final String sourceId;
  final double minutes;
  final String subject;
}

/// What the planner needs. Days are local calendar dates as UTC midnights
/// (see [dayKey]); the planner never reads the clock.
final class PlannerInput {
  const PlannerInput({
    required this.today,
    required this.examDay,
    required this.weekdayMinutes,
    required this.tasks,
    this.overrides = const {},
    this.explores = const [],
    this.config = const PlannerConfig(),
  });

  final DateTime today;
  final DateTime examDay;

  /// Minutes per weekday, Monday first.
  final List<int> weekdayMinutes;

  /// Minutes for specific days (breaks, mock tests).
  final Map<DateTime, int> overrides;
  final List<PlanTask> tasks;
  final List<PlanExplore> explores;
  final PlannerConfig config;

  PlannerInput copyWith({List<PlanTask>? tasks, int extraMinutes = 0}) =>
      PlannerInput(
        today: today,
        examDay: examDay,
        weekdayMinutes: [for (final m in weekdayMinutes) m + extraMinutes],
        overrides: {
          for (final MapEntry(:key, :value) in overrides.entries)
            // A break stays a break; reduced days get the extra too.
            key: value == 0 && key != today ? 0 : value + extraMinutes,
        },
        tasks: tasks ?? this.tasks,
        explores: explores,
        config: config,
      );
}

/// One planned session.
final class PlanEntry {
  const PlanEntry({
    required this.day,
    required this.kind,
    required this.minutes,
    required this.order,
    this.taskId,
    this.sourceId,
  });

  final DateTime day;
  final PlanKind kind;
  final int minutes;

  /// Position within the day.
  final int order;
  final String? taskId;
  final String? sourceId;

  @override
  String toString() =>
      '${day.toIso8601String().substring(0, 10)} #$order ${kind.name} '
      '${taskId ?? sourceId} ${minutes}m';
}

/// The plan, and what it predicts.
final class PlanResult {
  const PlanResult({
    required this.entries,
    required this.projectedLevel,
    required this.late,
    required this.unplacedMinutes,
  });

  final List<PlanEntry> entries;

  /// Each task's belt by exam day if the plan is followed with Good
  /// reviews.
  final Map<String, int> projectedLevel;

  /// High tasks whose first read cannot finish by their deadline: triage
  /// cases (docs/04-planner-spec.md, "Triage").
  final List<String> late;

  /// Work that did not fit before the exam.
  final int unplacedMinutes;

  bool get fits => late.isEmpty && unplacedMinutes == 0;

  List<PlanEntry> on(DateTime day) => [
    for (final e in entries)
      if (e.day == day) e,
  ];
}

/// The local calendar day of [t], as a UTC midnight.
DateTime dayKey(DateTime t) => DateTime.utc(t.year, t.month, t.day);

final class _Review {
  _Review(this.task, this.state, this.due, this.step);

  final PlanTask task;
  final ReviewState state;
  final DateTime due;

  /// Scheduled step this review would complete (0-based).
  final int step;
}

final class _Reading {
  _Reading.task(PlanTask t)
    : task = t,
      explore = null,
      left = t.toRead,
      started = t.startedReading;
  _Reading.explore(PlanExplore e)
    : task = null,
      explore = e,
      left = e.minutes,
      started = false;

  final PlanTask? task;
  final PlanExplore? explore;
  double left;
  bool started;
  DateTime? deadline;

  String get id => task?.id ?? 'explore:${explore!.sourceId}';
  String get subject => task?.subject ?? explore!.subject;
  int get importanceRank => task?.importance.index ?? 1;
}

/// Plans every day from [PlannerInput.today] to the day before the exam
/// (docs/04-planner-spec.md, "Filling each day"):
///
/// - overdue reviews first, then reviews due that day, by importance, then
///   dimmest; what does not fit carries to the next day;
/// - a review due within [PlannerConfig.smoothEarlier] days is pulled onto
///   a day with room left once first reads are placed, when its own day is
///   already over its minutes (a break, a mock test, a pile-up);
/// - first reads in sessions of at most [PlannerConfig.maxSession]
///   minutes, one a day per task, never starting below the 15-minute
///   floor, earliest deadline first, then importance, Hard first, source
///   order, and at most 2 per subject a day when there is an alternative;
/// - the last [PlannerConfig.taperDays] days hold reviews only; the exam
///   day is empty;
/// - a task's reviews follow from the day its first read finishes, as the
///   review engine fits them before the exam.
///
/// Ties break by id, so the same input always gives the same plan.
PlanResult plan(PlannerInput input, ReviewEngine engine) {
  final cfg = input.config;
  final today = dayKey(input.today);
  final exam = dayKey(input.examDay);
  final deadline = exam.subtract(
    Duration(days: engine.config.lastReviewDaysBeforeExam - 1),
  );
  final lastDay = exam.subtract(const Duration(days: 1));
  final taperFrom = exam.subtract(Duration(days: cfg.taperDays));

  final entries = <PlanEntry>[];
  final projected = <String, int>{};
  final pending = <_Review>[];
  final readings = <_Reading>[];

  // A review capped at the deadline (exam day's start) is done the day
  // before.
  DateTime onOrBefore(DateTime d) => d.isAfter(lastDay) ? lastDay : d;

  bool finalStep(PlanTask t, ReviewState s) =>
      s.step + 1 >= t.reviews && s.dim == 0;

  /// The final review's window as days: (earliest, latest).
  (DateTime, DateTime) window(PlanTask t) {
    final w = cfg.finalWindows[t.importance.index];
    return (
      exam.subtract(Duration(days: w[1])),
      exam.subtract(Duration(days: w[0])),
    );
  }

  // Final-review minutes already given to each day, to spread them out.
  final finalLoad = <DateTime, int>{};

  /// Queues a review due on [due]. A final review goes to the least
  /// loaded day of its window (relative to that day's minutes), latest
  /// first on ties, so finals spread over the last days instead of piling
  /// up on the day before the exam.
  void queue(PlanTask t, ReviewState s, DateTime due, int step) {
    // Past its review limit (a triage cut), a task has nothing more due.
    if (s.dim == 0 && step >= t.reviews) return;
    var d = onOrBefore(due);
    if (finalStep(t, s)) {
      final (earliest, latest) = window(t);
      if (d.isAfter(latest)) d = latest;
      final from = earliest.isBefore(today) ? today : earliest;
      final minutes = t.reviewMinutes(s.step);
      var best = d;
      var bestLoad = double.infinity;
      for (
        var day = d;
        !day.isBefore(from);
        day = day.subtract(const Duration(days: 1))
      ) {
        final cap =
            input.overrides[day] ?? input.weekdayMinutes[day.weekday - 1];
        if (cap <= 0) continue;
        final load = ((finalLoad[day] ?? 0) + minutes) / cap;
        if (load < bestLoad) {
          best = day;
          bestLoad = load;
        }
      }
      d = best;
      finalLoad[d] = (finalLoad[d] ?? 0) + minutes;
    }
    pending.add(_Review(t, s, d, step));
  }

  for (final t in input.tasks) {
    if (t.state.paused) continue;
    projected[t.id] = t.state.level;
    if (t.started) {
      final due = t.state.dueAt;
      if (due != null) queue(t, t.state, dayKey(due), t.state.step);
    } else {
      readings.add(_Reading.task(t)..deadline = _readDeadline(t, exam, engine));
    }
  }
  for (final e in input.explores) {
    if (e.minutes > 0) readings.add(_Reading.explore(e)..deadline = taperFrom);
  }

  int capacity(DateTime day) =>
      input.overrides[day] ?? input.weekdayMinutes[day.weekday - 1];

  int reviewRank(_Review a, _Review b) {
    final byDue = a.due.compareTo(b.due);
    if (byDue != 0) return byDue;
    final byImportance = a.task.importance.index.compareTo(
      b.task.importance.index,
    );
    if (byImportance != 0) return byImportance;
    final byDim = b.state.dim.compareTo(a.state.dim);
    if (byDim != 0) return byDim;
    return a.task.id.compareTo(b.task.id);
  }

  bool isFinal(_Review r) => finalStep(r.task, r.state);

  /// Places [r] on [day] and queues the next one, as if rated Good.
  void placeReview(_Review r, DateTime day, int order) {
    entries.add(
      PlanEntry(
        day: day,
        kind: isFinal(r) ? PlanKind.finalReview : PlanKind.review,
        minutes: r.task.reviewMinutes(r.step),
        order: order,
        taskId: r.task.id,
      ),
    );
    final out = engine.applyReview(
      r.state,
      Rating.good,
      day,
      deadline: deadline,
      planned: r.task.planned,
    );
    projected[r.task.id] = out.levelAfter;
    final next = out.dueAfter;
    if (next != null) {
      queue(r.task, out.state, dayKey(next), out.state.step);
    }
  }

  /// Source order: the earliest unfinished reading of a source goes first.
  bool eligible(_Reading r, List<_Reading> open) {
    final t = r.task;
    if (t == null) {
      // An explore item waits for the source's own unread tasks.
      return !open.any(
        (o) => o.task != null && o.task!.sourceKey == r.explore!.sourceId,
      );
    }
    if (t.sourceKey.isEmpty) return true;
    return !open.any(
      (o) =>
          o.task != null &&
          o != r &&
          o.task!.sourceKey == t.sourceKey &&
          o.task!.sourceOrder < t.sourceOrder,
    );
  }

  int readingRank(_Reading a, _Reading b) {
    if (a.started != b.started) return a.started ? -1 : 1;
    final byDeadline = a.deadline!.compareTo(b.deadline!);
    if (byDeadline != 0) return byDeadline;
    final byImportance = a.importanceRank.compareTo(b.importanceRank);
    if (byImportance != 0) return byImportance;
    final byDifficulty = (b.task?.difficulty ?? 2).compareTo(
      a.task?.difficulty ?? 2,
    );
    if (byDifficulty != 0) return byDifficulty;
    final byOrder = (a.task?.sourceOrder ?? 1 << 30).compareTo(
      b.task?.sourceOrder ?? 1 << 30,
    );
    if (byOrder != 0) return byOrder;
    return a.id.compareTo(b.id);
  }

  final late = <String>{};
  for (
    var day = today;
    !day.isAfter(lastDay);
    day = day.add(const Duration(days: 1))
  ) {
    final cap = capacity(day);
    var used = 0;
    var order = 0;

    // 1. Reviews due by today (overdue first), until the day is full.
    pending.sort(reviewRank);
    final dueNow = [
      for (final r in pending)
        if (!r.due.isAfter(day)) r,
    ];
    for (final r in dueNow) {
      final m = r.task.reviewMinutes(r.step);
      if (used > 0 && used + m > cap + cfg.maxOverrun) break;
      if (cap == 0) break;
      pending.remove(r);
      placeReview(r, day, order++);
      used += m;
    }

    // 2. First reads, one session a day per task, outside the taper.
    if (day.isBefore(taperFrom)) {
      final bySubject = <String, int>{};
      final readToday = <String>{};
      while (true) {
        final left = cap - used;
        final open = [
          for (final r in readings)
            if (r.left > 0.5) r,
        ];
        final candidates = [
          for (final r in open)
            if (!readToday.contains(r.id) &&
                eligible(r, open) &&
                (r.started ? left > 0 : left >= cfg.sessionFloor))
              r,
        ]..sort(readingRank);
        if (candidates.isEmpty) break;
        final varied = candidates.where(
          (r) =>
              r.subject.isEmpty ||
              (bySubject[r.subject] ?? 0) < cfg.maxFirstReadsPerSubject,
        );
        final pick = varied.isNotEmpty ? varied.first : candidates.first;
        final whole = min(pick.left, cfg.maxSession.toDouble());
        final session = whole <= left + cfg.maxOverrun ? whole.round() : left;
        if (session <= 0) break;
        entries.add(
          PlanEntry(
            day: day,
            kind: pick.task == null ? PlanKind.explore : PlanKind.firstRead,
            minutes: session,
            order: order++,
            taskId: pick.task?.id,
            sourceId: pick.explore?.sourceId,
          ),
        );
        used += session;
        pick
          ..left = max(0, pick.left - session)
          ..started = true;
        readToday.add(pick.id);
        bySubject[pick.subject] = (bySubject[pick.subject] ?? 0) + 1;

        final t = pick.task;
        if (t != null && pick.left <= 0.5) {
          if (day.isAfter(pick.deadline!) &&
              t.importance == PlanImportance.high) {
            late.add(t.id);
          }
          // The first read earns White; its reviews follow from today.
          final out = engine.applyReview(
            t.state,
            Rating.good,
            day,
            deadline: deadline,
            planned: t.planned,
          );
          projected[t.id] = out.levelAfter;
          final next = out.dueAfter;
          if (next != null) {
            queue(t, out.state, dayKey(next), 0);
          }
        }
      }
    }

    // 3. Smoothing: a review due within a couple of days moves onto today
    // when its own day is already over its minutes (or is a break), or
    // when everything still due before the exam is more than the days
    // left can hold (the final stretch fills up).
    int dueLoad(DateTime d) => pending
        .where((r) => r.due == d)
        .fold(0, (sum, r) => sum + r.task.reviewMinutes(r.step));
    // Everything still to place counts, including reviews carried over
    // from today: they will use the days ahead too.
    var tailLoad = pending.fold(
      0,
      (sum, r) => sum + r.task.reviewMinutes(r.step),
    );
    var tailCap = 0;
    for (
      var d = day.add(const Duration(days: 1));
      !d.isAfter(lastDay);
      d = d.add(const Duration(days: 1))
    ) {
      tailCap += capacity(d);
    }
    final soon = [
      for (final r in pending)
        if (r.due.isAfter(day) &&
            (isFinal(r)
                // A final review may move anywhere in its window.
                ? !day.isBefore(window(r.task).$1)
                : !r.due.isAfter(day.add(Duration(days: cfg.smoothEarlier)))))
          r,
    ]..sort(reviewRank);
    for (final r in soon) {
      final m = r.task.reviewMinutes(r.step);
      if (used + m > cap) continue;
      if (dueLoad(r.due) <= capacity(r.due) && tailLoad <= tailCap) continue;
      pending.remove(r);
      placeReview(r, day, order++);
      used += m;
      tailLoad -= m;
    }
  }

  // Order within each day: overdue and due reviews, final reviews, then
  // first reads and explore by importance (docs/04-planner-spec.md).
  final importance = {for (final t in input.tasks) t.id: t.importance.index};
  int kindRank(PlanKind k) => switch (k) {
    PlanKind.review => 0,
    PlanKind.finalReview => 1,
    PlanKind.firstRead => 2,
    PlanKind.explore => 3,
  };
  final sorted = [...entries]
    ..sort((a, b) {
      final byDay = a.day.compareTo(b.day);
      if (byDay != 0) return byDay;
      final byKind = kindRank(a.kind).compareTo(kindRank(b.kind));
      if (byKind != 0) return byKind;
      if (a.kind == PlanKind.firstRead) {
        final byImportance = (importance[a.taskId] ?? 1).compareTo(
          importance[b.taskId] ?? 1,
        );
        if (byImportance != 0) return byImportance;
      }
      return a.order.compareTo(b.order);
    });
  final out = <PlanEntry>[];
  DateTime? current;
  var n = 0;
  for (final e in sorted) {
    if (e.day != current) {
      current = e.day;
      n = 0;
    }
    out.add(
      PlanEntry(
        day: e.day,
        kind: e.kind,
        minutes: e.minutes,
        order: n++,
        taskId: e.taskId,
        sourceId: e.sourceId,
      ),
    );
  }

  var unplaced = 0;
  for (final r in readings) {
    if (r.left > 0.5) {
      unplaced += r.left.round();
      if (r.task?.importance == PlanImportance.high) late.add(r.task!.id);
    }
  }
  for (final r in pending) {
    if (!r.due.isAfter(lastDay)) unplaced += r.task.reviewMinutes(r.step);
  }

  return PlanResult(
    entries: out,
    projectedLevel: projected,
    late: late.toList()..sort(),
    unplacedMinutes: unplaced,
  );
}

/// The latest day a first read can finish and still leave room for all of
/// the task's planned reviews before the taper: the reviews need at least
/// the sum of the first [PlanTask.planned] gap weights in days (the
/// shortest chain the review engine fits, one day per weight unit).
DateTime _readDeadline(PlanTask t, DateTime exam, ReviewEngine engine) {
  final w = engine.config.gapWeights;
  var need = 0;
  for (var i = 0; i < t.planned; i++) {
    need += w[min(i, w.length - 1)];
  }
  return exam.subtract(Duration(days: need));
}
