import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/config/reading_config.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../engines/reading/reading_math.dart';
import '../../../platform/open_external/source_opener.dart';
import '../../exams/state/exam_providers.dart';
import '../../settings/state/settings_providers.dart';
import '../../survey/state/survey_providers.dart';
import '../../tasks/state/task_providers.dart';
import '../data/reading_repository.dart';
import 'source_providers.dart';

export '../../../core/config/reading_config.dart' show ReadingConfig;
export '../../../engines/reading/reading_math.dart'
    show SavePlan, UnitRange, taskTitleFor;
export '../data/reading_repository.dart'
    show ChapterProgress, SaveOutcome, SourceProgress;

part 'reading_providers.g.dart';

@Riverpod(keepAlive: true)
ReadingRepository readingRepository(Ref ref) => ReadingRepository(
  ref.watch(writeContextProvider),
  reviews: ref.watch(reviewRepositoryProvider),
);

@Riverpod(keepAlive: true)
SourceOpener sourceOpener(Ref ref) => const SystemSourceOpener();

@riverpod
Future<ReadingConfig> readingConfig(Ref ref) async =>
    ReadingConfig.fromSettings(await ref.watch(settingsProvider.future));

/// Default minutes per unit (docs/04-planner-spec.md).
double defaultPaceFor(UnitType unit) => switch (unit) {
  UnitType.page => Defaults.pacePageMin,
  UnitType.minute => Defaults.paceVideoMinuteMin,
  UnitType.question => Defaults.paceQuestionMin,
  UnitType.item => Defaults.paceItemMin,
};

/// Everything the Source chapters screen shows.
final class SourceChaptersView {
  const SourceChaptersView({
    required this.progress,
    required this.pace,
    this.examId,
    this.examName,
  });

  final SourceProgress progress;

  /// Minutes per unit for estimates.
  final double pace;
  final String? examId;
  final String? examName;

  Source get source => progress.source;
  List<ChapterProgress> get chapters => progress.chapters;

  /// Minutes to read what is left, rounded to 5; null without units.
  int? get minutesLeft => progress.readable
      ? (((progress.totalUnits - progress.exploredUnits) * pace) / 5).round() *
            5
      : null;

  /// Minutes of all saved sittings.
  int get minutesRead =>
      progress.sittings.fold(0, (sum, s) => sum + (s.minutes ?? 0));
}

@riverpod
Stream<SourceChaptersView?> sourceChapters(Ref ref, String sourceId) async* {
  final exam = await ref.watch(currentExamProvider.future);
  final repo = ref.watch(readingRepositoryProvider);
  yield* repo.watchProgress(sourceId, examId: exam?.id).asyncMap((p) async {
    if (p == null) return null;
    final unit = p.source.unitType;
    return SourceChaptersView(
      progress: p,
      pace: await repo.pace(unit, defaultPace: defaultPaceFor(unit)),
      examId: exam?.id,
      examName: exam?.name,
    );
  });
}

/// The open sitting, as the "How far did you get?" sheet needs it.
final class OpenReading {
  const OpenReading({
    required this.sessionId,
    required this.progress,
    required this.startUnit,
    required this.awayMinutes,
    required this.pace,
    required this.config,
    this.examId,
  });

  final String sessionId;
  final SourceProgress progress;
  final int startUnit;

  /// Time since the sitting started, as the sheet pre-fills it.
  final int awayMinutes;
  final double pace;
  final ReadingConfig config;
  final String? examId;

  Source get source => progress.source;

  /// The last unit the student can say they reached.
  int get lastUnit => progress.readable ? progress.totalUnits : startUnit;

  int guessFor(int minutes) => guessEndUnit(
    start: startUnit,
    minutes: minutes,
    pace: pace,
    last: lastUnit,
  );

  /// Chapter ends near [unit], for the chips.
  List<ChapterProgress> chapterEndsNear(int unit) => [
    for (final c in progress.chapters)
      if (c.chunk.endUnit case final end?)
        if (end >= startUnit && (end - unit).abs() <= config.chapterChipWindow)
          c,
  ];
}

/// The open sitting of any source, or null.
@riverpod
Stream<OpenReading?> openReading(Ref ref) async* {
  final exam = await ref.watch(currentExamProvider.future);
  final config = await ref.watch(readingConfigProvider.future);
  final repo = ref.watch(readingRepositoryProvider);
  final clock = ref.watch(clockProvider);
  yield* repo.watchOpenSession().asyncMap((s) async {
    if (s == null) return null;
    final p = await repo.progress(s.sourceId, examId: exam?.id);
    if (p == null) return null;
    final unit = p.source.unitType;
    return OpenReading(
      sessionId: s.id,
      progress: p,
      startUnit: s.startUnit,
      awayMinutes: config.awayMinutes(
        clock.now().difference(fromUtcMs(s.startedAt)),
      ),
      pace: await repo.pace(unit, defaultPace: defaultPaceFor(unit)),
      config: config,
      examId: exam?.id,
    );
  });
}

/// How starting a sitting went.
enum StartResult {
  /// The source opened in its app.
  opened,

  /// Started, but nothing to open (a paper book) or it failed to open.
  notOpened,
}

/// Reading and task actions for the Source chapters screen and sheets.
/// Kept alive: its methods read providers after awaiting, and an unwatched
/// auto-dispose notifier would be gone by then.
@Riverpod(keepAlive: true)
class ReadingActions extends _$ReadingActions {
  @override
  void build() {}

  ReadingRepository get _repo => ref.read(readingRepositoryProvider);

  /// Starts a sitting from the reading position, then opens the source in
  /// its app. The sitting is saved first, so it survives the OS closing
  /// PrepBelt.
  Future<StartResult> start(String sourceId) async {
    await _repo.start(sourceId);
    final source = await ref
        .read(sourceRepositoryProvider)
        .watch(sourceId)
        .first;
    final stored = await ref.read(sourceRepositoryProvider).fileOf(sourceId);
    final opener = ref.read(sourceOpenerProvider);
    final opened = stored != null
        ? await opener.open(
            file: (await ref.read(
              fileStoreProvider.future,
            )).resolve(stored.localPath),
          )
        : await opener.open(uri: source?.uri);
    return opened ? StartResult.opened : StartResult.notOpened;
  }

  Future<SavePlan> preview(OpenReading r, int endUnit) =>
      _repo.preview(r.sessionId, endUnit: endUnit, examId: r.examId);

  Future<SaveOutcome> save(
    OpenReading r, {
    required int endUnit,
    required int minutes,
    Set<String> taskNow = const {},
  }) => _repo.save(
    r.sessionId,
    endUnit: endUnit,
    minutes: minutes,
    examId: r.examId,
    taskNow: taskNow,
  );

  Future<void> discard(OpenReading r) => _repo.discard(r.sessionId);

  Future<String> addTask(
    String sourceId, {
    required List<String> chunkIds,
    required String title,
    Importance? importance,
    bool alreadyRead = false,
    String? examId,
  }) => _repo.addTask(
    sourceId,
    chunkIds: chunkIds,
    title: title,
    importance: importance,
    alreadyRead: alreadyRead,
    examId: examId,
  );

  /// "Create N tasks": one per chapter without one, surveyed or not.
  Future<int> createAll(String sourceId, {String? examId}) =>
      ref.read(surveyActionsProvider.notifier).finish(sourceId, examId: examId);

  Future<void> undo(String sourceId) => _repo.undo(sourceId);
}
