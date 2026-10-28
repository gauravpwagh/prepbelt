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
  String get sourceCardHintSurvey => 'Continue the survey';

  @override
  String get sourceCardHintReview => 'Review the survey';

  @override
  String get sourceRename => 'Rename';

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
}
