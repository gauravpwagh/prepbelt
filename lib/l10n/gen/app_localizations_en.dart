// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PrepBelt';

  @override
  String get navToday => 'Today';

  @override
  String get navExams => 'Exams';

  @override
  String get navSources => 'Sources';

  @override
  String get navProgress => 'Progress';

  @override
  String get navQuickAdd => 'Quick add';

  @override
  String get beltWhite => 'White';

  @override
  String get beltYellow => 'Yellow';

  @override
  String get beltOrange => 'Orange';

  @override
  String get beltGreen => 'Green';

  @override
  String get beltBlue => 'Blue';

  @override
  String get beltBrown => 'Brown';

  @override
  String get beltBlack => 'Black';

  @override
  String beltName(String color) {
    return '$color belt';
  }

  @override
  String get beltNotStarted => 'Not started';

  @override
  String beltSemantics(String belt, int level, int stripes) {
    String _temp0 = intl.Intl.pluralLogic(
      stripes,
      locale: localeName,
      other: '$stripes stripes',
      one: '1 stripe',
      zero: 'no stripes',
    );
    return '$belt, level $level, $_temp0';
  }

  @override
  String beltSemanticsFading(String belt, int level) {
    return '$belt, level $level, fading';
  }

  @override
  String get beltFading => 'fading';

  @override
  String get beltNew => 'new';

  @override
  String get levelActionPromote => 'Promote';

  @override
  String get sessionKindReview => 'Review';

  @override
  String get sessionKindFirstRead => 'First read';

  @override
  String get sessionKindFinalReview => 'Final review';

  @override
  String sessionOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Overdue $_temp0';
  }

  @override
  String sessionMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String sessionStart(String title, String kind) {
    return 'Start $title $kind';
  }

  @override
  String placeholderComingSoon(String screen) {
    return '$screen arrives in a later milestone.';
  }

  @override
  String get screenToday => 'Today\'s training';

  @override
  String get screenExams => 'Exams';

  @override
  String get screenSources => 'Sources';

  @override
  String get screenProgress => 'Progress';

  @override
  String get screenSession => 'Review session';

  @override
  String get screenAddSource => 'Add source';

  @override
  String get screenSurvey => 'Survey';

  @override
  String get screenExam => 'Exam';

  @override
  String get screenTask => 'Task';

  @override
  String get screenRedefine => 'Redefine task';

  @override
  String get screenSettings => 'Settings';

  @override
  String get screenOnboarding => 'Welcome';

  @override
  String get debugRebuild => 'Rebuild mastery from reviews';

  @override
  String debugRebuildDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return 'Rebuilt $_temp0';
  }

  @override
  String get surveyKicker => 'Scouting the terrain';

  @override
  String surveyProgress(int current, int total) {
    return 'Chapter $current of $total';
  }

  @override
  String surveyTimeLeft(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      one: '1 min',
    );
    return 'about $_temp0 left';
  }

  @override
  String get surveyDone => 'All chapters surveyed';

  @override
  String surveyChapterLabel(int number) {
    return 'CHAPTER $number';
  }

  @override
  String surveyRange(int start, int end, int pages) {
    String _temp0 = intl.Intl.pluralLogic(
      pages,
      locale: localeName,
      other: '$pages pages',
      one: '1 page',
    );
    return 'pp. $start–$end · $_temp0';
  }

  @override
  String surveyImportanceFor(String exam) {
    return 'Importance for $exam';
  }

  @override
  String get surveyDifficulty => 'How hard does it look?';

  @override
  String get surveyFamiliarity => 'Studied it before?';

  @override
  String get importanceHigh => 'High';

  @override
  String get importanceMedium => 'Medium';

  @override
  String get importanceLow => 'Low';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get familiarityNew => 'New';

  @override
  String get familiaritySeen => 'Seen it';

  @override
  String get familiarityComfortable => 'Comfortable';

  @override
  String get surveyFirstRead => 'First read';

  @override
  String get surveyTarget => 'Target';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String durationHours(int hours) {
    return '$hours h';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String approximately(String value) {
    return '≈ $value';
  }

  @override
  String surveyMarkRest(int count) {
    return 'Mark the other $count as Medium';
  }

  @override
  String get surveyPrevious => 'Previous';

  @override
  String get surveyNext => 'Next chapter';

  @override
  String get surveyFinish => 'Finish survey';

  @override
  String get surveyEmpty => 'This source has no chapters yet.';

  @override
  String get chaptersSplitAsYouRead =>
      'No chapters yet. Start reading: each sitting becomes the next part, with its own task.';

  @override
  String get loadError => 'Couldn\'t load this. Try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String sourcesSummary(int count, int surveyed) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return '$_temp0 · $surveyed surveyed';
  }

  @override
  String get sourcesEmptyTitle => 'No sources yet';

  @override
  String get sourcesEmptyBody =>
      'Add a PDF, book, video or link you\'ll study from.';

  @override
  String get sourcesAdd => 'Add a source';

  @override
  String get sourcesLoadError => 'Couldn\'t load your sources.';

  @override
  String get sourceTypePdf => 'PDF';

  @override
  String get sourceTypeBook => 'Book';

  @override
  String get sourceTypeVideo => 'Video';

  @override
  String get sourceTypeLink => 'Link';

  @override
  String get sourceTypeNotes => 'Notes';

  @override
  String get sourceTypeQbank => 'Question bank';

  @override
  String sourceUnits(String unit, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    String _temp2 = intl.Intl.selectLogic(unit, {
      'page': '$_temp0',
      'minute': '$count min',
      'question': '$_temp1',
      'other': '$count items',
    });
    return '$_temp2';
  }

  @override
  String sourceChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String sourceSurveyedOf(int done, int total) {
    return 'Surveyed $done of $total';
  }

  @override
  String get sourceSurvey => 'Survey';

  @override
  String get sourceSurveyed => 'Surveyed';

  @override
  String sourceCardSemantics(
    String title,
    String type,
    String size,
    int done,
    int total,
  ) {
    return '$title, $type, $size, surveyed $done of $total chapters.';
  }

  @override
  String get sourceCardHintOpen => 'Open its chapters';

  @override
  String get sourceRename => 'Rename';

  @override
  String get sourceMenu => 'Source options';

  @override
  String sourceRemoveTitle(String title) {
    return 'Remove $title?';
  }

  @override
  String sourceRemoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Its chapters and its $count tasks, with their belts, go too.',
      one: 'Its chapters and its 1 task, with its belt, go too.',
      zero: 'Its chapters and reading progress go too.',
    );
    return '$_temp0 You can undo this right after.';
  }

  @override
  String get sourceRemoveBusy => 'Finish the open review of this source first.';

  @override
  String get sourceRemove => 'Remove';

  @override
  String sourceRemoved(String title) {
    return 'Removed $title';
  }

  @override
  String get undo => 'Undo';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get addSourceWhat => 'What is it?';

  @override
  String get addSourceDetails => 'Details';

  @override
  String get addSourceChapters => 'Chapters';

  @override
  String get addSourceChoosePdf => 'Choose PDF';

  @override
  String get addSourceChooseOther => 'Choose another';

  @override
  String get addSourceTitle => 'Title';

  @override
  String get addSourcePages => 'Total pages';

  @override
  String get addSourceLink => 'Link';

  @override
  String get addSourceLinkOptional => 'Link (optional)';

  @override
  String get addSourceMinutes => 'Length in minutes';

  @override
  String get addSourceQuestions => 'Number of questions';

  @override
  String get addSourceReading => 'Reading bookmarks…';

  @override
  String addSourceFileInfo(String size, String pages) {
    return '$size · $pages';
  }

  @override
  String addSourceMegabytes(String value) {
    return '$value MB';
  }

  @override
  String addSourceKilobytes(String value) {
    return '$value KB';
  }

  @override
  String addSourceFoundBookmarks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return 'Found $_temp0 in the bookmarks';
  }

  @override
  String get addSourceUseBookmarks => 'Use these';

  @override
  String get addSourceNoBookmarks => 'This PDF has no bookmarks we can read.';

  @override
  String get addSourceFileFailed =>
      'Couldn\'t open this file. Choose the PDF again.';

  @override
  String addSourceDuplicate(String title) {
    return 'Already added as $title';
  }

  @override
  String get addSourceOpenIt => 'Open it';

  @override
  String get addSourcePaste => 'Paste a chapter list';

  @override
  String get addSourcePasteHint => 'Rest and motion 40\nForce 63';

  @override
  String get addSourcePasteHelp =>
      'One chapter per line, ending in its first page.';

  @override
  String addSourcePasteErrors(int count, String lines) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lines $lines have no page number.',
      one: 'Line $lines has no page number.',
    );
    return '$_temp0';
  }

  @override
  String addSourceSplitEvery(String size) {
    return 'Split every $size';
  }

  @override
  String get addSourceKeepOne => 'Keep as one';

  @override
  String get addSourceFewer => 'Fewer';

  @override
  String get addSourceMore => 'More';

  @override
  String addSourceRangePages(int start, int end) {
    return 'pp. $start–$end';
  }

  @override
  String addSourceRange(int start, int end) {
    return '$start–$end';
  }

  @override
  String addSourceChunkPages(int start, int end) {
    return 'Pages $start–$end';
  }

  @override
  String addSourceChunkMinutes(int start, int end) {
    return 'Minutes $start–$end';
  }

  @override
  String addSourceChunkQuestions(int start, int end) {
    return 'Questions $start–$end';
  }

  @override
  String get addSourceShort => 'Short — merge with next?';

  @override
  String addSourceLong(int count) {
    return 'Long — will be read over $count sessions';
  }

  @override
  String get addSourceSaveSurvey => 'Save and survey';

  @override
  String get addSourceSaveFailed => 'Couldn\'t save. Try again.';

  @override
  String get addSourcePdfMissing => 'Choose a PDF';

  @override
  String get addSourceTitleMissing => 'Add a title';

  @override
  String get addSourceUnitsMissing => 'Must be more than 0';

  @override
  String get addSourceLinkMissing => 'Add a link';

  @override
  String unitAtPage(int unit) {
    return 'p. $unit';
  }

  @override
  String unitAtMinute(int unit) {
    return '$unit min';
  }

  @override
  String unitAtQuestion(int unit) {
    return 'Q$unit';
  }

  @override
  String chaptersSummary(int chapters, int tasks, int surveyed) {
    String _temp0 = intl.Intl.pluralLogic(
      chapters,
      locale: localeName,
      other: '$chapters chapters',
      one: '1 chapter',
    );
    String _temp1 = intl.Intl.pluralLogic(
      tasks,
      locale: localeName,
      other: '$tasks tasks',
      one: '1 task',
    );
    return '$_temp0 · $_temp1 · surveyed $surveyed of $chapters';
  }

  @override
  String get chaptersEditSurvey => 'Edit survey';

  @override
  String chaptersCreateTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return 'Create $_temp0';
  }

  @override
  String get chaptersCaptionSurvey =>
      'Uses your survey answers. Unsurveyed chapters count as Medium.';

  @override
  String get chaptersCaptionNoSurvey =>
      'Chapters count as Medium. A survey makes this sharper.';

  @override
  String get chaptersCaptionAll => 'Every chapter has a task.';

  @override
  String get chaptersAddTask => 'Add task';

  @override
  String get chaptersLoadError => 'Couldn\'t load this source.';

  @override
  String chaptersTasksCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks created',
      one: '1 task created',
    );
    return '$_temp0';
  }

  @override
  String chapterRowSemantics(int number, String title, String range) {
    return 'Chapter $number, $title, $range.';
  }

  @override
  String get chapterRead => 'Read';

  @override
  String chapterReadPart(int done, int total) {
    return '$done of $total read';
  }

  @override
  String chapterOpenTask(String title) {
    return 'Open task $title';
  }

  @override
  String readingExplored(int done, String size) {
    return 'Explored $done of $size';
  }

  @override
  String readingTimeLeft(String time) {
    return 'about $time left';
  }

  @override
  String get readingStart => 'Start reading';

  @override
  String readingFrom(String position) {
    return 'Read from $position';
  }

  @override
  String readingWatchFrom(String position) {
    return 'Watch from $position';
  }

  @override
  String readingPartly(String title, int done, int total) {
    return '$title · $done of $total read';
  }

  @override
  String readingSince(String time) {
    return 'Reading since $time';
  }

  @override
  String get readingFinish => 'Finish';

  @override
  String readingAllRead(String time) {
    return 'Read to the end · $time';
  }

  @override
  String get readingNotOpened =>
      'Reading started. Read it anywhere, then tap Finish.';

  @override
  String get readingOpenFirst => 'Finish your open reading first.';

  @override
  String get readingSheetTitle => 'How far did you get?';

  @override
  String readingOverline(String title, String position) {
    return '$title · from $position';
  }

  @override
  String readingAway(String time) {
    return 'You were away $time';
  }

  @override
  String get readingTimeLabel => 'Time reading';

  @override
  String get readingUpTo => 'Up to';

  @override
  String readingChapterEnd(String title, String position) {
    return 'End of $title · $position';
  }

  @override
  String readingPreviewTask(String title, String range) {
    return 'Creates task $title ($range).';
  }

  @override
  String readingPreviewFirstRead(String title) {
    return 'First read for $title.';
  }

  @override
  String readingPreviewPartial(String title, int done, int total) {
    return '$title: $done of $total read.';
  }

  @override
  String get readingPreviewNothing => 'Saves your place.';

  @override
  String readingMakeTaskNow(String title) {
    return 'Make $title a task now';
  }

  @override
  String readingPreviewHeld(int minutes, String range) {
    return 'Under $minutes min, so $range waits and joins your next part.';
  }

  @override
  String readingPreviewFinish(String title) {
    return 'Marks $title done.';
  }

  @override
  String get readingPartNow => 'Make it a task anyway';

  @override
  String get readingFinishSource =>
      'That was the last part: I\'m done with this source';

  @override
  String get readingSaveReadOn => 'Save and read on';

  @override
  String readingSavedHeld(String range) {
    return 'Reading saved · $range joins your next part';
  }

  @override
  String get sourceFinish => 'Done with this source';

  @override
  String get sourceReopen => 'Read more of this source';

  @override
  String sourceFinishedSnack(String title) {
    return '$title marked done';
  }

  @override
  String sourceReopenedSnack(String title) {
    return '$title reopened';
  }

  @override
  String sourceFinishedLine(String read) {
    return 'Done · $read read';
  }

  @override
  String get readingDidntRead => 'I didn\'t read';

  @override
  String readingSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reading saved · $count tasks created',
      one: 'Reading saved · 1 task created',
      zero: 'Reading saved',
    );
    return '$_temp0';
  }

  @override
  String get readingLess => 'Less';

  @override
  String get readingMore => 'More';

  @override
  String get addTaskTitle => 'Add task';

  @override
  String get addTaskChapters => 'Chapters';

  @override
  String get addTaskNextChapter => '+ next chapter';

  @override
  String get addTaskName => 'Task name';

  @override
  String get addTaskAlreadyRead => 'Already read it?';

  @override
  String get addTaskNotYet => 'Not yet';

  @override
  String get addTaskYes => 'Yes';

  @override
  String get addTaskYesHint =>
      'Starts at White with its first review scheduled.';

  @override
  String get addTaskCreate => 'Create';

  @override
  String get addTaskAdded => 'Task added';

  @override
  String get sessionReviewTitle => 'Review session';

  @override
  String get sessionFirstReadTitle => 'First read';

  @override
  String get sessionWelcomeBack => 'Welcome back';

  @override
  String get sessionWhereStop => 'Where did you stop?';

  @override
  String get sessionFinishedRange => 'Finished the whole range';

  @override
  String sessionLeftForNext(String left) {
    return '$left left for next time';
  }

  @override
  String get sessionOpenAgain => 'Open the source again';

  @override
  String get sessionHowWell => 'How well could you recall it?';

  @override
  String get sessionHowFirstRead => 'How did the first read go?';

  @override
  String get sessionFirstReadHint =>
      'A first read earns White whatever you choose.';

  @override
  String get rateForgot => 'Forgot';

  @override
  String get rateHard => 'Hard';

  @override
  String get rateGood => 'Good';

  @override
  String get rateEasy => 'Easy';

  @override
  String get sessionBackTomorrow => 'Back tomorrow';

  @override
  String sessionNextInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Next in $days days',
      one: 'Next tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get sessionNoMoreReviews => 'No more reviews planned';

  @override
  String sessionEarned(String belt) {
    return '$belt earned';
  }

  @override
  String sessionPromoted(String belt) {
    return 'Promoted to $belt';
  }

  @override
  String sessionStripeLost(String belt) {
    return '$belt, one stripe lost';
  }

  @override
  String sessionFading(String belt) {
    return '$belt is fading';
  }

  @override
  String sessionXpAgainTomorrow(int xp) {
    return '+$xp XP · again tomorrow';
  }

  @override
  String sessionXpNext(int xp, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '+$xp XP · next review in $_temp0';
  }

  @override
  String sessionXpDone(int xp) {
    return '+$xp XP · all planned reviews done';
  }

  @override
  String get sessionPickRating => 'Pick a rating to finish';

  @override
  String get sessionDone => 'Done · back to Today';

  @override
  String get sessionClosed => 'This session is already closed.';

  @override
  String get sessionBackToToday => 'Back to Today';

  @override
  String get sessionLeave => 'Leave without rating';

  @override
  String get sessionSaveFailed => 'Couldn\'t save. Try again.';

  @override
  String get sessionLoadFailed => 'Couldn\'t load this session.';

  @override
  String get sessionOpenFirst => 'Finish your open session first.';

  @override
  String get sessionNotOpened =>
      'Session started. Study it anywhere, then come back to rate it.';

  @override
  String sessionRatingSemantics(String rating, String next) {
    return '$rating, $next';
  }

  @override
  String todayStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'day streak',
      one: 'day streak',
    );
    return '$_temp0';
  }

  @override
  String todayStreakSemantics(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days day streak',
      one: '1 day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String todayExamLine(String name, String date) {
    return '$name · $date';
  }

  @override
  String todayDaysToGo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days to go',
      one: '1 day to go',
      zero: 'Exam day',
    );
    return '$_temp0';
  }

  @override
  String todaySessions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions · $time',
      one: '1 session · $time',
    );
    return '$_temp0';
  }

  @override
  String todayKindReview(String time) {
    return 'REVIEW · $time';
  }

  @override
  String todayKindOverdue(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'OVERDUE $days DAYS · $time',
      one: 'OVERDUE 1 DAY · $time',
    );
    return '$_temp0';
  }

  @override
  String todayKindFirstRead(String time) {
    return 'FIRST READ · $time';
  }

  @override
  String get todayKindReviewWord => 'review';

  @override
  String get todayKindFirstReadWord => 'first read';

  @override
  String get todayEmptyTitle => 'Nothing to train yet';

  @override
  String get todayEmptyBody =>
      'Add a PDF, book, video or link, then turn its chapters into tasks.';

  @override
  String get todayAddSource => 'Add a source';

  @override
  String get todayDoneTitle => 'All done for today';

  @override
  String get todayDoneBody =>
      'Nothing else is due. Any task can be reviewed early from its page.';

  @override
  String get todayLoadFailed => 'Couldn\'t load today\'s training.';

  @override
  String get todayRetry => 'Try again';

  @override
  String get taskOverline => 'TASK';

  @override
  String taskImportanceLine(String importance, String exam) {
    return '$importance importance · $exam';
  }

  @override
  String taskLevelLine(int level) {
    return 'Level $level of 7';
  }

  @override
  String taskLevelTargetLine(int level, String target) {
    return 'Level $level of 7 · target $target';
  }

  @override
  String taskSteps(int done, int planned) {
    return '$done of $planned reviews done';
  }

  @override
  String get taskDueToday => 'Review due today';

  @override
  String taskOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Overdue $days days · the belt is fading',
      one: 'Overdue 1 day · the belt is fading',
    );
    return '$_temp0';
  }

  @override
  String taskNextOn(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Next review $date · in $days days',
      one: 'Next review $date · tomorrow',
    );
    return '$_temp0';
  }

  @override
  String taskNotStartedLine(String time) {
    return 'Not started · first read about $time';
  }

  @override
  String get taskAllDone =>
      'All reviews done · review any time to keep it fresh';

  @override
  String taskPausedSince(String date) {
    return 'Paused since $date';
  }

  @override
  String get taskStartReview => 'Start review';

  @override
  String get taskReviewEarly => 'Review early';

  @override
  String get taskReviewEarlyHint => 'Counts like any review.';

  @override
  String get taskStartFirstRead => 'Start first read';

  @override
  String get taskCovers => 'Covers';

  @override
  String get taskHistory => 'History';

  @override
  String get taskNoReviews => 'No reviews yet. The first read earns White.';

  @override
  String get taskKindFirstRead => 'First read';

  @override
  String taskKindReview(int n) {
    return 'Review $n';
  }

  @override
  String get taskKindRetry => 'Retry';

  @override
  String taskPromotedTo(String belt) {
    return '→ $belt';
  }

  @override
  String taskPromotedSemantics(String belt) {
    return 'promoted to $belt';
  }

  @override
  String taskHistorySemantics(
    String date,
    String kind,
    String rating,
    String time,
  ) {
    return '$date, $kind, rated $rating, $time';
  }

  @override
  String taskShowAll(int count) {
    return 'Show all $count';
  }

  @override
  String get taskRemoved => 'This task was removed.';

  @override
  String get taskBack => 'Back';

  @override
  String get taskLoadFailed => 'Couldn\'t load this task.';

  @override
  String get reminderTitle => 'Today\'s training is ready';

  @override
  String get reminderBody => 'A few minutes keeps your belts bright.';

  @override
  String get reminderChannel => 'Daily reminder';

  @override
  String todayKindFinalReview(String time) {
    return 'FINAL REVIEW · $time';
  }

  @override
  String todayKindExplore(String time) {
    return 'CONTINUE READING · $time';
  }

  @override
  String get todayKindExploreWord => 'reading';

  @override
  String examDateLine(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
      zero: 'exam day',
    );
    return '$date · $_temp0';
  }

  @override
  String get examBeltToday => 'Exam belt today';

  @override
  String examProjected(String belt) {
    return 'Projected $belt by exam day';
  }

  @override
  String get examReady => 'ready';

  @override
  String get examAtTarget => 'at target';

  @override
  String get examToday => 'today';

  @override
  String examBeltSemantics(String belt, String projected) {
    return 'Exam belt today $belt, projected $projected by exam day';
  }

  @override
  String examWeakLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weak links',
      one: '1 weak link',
    );
    return '$_temp0';
  }

  @override
  String get examWeakHint => 'high importance, below Yellow';

  @override
  String examWeakNotStarted(String when) {
    return 'not started · first read $when';
  }

  @override
  String get examWeakNotPlanned => 'not started';

  @override
  String examWeakNext(String belt, String when) {
    return '$belt · review $when';
  }

  @override
  String get examWhenToday => 'today';

  @override
  String get examWhenTomorrow => 'tomorrow';

  @override
  String get examActivity => 'Activity';

  @override
  String get examActivityHint => 'study minutes per day';

  @override
  String get examActivityLess => 'Less';

  @override
  String get examActivityMore => 'More';

  @override
  String examActivitySemantics(int count, int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Studied on $count days in the last $weeks weeks',
      one: 'Studied on 1 day in the last $weeks weeks',
      zero: 'No study in the last $weeks weeks',
    );
    return '$_temp0';
  }

  @override
  String get examPlanTight =>
      'Not everything fits before the exam. Add study time each day to fit it all.';

  @override
  String get examsEmptyTitle => 'No exam yet';

  @override
  String get examsEmptyBody => 'Add your exam to get a day-by-day plan.';

  @override
  String get examsAdd => 'Add exam';

  @override
  String get examLoadFailed => 'Couldn\'t load this exam.';

  @override
  String get addExamTitle => 'Add exam';

  @override
  String get addExamName => 'Exam name';

  @override
  String get addExamDate => 'Exam date';

  @override
  String get addExamChooseDate => 'Choose a date';

  @override
  String addExamDaysFrom(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days from today',
      one: 'Tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get addExamTime => 'Time each day';

  @override
  String get addExamTimeHint =>
      'The same every day for now. Set each weekday on the exam screen.';

  @override
  String addExamTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Your $count tasks will count toward this exam as Medium. Set importance in each source\'s survey.',
      one:
          'Your 1 task will count toward this exam as Medium. Set importance in each source\'s survey.',
      zero: 'Tasks you add will count toward this exam.',
    );
    return '$_temp0';
  }

  @override
  String get addExamNameMissing => 'Give the exam a name';

  @override
  String get addExamSave => 'Add exam';

  @override
  String get addExamFailed => 'Couldn\'t save. Try again.';

  @override
  String get addExamLess => 'Less time';

  @override
  String get addExamMore => 'More time';

  @override
  String get triageTitle => 'Plan trimmed to fit';

  @override
  String get triageBody =>
      'The least important work was cut first. Keep any task in full and the plan cuts something else.';

  @override
  String triageStepDropFinalLow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Final review dropped · $count Low tasks',
      one: 'Final review dropped · 1 Low task',
    );
    return '$_temp0';
  }

  @override
  String triageStepLowToYellow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aim for Yellow · $count Low tasks',
      one: 'Aim for Yellow · 1 Low task',
    );
    return '$_temp0';
  }

  @override
  String triageStepSkim(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skim instead of read · $count easy Low tasks',
      one: 'Skim instead of read · 1 easy Low task',
    );
    return '$_temp0';
  }

  @override
  String triageStepLowerMedium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'One belt lower · $count Medium tasks',
      one: 'One belt lower · 1 Medium task',
    );
    return '$_temp0';
  }

  @override
  String triageDroppedRow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dropped by you · $count tasks',
      one: 'Dropped by you · 1 task',
    );
    return '$_temp0';
  }

  @override
  String triageKeepAction(String title) {
    return 'Keep $title in full';
  }

  @override
  String triageRestoreAction(String title) {
    return 'Restore $title';
  }

  @override
  String triageDropAction(String title) {
    return 'Drop $title';
  }

  @override
  String triageKeepTitle(String title) {
    return 'Keep $title in full?';
  }

  @override
  String get triageKeepNext => 'To make room, the plan also cuts:';

  @override
  String get triageKeepNothing => 'Nothing else needs to change.';

  @override
  String get triageKeepConfirm => 'Keep it';

  @override
  String get triageCancel => 'Cancel';

  @override
  String get triageNeedsTitle => 'Still doesn\'t fit';

  @override
  String triageNeedsReduced(int minutes) {
    return 'About $minutes more minutes a day keeps this reduced plan.';
  }

  @override
  String triageNeedsFull(int minutes) {
    return 'About $minutes more keeps everything.';
  }

  @override
  String get triageNeedsNoTime =>
      'More time alone can\'t fit it. Drop some tasks, or accept a lower belt.';

  @override
  String triageAddMinutes(int minutes) {
    return 'Add $minutes min a day';
  }

  @override
  String get triageDrop => 'Drop tasks';

  @override
  String get triageDropTitle => 'Drop a task from the plan';

  @override
  String get triageAccept => 'Accept a lower belt';

  @override
  String get triageAccepted =>
      'Reduced plan accepted. You can still add time or drop tasks.';

  @override
  String triageReview(String step) {
    return 'Review cuts in $step';
  }

  @override
  String get examStudyTime => 'Study time';

  @override
  String weekEveryDay(String time) {
    return 'Every day · $time';
  }

  @override
  String get weekOff => 'Off';

  @override
  String get weekSheetTitle => 'Study time each day';

  @override
  String get weekSheetHint =>
      'The plan uses these from today. A day off is planned around.';

  @override
  String get weekSave => 'Save';

  @override
  String weekLess(String day) {
    return 'Less time on $day';
  }

  @override
  String weekMore(String day) {
    return 'More time on $day';
  }

  @override
  String todayReady(int percent) {
    return '$percent% ready';
  }

  @override
  String todayOnTrack(String belt) {
    return 'On track for $belt by exam day';
  }

  @override
  String get redefineTitle => 'Redefine task';

  @override
  String get redefineSubtitle =>
      'Your progress and review history are never lost.';

  @override
  String get redefineEdit => 'Edit';

  @override
  String get redefineScope => 'Scope';

  @override
  String get redefineSplit => 'Split';

  @override
  String get redefinePause => 'Pause';

  @override
  String get redefineResume => 'Resume';

  @override
  String get redefineWhatHappens => 'WHAT HAPPENS';

  @override
  String get redefineCancel => 'Cancel';

  @override
  String get editName => 'Name';

  @override
  String editImportance(String exam) {
    return 'Importance for $exam';
  }

  @override
  String editImpact(String belt, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews planned',
      one: '1 review planned',
    );
    return 'Target $belt · $_temp0';
  }

  @override
  String get editNoChange => 'Nothing changes for your belt or reviews.';

  @override
  String get editSave => 'Save changes';

  @override
  String get scopeFrom => 'From';

  @override
  String get scopeTo => 'To';

  @override
  String get scopeShrink => 'Keeps its belt and reviews.';

  @override
  String get scopeSame => 'Change the range to see what happens.';

  @override
  String scopeAdded(String range) {
    return 'Added $range:';
  }

  @override
  String get scopeGrowSplit => 'Make it a new task';

  @override
  String get scopeGrowKeep => 'Keep as one task';

  @override
  String get scopeGrowSplitImpact =>
      'The added pages start with a first read; this task keeps its belt.';

  @override
  String get scopeGrowKeepImpact =>
      'The belt dims one step until the next Good review.';

  @override
  String get scopeSave => 'Save scope';

  @override
  String get scopeUnavailable =>
      'Scope works on a task with one chapter range.';

  @override
  String get splitDrag => 'Drag to choose where to split';

  @override
  String splitAfter(String position) {
    return 'after $position';
  }

  @override
  String splitPart(String letter, String size) {
    return 'PART $letter · $size';
  }

  @override
  String splitPartName(String title, int number) {
    return '$title, part $number';
  }

  @override
  String splitKeep(String belt) {
    return 'Both parts keep $belt';
  }

  @override
  String get splitStartFresh => 'Both parts start with a first read';

  @override
  String splitNext(String a, String b) {
    return 'Next reviews $a and $b';
  }

  @override
  String get splitUndoHint => 'Undo anytime from the task\'s page';

  @override
  String get splitApply => 'Split into 2 tasks';

  @override
  String get splitUnavailable =>
      'Split needs a task with a page range of at least 2 pages.';

  @override
  String splitHandle(String position) {
    return 'Split after $position';
  }

  @override
  String get pauseBody =>
      'Pausing stops the belt from fading and takes the task out of the plan until you resume. Nothing is lost.';

  @override
  String get pauseApply => 'Pause task';

  @override
  String get resumeBody =>
      'Resuming puts the task back in the plan. Its reviews move later by the time it was paused.';

  @override
  String get resumeApply => 'Resume task';

  @override
  String get redefineSaved => 'Saved';

  @override
  String get redefineSplitDone => 'Split into 2 tasks';

  @override
  String get redefineUndo => 'Undo';

  @override
  String get redefineFailed => 'Couldn\'t save. Try again.';

  @override
  String get taskUndoLast => 'Undo last change';

  @override
  String get taskUndone => 'Change undone';

  @override
  String get taskMore => 'Redefine task';

  @override
  String taskPartOf(String title) {
    return 'Split from $title';
  }

  @override
  String beltWithStripes(String belt, int stripes) {
    String _temp0 = intl.Intl.pluralLogic(
      stripes,
      locale: localeName,
      other: '$stripes stripes',
      one: '1 stripe',
      zero: 'no stripes',
    );
    return '$belt, $_temp0';
  }

  @override
  String beltWithFading(String belt) {
    return '$belt, fading';
  }

  @override
  String get onboardTagline => 'Exam prep, belt by belt.';

  @override
  String get onboardName => 'What should we call you?';

  @override
  String get onboardNameHint => 'Your name';

  @override
  String get onboardMinutes => 'Time to study each day';

  @override
  String get onboardMinutesHint =>
      'You can set each weekday later on the exam screen.';

  @override
  String get onboardContinue => 'Continue';

  @override
  String get onboardReminderTitle => 'A nudge each evening?';

  @override
  String get onboardReminderBody =>
      'One reminder at 19:00 on days you haven\'t studied yet. Never more than one a day.';

  @override
  String get onboardReminderOn => 'Turn on reminder';

  @override
  String get onboardReminderOff => 'Not now';

  @override
  String get onboardExamTitle => 'What are you preparing for?';

  @override
  String get onboardExamBody =>
      'Add your exam to get a day-by-day plan. You can also start with your sources and add it later.';

  @override
  String get onboardAddExam => 'Add exam';

  @override
  String get onboardSkip => 'Skip for now';

  @override
  String onboardStep(int step) {
    return 'Step $step of 3';
  }

  @override
  String get onboardFailed => 'Couldn\'t save. Try again.';

  @override
  String get settingsStudy => 'STUDY';

  @override
  String get settingsReminder => 'REMINDER';

  @override
  String get settingsLook => 'LOOK';

  @override
  String get settingsData => 'YOUR DATA';

  @override
  String get settingsAbout => 'ABOUT';

  @override
  String get settingsDebug => 'DEBUG';

  @override
  String get settingsReminderOn => 'Daily reminder';

  @override
  String get settingsReminderOnHint =>
      'One a day, only if you haven\'t studied yet';

  @override
  String get settingsReminderTime => 'Time';

  @override
  String get settingsTheme => 'Belt theme';

  @override
  String get settingsThemeDojo => 'Dojo';

  @override
  String get settingsThemeHint => 'Gems arrives in a later version.';

  @override
  String get settingsExport => 'Export a backup';

  @override
  String get settingsExportHint => 'One file with everything, sources included';

  @override
  String get settingsRestore => 'Restore from a backup';

  @override
  String get settingsRestoreHint => 'Replaces what is on this phone';

  @override
  String get settingsDiagnostics => 'Export diagnostics';

  @override
  String get settingsDiagnosticsHint =>
      'For testers: app version, recent changes, plan summary. No file contents';

  @override
  String settingsAboutText(String version) {
    return 'PrepBelt $version · Works offline. Nothing leaves your phone unless you export it.';
  }

  @override
  String get settingsOpen => 'Settings';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get backupFailed => 'Couldn\'t save the backup.';

  @override
  String get backupNotABackup => 'This isn\'t a PrepBelt backup.';

  @override
  String get backupTooNew =>
      'This backup is from a newer PrepBelt. Update the app first.';

  @override
  String get restoreConfirmTitle => 'Replace everything?';

  @override
  String restoreConfirmBody(String date) {
    return 'Replace everything on this phone with the backup from $date? This can\'t be undone.';
  }

  @override
  String get restoreConfirm => 'Replace';

  @override
  String get restoreReadyTitle => 'Backup ready';

  @override
  String get restoreReadyAndroid => 'Restart PrepBelt to finish restoring.';

  @override
  String get restoreReadyIos =>
      'Close PrepBelt and open it again to finish restoring.';

  @override
  String get restoreRestart => 'Restart now';

  @override
  String get restoreLater => 'Later';

  @override
  String get diagnosticsSaved => 'Diagnostics saved';

  @override
  String get onboardRestore => 'Restore a backup';

  @override
  String get examMenu => 'Exam options';

  @override
  String get examEdit => 'Edit exam';

  @override
  String get examMarkDone => 'Mark as done';

  @override
  String get examRemove => 'Remove exam';

  @override
  String examRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get examRemoveBody =>
      'The exam and its plan go. Your sources, tasks and belts stay.';

  @override
  String get examRemoveConfirm => 'Remove';

  @override
  String examDoneSnack(String name) {
    return '$name marked as done';
  }

  @override
  String examRemovedSnack(String name) {
    return '$name removed';
  }

  @override
  String get examSavedSnack => 'Exam saved';

  @override
  String examPassed(String name) {
    return '$name is over. Mark it as done to plan your next exam.';
  }

  @override
  String get editExamTitle => 'Edit exam';

  @override
  String get editExamSave => 'Save';
}
