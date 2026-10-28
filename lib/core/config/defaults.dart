/// Every tunable number in PrepBelt, with its default.
///
/// Values here are only defaults. At runtime the `Setting` table may
/// override any of them (see [SettingKeys]); engines receive the merged
/// values through config objects and never read this file's constants
/// for anything a student or tester might tune.
///
/// Sources: docs/02-data-model.md (levels, review schedule, exam tier, XP),
/// docs/04-planner-spec.md (planner), docs/05-architecture.md (sessions,
/// debounce), docs/01-product.md (splitting).
library;

abstract final class Defaults {
  // ---------------------------------------------------------------- Review

  /// Scheduled reviews per task after the first read. Each Good one earns
  /// the next belt, so 5 take White to Brown; Black needs one more,
  /// voluntary review.
  static const int scheduledReviews = 5;

  /// Relative sizes of the gaps before each scheduled review. Gaps are
  /// fitted to the time left before the exam in these proportions.
  static const List<int> reviewGapWeights = [1, 2, 3, 5, 8];

  /// Gaps in days when no exam is set.
  static const List<int> reviewGapDaysWithoutExam = [1, 3, 7, 14, 30];

  /// A review that is not Good is repeated after this many days.
  static const int retryGapDays = 1;

  /// The last review falls at least this many days before the exam day.
  static const int lastReviewDaysBeforeExam = 1;

  /// An overdue belt dims one step once overdue, then one more step
  /// every this many days.
  static const int overdueDaysPerDimStep = 2;

  /// Dim steps shown as 2 stripes, 1 stripe, 0 stripes, faded.
  static const int maxDimSteps = 3;

  /// Highest level a task can reach.
  static const int maxLevel = 7;

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

  /// Add source: "Split every N pages" starts at this N.
  static const int splitSizePages = 20;

  /// Split: children's due dates are staggered by up to this many days.
  static const int splitDueStaggerDays = 2;

  // -------------------------------------------------------------- Sessions

  /// An unreturned session closes as unfinished after this long.
  static const int activeSessionTimeoutHours = 6;

  // ------------------------------------------------- Reading as you go (D27)

  /// Time away longer than this pre-fills as this many minutes.
  static const int readingMaxAwayMinutes = 180;

  /// The "How far did you get?" time stepper moves in steps of this size.
  static const int readingAwayStepMinutes = 5;

  /// Chapter ends within this many units of the guess show as chips.
  static const int readingChapterChipWindow = 15;

  /// The pace guess uses at most this many recent sittings (D30).
  static const int readingPaceSittings = 10;

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
  static const scheduledReviews = 'review.scheduledReviews';
  static const reviewGapWeights = 'review.gapWeights';
  static const reviewGapDaysWithoutExam = 'review.gapDaysWithoutExam';
  static const retryGapDays = 'review.retryGapDays';
  static const lastReviewDaysBeforeExam = 'review.lastReviewDaysBeforeExam';
  static const overdueDaysPerDimStep = 'review.overdueDaysPerDimStep';
  static const maxDimSteps = 'review.maxDimSteps';

  static const deviceId = 'app.deviceId';
  static const theme = 'ui.theme';
  static const gridPalette = 'ui.gridPalette';
  static const reminderTime = 'ui.reminderTime';
  static const studentName = 'profile.name';
  static const onboarded = 'profile.onboarded';

  static const readingMaxAwayMinutes = 'reading.maxAwayMinutes';
  static const readingAwayStepMinutes = 'reading.awayStepMinutes';
  static const readingChapterChipWindow = 'reading.chapterChipWindow';
}
