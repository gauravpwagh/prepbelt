/// Every tunable number in PrepBelt, with its default.
///
/// Values here are only defaults. At runtime the `Setting` table may
/// override any of them (see [SettingKeys]); engines receive the merged
/// values through config objects and never read this file's constants
/// for anything a student or tester might tune.
///
/// Sources: docs/02-data-model.md (levels, shine, exam tier, XP),
/// docs/04-planner-spec.md (planner), docs/05-architecture.md (sessions,
/// debounce), docs/01-product.md (splitting).
library;

abstract final class Defaults {
  // ---------------------------------------------------------------- Review

  /// Target recall probability when a review falls due. One global value.
  static const double retentionTarget = 0.90;

  /// Minimum FSRS stability (days) for levels 2..7. Level 1 is set by the
  /// first read. Index 0 is level 2.
  static const List<double> levelStabilityThresholds = [3, 7, 14, 30, 60, 120];

  /// Highest level a task can reach.
  static const int maxLevel = 7;

  /// Optional limit on levels gained in one review. Null means the level
  /// follows stability directly (decision D2).
  static const int? maxPromotionPerReview = null;

  /// Retrievability at or above each value earns one stripe. Index 0 is
  /// the 2-stripe cut-off, index 1 the 1-stripe cut-off (decision D3).
  static const List<double> stripeThresholds = [0.90, 0.80];

  /// Below this retrievability, an overdue task displays one level lower.
  static const double fadingRetrievability = 0.70;

  /// FSRS-6 model weights. Null means "use the scheduler's defaults".
  static const List<double>? fsrsParameters = null;

  /// Longest interval FSRS may schedule, in days.
  static const int fsrsMaximumIntervalDays = 36500;

  // ---------------------------------------------------------- Effort model

  /// Default minutes per unit, by unit type.
  static const double pacePageMin = 3;
  static const double paceVideoMinuteMin = 1.5;
  static const double paceQuestionMin = 2;

  /// Pace for `item` units, which the spec does not price. Same as a page.
  static const double paceItemMin = 3;

  /// Effort multipliers by surveyed difficulty (Easy, Medium, Hard).
  static const List<double> difficultyFactors = [0.67, 1.0, 1.33];

  /// Effort multipliers by familiarity (New, Seen it, Comfortable).
  static const List<double> familiarityFactors = [1.0, 0.7, 0.45];

  /// First review costs this share of the first read; later ones [laterReviewShare].
  static const double firstReviewShare = 0.35;
  static const double laterReviewShare = 0.20;
  static const int reviewMinMinutes = 5;
  static const int reviewMaxMinutes = 30;

  /// Pace calibration: personal after this many sessions, fully personal
  /// after [paceFullyPersonalSessions]. Blend weight in between.
  static const int paceCalibrationSessions = 3;
  static const int paceFullyPersonalSessions = 10;
  static const double paceBlendWeight = 0.5;

  // --------------------------------------------------------------- Planner

  static const int maxReadingSessionMinutes = 45;
  static const int newSessionFloorMinutes = 15;
  static const int maxDayOverrunMinutes = 10;
  static const int taperDays = 2;

  /// Final-review windows in days before the exam: [from, to].
  static const List<int> finalWindowHigh = [1, 3];
  static const List<int> finalWindowMedium = [2, 5];
  static const List<int> finalWindowLow = [3, 7];

  /// A review may move this many days earlier or later than due.
  static const int smoothingDaysEarlier = 2;
  static const int smoothingDaysLater = 1;

  /// Variety: max first reads from one subject per day when there is an alternative.
  static const int maxFirstReadsPerSubjectPerDay = 2;

  /// Triage skim: share of the first-read estimate kept.
  static const double skimShare = 0.40;

  /// Replans triggered within this window collapse into one run.
  static const int plannerDebounceMs = 500;

  /// Belt targets by importance (High, Medium, Low).
  static const int targetLevelHigh = 7;
  static const int targetLevelMedium = 5;
  static const int targetLevelLow = 4;

  /// Exam priority weights for capacity shares (1.1): low, normal, high.
  static const List<double> examPriorityWeights = [1, 1.5, 2];

  /// Shared tasks skip a second final review if exams are this close (1.1).
  static const int sharedFinalReviewMinGapDays = 7;

  // ----------------------------------------------------------------- Exam

  /// Importance weights (High, Medium, Low) for exam tier and readiness.
  static const List<int> importanceWeights = [3, 2, 1];

  /// Share of weighted syllabus that must reach a level for the exam tier.
  static const double examTierCoverage = 0.80;

  /// A High task below this level is a weak link.
  static const int weakLinkBelowLevel = 2;

  // ---------------------------------------------------------- Task shaping

  /// A task should be reviewable in about this many minutes.
  static const int taskReviewTargetMinutes = 20;

  /// Chunks under this many pages get a merge suggestion.
  static const int mergeSuggestionPages = 5;

  /// Split: children's due dates are staggered by up to this many days.
  static const int splitDueStaggerDays = 2;

  // -------------------------------------------------------------- Sessions

  /// An unreturned session closes as unfinished after this long.
  static const int activeSessionTimeoutHours = 6;

  // ------------------------------------------------------------ Game layer

  /// XP per review = [xpPerRatingWeight] × rating weight + promotion bonus.
  static const int xpPerRatingWeight = 10;

  /// Rating weights (Forgot, Hard, Good, Easy). The spec names the formula
  /// but not the weights; these are placeholders to tune in the pilot.
  static const List<int> xpRatingWeights = [1, 2, 3, 4];

  /// Promotion bonus; the Back-from-source mockup shows "+40 XP" on a
  /// promotion, so 10 x Good (3) + 10.
  static const int xpPromotionBonus = 10;

  /// Activity grid intensity buckets.
  static const int activityGridBuckets = 5;
}

/// Keys of `Setting` rows that override [Defaults]. Values are JSON.
abstract final class SettingKeys {
  static const retentionTarget = 'review.retentionTarget';
  static const levelStabilityThresholds = 'review.levelStabilityThresholds';
  static const maxPromotionPerReview = 'review.maxPromotionPerReview';
  static const stripeThresholds = 'review.stripeThresholds';
  static const fadingRetrievability = 'review.fadingRetrievability';
  static const fsrsParameters = 'review.fsrsParameters';
  static const fsrsMaximumIntervalDays = 'review.fsrsMaximumIntervalDays';

  static const deviceId = 'app.deviceId';
  static const theme = 'ui.theme';
  static const gridPalette = 'ui.gridPalette';
  static const reminderTime = 'ui.reminderTime';
  static const studentName = 'profile.name';
  static const onboarded = 'profile.onboarded';
}
