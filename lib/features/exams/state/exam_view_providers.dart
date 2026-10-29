import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../engines/exam/exam_metrics.dart';
import '../../../engines/planner/planner.dart';
import '../../planner/data/planner_repository.dart' show dateText;
import '../../planner/state/planner_providers.dart';
import '../../settings/state/settings_providers.dart';
import '../../sources/data/task_writer.dart';
import '../data/exam_view_repository.dart';
import 'exam_providers.dart';

export '../../../engines/exam/exam_metrics.dart' show ExamMetrics;
export '../../../engines/planner/triage.dart' show TriageStep;

part 'exam_view_providers.g.dart';

@Riverpod(keepAlive: true)
ExamViewRepository examViewRepository(Ref ref) =>
    ExamViewRepository(ref.watch(appDatabaseProvider));

/// A High task below Yellow, with what comes next for it.
final class WeakLink {
  const WeakLink({
    required this.taskId,
    required this.title,
    required this.level,
    this.next,
  });

  final String taskId;
  final String title;
  final int level;

  /// Its next planned session, if any.
  final PlanItem? next;
}

/// One day of the activity grid.
typedef ActivityDay = ({DateTime day, int minutes, int bucket});

/// A task the plan cut, or the student dropped.
typedef PlanCut = ({TriageStep? step, String taskId, String title});

/// A task the student could drop at triage step 5.
typedef Droppable = ({String taskId, String title, Importance importance});

/// What triage did to fit the plan (docs/04-planner-spec.md, "Triage").
final class TriageView {
  const TriageView({
    this.cuts = const [],
    this.dropped = const [],
    this.droppable = const [],
    this.needsStudent = false,
    this.extraForReduced,
    this.extraForFull,
    this.accepted = false,
  });

  /// Automatic cuts, in step order.
  final List<PlanCut> cuts;

  /// Tasks the student dropped (step 5); each can be restored.
  final List<PlanCut> dropped;

  /// Medium and High tasks the student could drop.
  final List<Droppable> droppable;
  final bool needsStudent;
  final int? extraForReduced;
  final int? extraForFull;

  /// The student accepted the reduced plan.
  final bool accepted;

  bool get isEmpty => cuts.isEmpty && dropped.isEmpty && !needsStudent;
}

/// Everything the Exam screen shows.
final class ExamView {
  const ExamView({
    required this.exam,
    required this.today,
    required this.metrics,
    required this.todayMinutes,
    required this.weakLinks,
    required this.activity,
    this.planFits = true,
    this.triage = const TriageView(),
  });

  final Exam exam;

  /// Local calendar day.
  final DateTime today;
  final ExamMetrics metrics;

  /// Planned minutes still to do today.
  final int todayMinutes;
  final List<WeakLink> weakLinks;

  /// The last [Defaults.activityGridWeeks] weeks, Monday first, oldest
  /// first, through today.
  final List<ActivityDay> activity;

  /// False when the plan cannot fit everything, even after triage.
  final bool planFits;
  final TriageView triage;

  int get daysLeft =>
      dayKey(DateTime.parse(exam.date)).difference(dayKey(today)).inDays;
}

/// The Exam screen for [examId], or the upcoming exam when null. Null when
/// there is no such exam.
@riverpod
Stream<ExamView?> examView(Ref ref, String? examId) async* {
  final clock = ref.watch(clockProvider);
  final repo = ref.watch(examViewRepositoryProvider);
  final Exam? exam = examId == null
      ? await ref.watch(currentExamProvider.future)
      : await repo.watchExam(examId).first;
  if (exam == null) {
    yield null;
    return;
  }
  final plan = await ref.watch(plannerProvider.future);
  final settings = await ref.watch(settingsProvider.future);
  final accepted = settings[SettingKeys.triageAccepted] == exam.id;
  final now = clock.now().toLocal();
  final today = dayKey(now);
  const weeks = Defaults.activityGridWeeks;
  // Start on the Monday [weeks - 1] weeks before this week's Monday.
  final firstDay = today.subtract(
    Duration(days: today.weekday - 1 + 7 * (weeks - 1)),
  );
  final fromMs = DateTime(
    firstDay.year,
    firstDay.month,
    firstDay.day,
  ).toUtc().millisecondsSinceEpoch;

  final tasks = repo.watchTasks(exam.id);
  final study = repo.watchStudy(fromMs);
  final planned = repo.watchPlanFrom(dateText(today));

  // Combine the three streams: re-emit when any changes.
  List<ExamTaskRow>? t;
  List<(int, int)>? s;
  List<PlanItem>? p;
  ExamView? build() {
    if (t == null || s == null || p == null) return null;
    final active = [
      for (final r in t!)
        if (!r.link.dropped) r,
    ];
    final metrics = examMetrics([
      for (final r in active)
        ExamTaskLevel(
          id: r.task.id,
          importance: PlanImportance.values[r.link.importance.index],
          target: r.link.targetLevel,
          level: r.state.level,
          projected: plan?.plan.projectedLevel[r.task.id] ?? r.state.level,
        ),
    ]);
    final titles = {for (final r in t!) r.task.id: r.task.title};
    final levels = {for (final r in t!) r.task.id: r.state.level};
    final minutesByDay = <DateTime, int>{};
    for (final (at, sec) in s!) {
      final d = dayKey(fromUtcMs(at).toLocal());
      minutesByDay[d] = (minutesByDay[d] ?? 0) + (sec / 60).round();
    }
    const full = Defaults.defaultDailyMinutes;
    return ExamView(
      exam: exam,
      today: now,
      metrics: metrics,
      planFits: plan?.fits ?? true,
      triage: TriageView(
        cuts: [
          for (final c in plan?.cuts ?? const <TriageCut>[])
            if (titles[c.taskId] != null)
              (step: c.step, taskId: c.taskId, title: titles[c.taskId]!),
        ],
        dropped: [
          for (final r in t!)
            if (r.link.dropped)
              (step: null, taskId: r.task.id, title: r.task.title),
        ],
        droppable: [
          for (final r in active)
            if (r.link.importance != Importance.low)
              (
                taskId: r.task.id,
                title: r.task.title,
                importance: r.link.importance,
              ),
        ],
        needsStudent: plan?.needsStudent ?? false,
        extraForReduced: plan?.extraForReduced,
        extraForFull: plan?.extraForFull,
        accepted: accepted,
      ),
      todayMinutes: p!
          .where((i) => i.date == dateText(today))
          .fold(0, (sum, i) => sum + i.estMinutes),
      weakLinks: [
        for (final id in metrics.weakLinks)
          WeakLink(
            taskId: id,
            title: titles[id]!,
            level: levels[id]!,
            next: p!.where((i) => i.taskId == id).firstOrNull,
          ),
      ],
      activity: [
        for (var i = 0; i < weeks * 7; i++)
          if (!firstDay.add(Duration(days: i)).isAfter(today))
            (
              day: firstDay.add(Duration(days: i)),
              minutes: minutesByDay[firstDay.add(Duration(days: i))] ?? 0,
              bucket: activityBucket(
                minutesByDay[firstDay.add(Duration(days: i))] ?? 0,
                full: full,
              ),
            ),
      ],
    );
  }

  yield* _merge3(
    tasks,
    study,
    planned,
    onA: (v) => t = v,
    onB: (v) => s = v,
    onC: (v) => p = v,
    build: build,
  );
}

Stream<T> _merge3<A, B, C, T>(
  Stream<A> a,
  Stream<B> b,
  Stream<C> c, {
  required void Function(A) onA,
  required void Function(B) onB,
  required void Function(C) onC,
  required T? Function() build,
}) async* {
  final events = StreamGroupLite<Object?>([
    a.map(
      (v) =>
          () => onA(v),
    ),
    b.map(
      (v) =>
          () => onB(v),
    ),
    c.map(
      (v) =>
          () => onC(v),
    ),
  ]);
  await for (final apply in events.stream) {
    (apply! as void Function())();
    final v = build();
    if (v != null) yield v;
  }
}

/// Merges streams into one (a minimal stand-in for package:async's
/// StreamGroup).
final class StreamGroupLite<T> {
  StreamGroupLite(List<Stream<T>> streams) {
    var open = streams.length;
    for (final s in streams) {
      final sub = s.listen(
        _controller.add,
        onError: _controller.addError,
        onDone: () {
          if (--open == 0) unawaited(_controller.close());
        },
      );
      _subs.add(sub);
    }
    _controller.onCancel = () async {
      for (final sub in _subs) {
        await sub.cancel();
      }
    };
  }

  final _controller = StreamController<T>();
  final _subs = <StreamSubscription<T>>[];

  Stream<T> get stream => _controller.stream;
}

/// Adds an exam with its task links and daily minutes (D38).
@Riverpod(keepAlive: true)
class ExamActions extends _$ExamActions {
  @override
  void build() {}

  Future<Exam> add({
    required String name,
    required DateTime date,
    required int dailyMinutes,
  }) async {
    final exam = await ref
        .read(examRepositoryProvider)
        .createWithSetup(
          name: name.trim(),
          date: dateText(dayKey(date)),
          dailyMinutes: dailyMinutes,
          mediumTarget: TaskWriter.targetLevelFor(Importance.medium),
        );
    await ref.read(plannerProvider.notifier).replanNow();
    return exam;
  }

  Future<int> taskCount() => ref.read(examRepositoryProvider).activeTaskCount();

  /// What keeping [taskId] in full would cut instead: the cuts that are
  /// new compared with now. Nothing is written.
  Future<List<TriageCut>> previewKeep(String taskId) async {
    final now = await ref.read(plannerProvider.future);
    final next = await ref.read(plannerRepositoryProvider).previewKeep(taskId);
    final before = {...?now?.cuts};
    return [
      for (final c in next?.cuts ?? const <TriageCut>[])
        if (!before.contains(c)) c,
    ];
  }

  Future<void> keep(String examId, String taskId) async {
    await ref
        .read(examRepositoryProvider)
        .setTriage(examId, taskId, keep: true);
    await ref.read(plannerProvider.notifier).replanNow();
  }

  Future<void> restore(String examId, String taskId) async {
    await ref
        .read(examRepositoryProvider)
        .setTriage(examId, taskId, dropped: false);
    await ref.read(plannerProvider.notifier).replanNow();
  }

  Future<void> drop(String examId, List<String> taskIds) async {
    await ref.read(examRepositoryProvider).dropTasks(examId, taskIds);
    await ref.read(plannerProvider.notifier).replanNow();
  }

  Future<void> addMinutes(String examId, int extra) async {
    await ref.read(examRepositoryProvider).addDailyMinutes(examId, extra);
    await ref.read(plannerProvider.notifier).replanNow();
  }

  Future<void> acceptReduced(String examId) => ref
      .read(settingsRepositoryProvider)
      .set(SettingKeys.triageAccepted, examId);
}
