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

  /// Days before each scheduled review (D53): the first a day after the
  /// first read, each later one after the review before it. Each Solid
  /// review earns the next belt, so six reach Black; after the last gap
  /// reviews repeat at it.
  static const List<int> reviewGapDays = [1, 3, 7, 14, 30, 60];

  /// Reviews every task gets before the exam: when fewer of the gaps fit,
  /// the first this many are squeezed to fit.
  static const int minReviewsBeforeExam = 5;

  /// After [minReviewsBeforeExam] reviews, when the next gap would pass the
  /// exam, one final review is added if at least this many days are left.
  static const int finalReviewMinDays = 7;

  /// Bounds for gaps a student types in Settings.
  static const int reviewGapMaxDays = 365;
  static const int reviewGapsMax = 10;

  /// A review that is not Solid is repeated after this many days.
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

  /// Daily study minutes until first launch asks for them (milestone 6).
  static const int defaultDailyMinutes = 90;

  static const int maxReadingSessionMinutes = 45;
  static const int newSessionFloorMinutes = 15;
  static const int maxDayOverrunMinutes = 10;
  static const int taperDays = 2;

  /// Final-review windows in days before the exam: [from, to].
  static const List<int> finalWindowHigh = [1, 3];
  static const List<int> finalWindowMedium = [2, 5];
  static const List<int> finalWindowLow = [3, 7];

  /// Variety: max first reads from one subject per day when there is an alternative.
  static const int maxFirstReadsPerSubjectPerDay = 2;

  /// Replans triggered within this window collapse into one run.
  static const int plannerDebounceMs = 500;

  /// The belt every exam task aims at (D53). Readiness counts Brown, which
  /// the minimum of [minReviewsBeforeExam] reviews always reaches.
  static const int examTargetLevel = 7;

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

  /// "Number of chapters" in Add source starts here (D49).
  static const int chapterCountDefault = 10;
  static const int chapterCountMax = 100;

  /// A chapter without page numbers is estimated at this many minutes
  /// when the source's size is unknown (D49).
  static const double chapterMinutesDefault = 45;

  /// First reads of a source's chapters needed before their median
  /// replaces the estimate (D49).
  static const int chapterCalibrationSamples = 3;

  /// "Split into N parts" for a chapter without page numbers (D49).
  static const int chapterPartsMax = 10;

  /// Split: children's due dates are staggered by up to this many days.
  static const int splitDueStaggerDays = 2;

  // -------------------------------------------------------------- Sessions

  /// An unreturned session closes as unfinished after this long.
  static const int activeSessionTimeoutHours = 6;

  /// Until the planner exists (milestone 5), Today offers at most this
  /// many not-started tasks as first reads.
  static const int todayFirstReadsWithoutPlan = 2;

  /// Rows each Today box shows before "Show all" (D50).
  static const int todayBoxVisible = 3;

  /// Reviews ahead further than this show their date too (D50).
  static const int todayAheadDateAfterDays = 13;

  // ------------------------------------------------- Reading as you go (D27)

  /// Time away longer than this pre-fills as this many minutes.
  static const int readingMaxAwayMinutes = 180;

  /// The "How far did you get?" time stepper moves in steps of this size.
  static const int readingAwayStepMinutes = 5;

  /// Chapter ends within this many units of the guess show as chips.
  static const int readingChapterChipWindow = 15;

  /// In a source split as it is read (D47), a sitting shorter than this,
  /// with held ones before it, waits to join the next part.
  static const int readingMinPartMinutes = 10;

  /// The pace guess uses at most this many recent sittings (D30).
  static const int readingPaceSittings = 10;

  // ------------------------------------------------- Study folder (D51)

  /// An automatic backup is written when the last one is this many days
  /// old (local dates) and something changed. Settings offers [backupEveryChoices].
  static const int backupEveryDays = 1;
  static const List<int> backupEveryChoices = [1, 3, 7];

  /// Automatic backups kept in the folder; older ones are deleted.
  static const int backupKeep = 7;

  /// The study folder's subfolder for backups.
  static const String backupFolder = 'Backups';

  // ------------------------------------------------------------ Game layer

  /// XP per review = [xpPerRatingWeight] × rating weight + promotion bonus.
  static const int xpPerRatingWeight = 10;

  /// Rating weights (Forgot, Shaky, Solid). The spec names the formula
  /// but not the weights; these are placeholders to tune in the pilot.
  static const List<int> xpRatingWeights = [1, 2, 3];

  /// Promotion bonus; the Back-from-source mockup shows "+40 XP" on a
  /// promotion, so 10 x Good (3) + 10.
  static const int xpPromotionBonus = 10;

  /// Daily reminder time (local), until Settings lets the student pick.
  static const String reminderTime = '19:00';

  /// Reminders are scheduled this many days ahead, so they keep coming
  /// for a while even if the app is not opened.
  static const int reminderDaysAhead = 7;

  /// Activity grid intensity buckets.
  static const int activityGridBuckets = 5;

  /// Weeks the activity grid shows, ending with this one.
  static const int activityGridWeeks = 12;
}

/// Keys of `Setting` rows that override [Defaults]. Values are JSON.
abstract final class SettingKeys {
  static const reviewGapDays = 'review.gapDays';
  static const minReviewsBeforeExam = 'review.minReviewsBeforeExam';
  static const finalReviewMinDays = 'review.finalReviewMinDays';

  /// The review settings and deadline task schedules were last fitted to.
  static const reviewFittedFor = 'review.fittedFor';
  static const retryGapDays = 'review.retryGapDays';
  static const lastReviewDaysBeforeExam = 'review.lastReviewDaysBeforeExam';
  static const overdueDaysPerDimStep = 'review.overdueDaysPerDimStep';
  static const maxDimSteps = 'review.maxDimSteps';

  static const deviceId = 'app.deviceId';
  static const theme = 'ui.theme';
  static const gridPalette = 'ui.gridPalette';

  /// Daily reminder time as "HH:mm", local.
  static const reminderTime = 'ui.reminderTime';

  /// False turns the daily reminder off.
  static const reminderEnabled = 'ui.reminderEnabled';

  /// Set once the notification permission has been asked for.
  static const reminderAsked = 'ui.reminderAsked';

  /// The exam whose reduced plan the student accepted (triage step 5).
  static const triageAccepted = 'plan.triageAccepted';
  static const studentName = 'profile.name';
  static const onboarded = 'profile.onboarded';

  static const readingMaxAwayMinutes = 'reading.maxAwayMinutes';
  static const readingAwayStepMinutes = 'reading.awayStepMinutes';
  static const readingChapterChipWindow = 'reading.chapterChipWindow';
  static const readingMinPartMinutes = 'reading.minPartMinutes';

  /// Days between automatic backups (D51).
  static const backupEveryDays = 'backup.everyDays';
}
