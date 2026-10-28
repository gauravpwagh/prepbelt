import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../exams/state/exam_providers.dart';
import '../../sources/state/source_providers.dart';
import '../data/survey_repository.dart';

part 'survey_providers.g.dart';

/// One chapter as the Survey screen shows it.
final class SurveyChapter {
  const SurveyChapter({
    required this.id,
    required this.title,
    this.startUnit,
    this.endUnit,
    this.difficulty,
    this.familiarity,
    this.importance,
  });

  final String id;
  final String title;
  final int? startUnit;
  final int? endUnit;

  /// 1 Easy .. 3 Hard; null until surveyed.
  final int? difficulty;

  /// 0 New .. 2 Comfortable; null until surveyed.
  final int? familiarity;

  /// For the current exam; null without an exam or before it is set.
  final Importance? importance;

  bool get surveyed => difficulty != null && familiarity != null;

  int? get sizeUnits =>
      startUnit == null || endUnit == null ? null : endUnit! - startUnit! + 1;
}

/// Everything the Survey screen needs, as plain values.
final class SurveyView {
  const SurveyView({
    required this.sourceId,
    required this.sourceTitle,
    required this.unitType,
    required this.chapters,
    this.examId,
    this.examName,
  });

  final String sourceId;
  final String sourceTitle;
  final UnitType unitType;
  final List<SurveyChapter> chapters;
  final String? examId;
  final String? examName;

  int get surveyedCount => chapters.where((c) => c.surveyed).length;
}

@Riverpod(keepAlive: true)
SurveyRepository surveyRepository(Ref ref) =>
    SurveyRepository(ref.watch(writeContextProvider));

/// The survey of one source against the current exam.
@riverpod
Stream<SurveyView> surveyView(Ref ref, String sourceId) async* {
  final source = await ref.watch(sourceProvider(sourceId).future);
  final exam = await ref.watch(currentExamProvider.future);
  if (source == null) return;
  yield* ref
      .watch(surveyRepositoryProvider)
      .watchItems(sourceId, examId: exam?.id)
      .map(
        (items) => SurveyView(
          sourceId: sourceId,
          sourceTitle: source.title,
          unitType: source.unitType,
          examId: exam?.id,
          examName: exam?.name,
          chapters: [
            for (final i in items)
              SurveyChapter(
                id: i.chunk.id,
                title: i.chunk.title,
                startUnit: i.chunk.startUnit,
                endUnit: i.chunk.endUnit,
                difficulty: i.survey?.difficulty,
                familiarity: i.survey?.familiarity,
                importance: i.importance,
              ),
          ],
        ),
      );
}

/// Survey actions for the screen.
@riverpod
class SurveyActions extends _$SurveyActions {
  @override
  void build() {}

  Future<void> answer(
    String chunkId, {
    required int difficulty,
    required int familiarity,
    String? examId,
    Importance? importance,
  }) => ref
      .read(surveyRepositoryProvider)
      .answer(
        chunkId,
        difficulty: difficulty,
        familiarity: familiarity,
        examId: examId,
        importance: importance,
      );

  /// "Mark the other N as Medium": Medium importance and difficulty, New
  /// familiarity — the planner's defaults.
  Future<int> markRestMedium(String sourceId, {String? examId}) => ref
      .read(surveyRepositoryProvider)
      .answerRemaining(
        sourceId,
        difficulty: 2,
        familiarity: 0,
        examId: examId,
        importance: examId == null ? null : Importance.medium,
      );

  /// Creates the tasks for a finished survey (one per chapter).
  Future<int> finish(String sourceId, {String? examId}) =>
      ref.read(surveyRepositoryProvider).createTasks(sourceId, examId: examId);
}
