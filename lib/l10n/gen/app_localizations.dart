import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PrepBelt'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get navExams;

  /// No description provided for @navSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get navSources;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get navQuickAdd;

  /// No description provided for @beltWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get beltWhite;

  /// No description provided for @beltYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get beltYellow;

  /// No description provided for @beltOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get beltOrange;

  /// No description provided for @beltGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get beltGreen;

  /// No description provided for @beltBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get beltBlue;

  /// No description provided for @beltBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get beltBrown;

  /// No description provided for @beltBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get beltBlack;

  /// No description provided for @beltName.
  ///
  /// In en, this message translates to:
  /// **'{color} belt'**
  String beltName(String color);

  /// No description provided for @beltNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get beltNotStarted;

  /// No description provided for @beltSemantics.
  ///
  /// In en, this message translates to:
  /// **'{belt}, level {level}, {stripes, plural, =0{no stripes} =1{1 stripe} other{{stripes} stripes}}'**
  String beltSemantics(String belt, int level, int stripes);

  /// No description provided for @beltSemanticsFading.
  ///
  /// In en, this message translates to:
  /// **'{belt}, level {level}, fading'**
  String beltSemanticsFading(String belt, int level);

  /// No description provided for @beltFading.
  ///
  /// In en, this message translates to:
  /// **'fading'**
  String get beltFading;

  /// No description provided for @beltNew.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get beltNew;

  /// No description provided for @levelActionPromote.
  ///
  /// In en, this message translates to:
  /// **'Promote'**
  String get levelActionPromote;

  /// No description provided for @sessionKindReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get sessionKindReview;

  /// No description provided for @sessionKindFirstRead.
  ///
  /// In en, this message translates to:
  /// **'First read'**
  String get sessionKindFirstRead;

  /// No description provided for @sessionKindFinalReview.
  ///
  /// In en, this message translates to:
  /// **'Final review'**
  String get sessionKindFinalReview;

  /// No description provided for @sessionOverdueDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue {days, plural, =1{1 day} other{{days} days}}'**
  String sessionOverdueDays(int days);

  /// No description provided for @sessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String sessionMinutes(int minutes);

  /// No description provided for @sessionStart.
  ///
  /// In en, this message translates to:
  /// **'Start {title} {kind}'**
  String sessionStart(String title, String kind);

  /// No description provided for @placeholderComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{screen} arrives in a later milestone.'**
  String placeholderComingSoon(String screen);

  /// No description provided for @screenToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s training'**
  String get screenToday;

  /// No description provided for @screenExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get screenExams;

  /// No description provided for @screenSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get screenSources;

  /// No description provided for @screenProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get screenProgress;

  /// No description provided for @screenSession.
  ///
  /// In en, this message translates to:
  /// **'Review session'**
  String get screenSession;

  /// No description provided for @screenAddSource.
  ///
  /// In en, this message translates to:
  /// **'Add source'**
  String get screenAddSource;

  /// No description provided for @screenSurvey.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get screenSurvey;

  /// No description provided for @screenExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get screenExam;

  /// No description provided for @screenTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get screenTask;

  /// No description provided for @screenRedefine.
  ///
  /// In en, this message translates to:
  /// **'Redefine task'**
  String get screenRedefine;

  /// No description provided for @screenSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get screenSettings;

  /// No description provided for @screenOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get screenOnboarding;

  /// No description provided for @debugRebuild.
  ///
  /// In en, this message translates to:
  /// **'Rebuild mastery from reviews'**
  String get debugRebuild;

  /// No description provided for @debugRebuildDone.
  ///
  /// In en, this message translates to:
  /// **'Rebuilt {count, plural, =1{1 task} other{{count} tasks}}'**
  String debugRebuildDone(int count);

  /// No description provided for @surveyKicker.
  ///
  /// In en, this message translates to:
  /// **'Scouting the terrain'**
  String get surveyKicker;

  /// No description provided for @surveyProgress.
  ///
  /// In en, this message translates to:
  /// **'Chapter {current} of {total}'**
  String surveyProgress(int current, int total);

  /// No description provided for @surveyTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'about {minutes, plural, =1{1 min} other{{minutes} min}} left'**
  String surveyTimeLeft(int minutes);

  /// No description provided for @surveyDone.
  ///
  /// In en, this message translates to:
  /// **'All chapters surveyed'**
  String get surveyDone;

  /// No description provided for @surveyChapterLabel.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {number}'**
  String surveyChapterLabel(int number);

  /// No description provided for @surveyRange.
  ///
  /// In en, this message translates to:
  /// **'pp. {start}–{end} · {pages, plural, =1{1 page} other{{pages} pages}}'**
  String surveyRange(int start, int end, int pages);

  /// No description provided for @surveyImportanceFor.
  ///
  /// In en, this message translates to:
  /// **'Importance for {exam}'**
  String surveyImportanceFor(String exam);

  /// No description provided for @surveyDifficulty.
  ///
  /// In en, this message translates to:
  /// **'How hard does it look?'**
  String get surveyDifficulty;

  /// No description provided for @surveyFamiliarity.
  ///
  /// In en, this message translates to:
  /// **'Studied it before?'**
  String get surveyFamiliarity;

  /// No description provided for @importanceHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get importanceHigh;

  /// No description provided for @importanceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get importanceMedium;

  /// No description provided for @importanceLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get importanceLow;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @familiarityNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get familiarityNew;

  /// No description provided for @familiaritySeen.
  ///
  /// In en, this message translates to:
  /// **'Seen it'**
  String get familiaritySeen;

  /// No description provided for @familiarityComfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get familiarityComfortable;

  /// No description provided for @surveyFirstRead.
  ///
  /// In en, this message translates to:
  /// **'First read'**
  String get surveyFirstRead;

  /// No description provided for @surveyTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get surveyTarget;

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String durationHours(int hours);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @approximately.
  ///
  /// In en, this message translates to:
  /// **'≈ {value}'**
  String approximately(String value);

  /// No description provided for @surveyMarkRest.
  ///
  /// In en, this message translates to:
  /// **'Mark the other {count} as Medium'**
  String surveyMarkRest(int count);

  /// No description provided for @surveyPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get surveyPrevious;

  /// No description provided for @surveyNext.
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get surveyNext;

  /// No description provided for @surveyFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish survey'**
  String get surveyFinish;

  /// No description provided for @surveyEmpty.
  ///
  /// In en, this message translates to:
  /// **'This source has no chapters yet.'**
  String get surveyEmpty;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this. Try again.'**
  String get loadError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @sourcesSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source} other{{count} sources}} · {surveyed} surveyed'**
  String sourcesSummary(int count, int surveyed);

  /// No description provided for @sourcesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sources yet'**
  String get sourcesEmptyTitle;

  /// No description provided for @sourcesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a PDF, book, video or link you\'ll study from.'**
  String get sourcesEmptyBody;

  /// No description provided for @sourcesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a source'**
  String get sourcesAdd;

  /// No description provided for @sourcesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your sources.'**
  String get sourcesLoadError;

  /// No description provided for @sourceTypePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get sourceTypePdf;

  /// No description provided for @sourceTypeBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get sourceTypeBook;

  /// No description provided for @sourceTypeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get sourceTypeVideo;

  /// No description provided for @sourceTypeLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get sourceTypeLink;

  /// No description provided for @sourceTypeNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get sourceTypeNotes;

  /// No description provided for @sourceTypeQbank.
  ///
  /// In en, this message translates to:
  /// **'Question bank'**
  String get sourceTypeQbank;

  /// No description provided for @sourceUnits.
  ///
  /// In en, this message translates to:
  /// **'{unit, select, page{{count, plural, =1{1 page} other{{count} pages}}} minute{{count} min} question{{count, plural, =1{1 question} other{{count} questions}}} other{{count} items}}'**
  String sourceUnits(String unit, int count);

  /// No description provided for @sourceChapters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter} other{{count} chapters}}'**
  String sourceChapters(int count);

  /// No description provided for @sourceSurveyedOf.
  ///
  /// In en, this message translates to:
  /// **'Surveyed {done} of {total}'**
  String sourceSurveyedOf(int done, int total);

  /// No description provided for @sourceSurvey.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get sourceSurvey;

  /// No description provided for @sourceSurveyed.
  ///
  /// In en, this message translates to:
  /// **'Surveyed'**
  String get sourceSurveyed;

  /// No description provided for @sourceCardSemantics.
  ///
  /// In en, this message translates to:
  /// **'{title}, {type}, {size}, surveyed {done} of {total} chapters.'**
  String sourceCardSemantics(
    String title,
    String type,
    String size,
    int done,
    int total,
  );

  /// No description provided for @sourceCardHintOpen.
  ///
  /// In en, this message translates to:
  /// **'Open its chapters'**
  String get sourceCardHintOpen;

  /// No description provided for @sourceRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get sourceRename;

  /// No description provided for @sourceRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get sourceRemove;

  /// No description provided for @sourceRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed {title}'**
  String sourceRemoved(String title);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @addSourceWhat.
  ///
  /// In en, this message translates to:
  /// **'What is it?'**
  String get addSourceWhat;

  /// No description provided for @addSourceDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get addSourceDetails;

  /// No description provided for @addSourceChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get addSourceChapters;

  /// No description provided for @addSourceChoosePdf.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF'**
  String get addSourceChoosePdf;

  /// No description provided for @addSourceChooseOther.
  ///
  /// In en, this message translates to:
  /// **'Choose another'**
  String get addSourceChooseOther;

  /// No description provided for @addSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get addSourceTitle;

  /// No description provided for @addSourcePages.
  ///
  /// In en, this message translates to:
  /// **'Total pages'**
  String get addSourcePages;

  /// No description provided for @addSourceLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get addSourceLink;

  /// No description provided for @addSourceLinkOptional.
  ///
  /// In en, this message translates to:
  /// **'Link (optional)'**
  String get addSourceLinkOptional;

  /// No description provided for @addSourceMinutes.
  ///
  /// In en, this message translates to:
  /// **'Length in minutes'**
  String get addSourceMinutes;

  /// No description provided for @addSourceQuestions.
  ///
  /// In en, this message translates to:
  /// **'Number of questions'**
  String get addSourceQuestions;

  /// No description provided for @addSourceReading.
  ///
  /// In en, this message translates to:
  /// **'Reading bookmarks…'**
  String get addSourceReading;

  /// No description provided for @addSourceFileInfo.
  ///
  /// In en, this message translates to:
  /// **'{size} · {pages}'**
  String addSourceFileInfo(String size, String pages);

  /// No description provided for @addSourceMegabytes.
  ///
  /// In en, this message translates to:
  /// **'{value} MB'**
  String addSourceMegabytes(String value);

  /// No description provided for @addSourceKilobytes.
  ///
  /// In en, this message translates to:
  /// **'{value} KB'**
  String addSourceKilobytes(String value);

  /// No description provided for @addSourceFoundBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Found {count, plural, =1{1 chapter} other{{count} chapters}} in the bookmarks'**
  String addSourceFoundBookmarks(int count);

  /// No description provided for @addSourceUseBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Use these'**
  String get addSourceUseBookmarks;

  /// No description provided for @addSourceNoBookmarks.
  ///
  /// In en, this message translates to:
  /// **'This PDF has no bookmarks we can read.'**
  String get addSourceNoBookmarks;

  /// No description provided for @addSourceFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this file. Choose the PDF again.'**
  String get addSourceFileFailed;

  /// No description provided for @addSourceDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Already added as {title}'**
  String addSourceDuplicate(String title);

  /// No description provided for @addSourceOpenIt.
  ///
  /// In en, this message translates to:
  /// **'Open it'**
  String get addSourceOpenIt;

  /// No description provided for @addSourcePaste.
  ///
  /// In en, this message translates to:
  /// **'Paste a chapter list'**
  String get addSourcePaste;

  /// No description provided for @addSourcePasteHint.
  ///
  /// In en, this message translates to:
  /// **'Rest and motion 40\nForce 63'**
  String get addSourcePasteHint;

  /// No description provided for @addSourcePasteHelp.
  ///
  /// In en, this message translates to:
  /// **'One chapter per line, ending in its first page.'**
  String get addSourcePasteHelp;

  /// No description provided for @addSourcePasteErrors.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Line {lines} has no page number.} other{Lines {lines} have no page number.}}'**
  String addSourcePasteErrors(int count, String lines);

  /// No description provided for @addSourceSplitEvery.
  ///
  /// In en, this message translates to:
  /// **'Split every {size}'**
  String addSourceSplitEvery(String size);

  /// No description provided for @addSourceKeepOne.
  ///
  /// In en, this message translates to:
  /// **'Keep as one'**
  String get addSourceKeepOne;

  /// No description provided for @addSourceFewer.
  ///
  /// In en, this message translates to:
  /// **'Fewer'**
  String get addSourceFewer;

  /// No description provided for @addSourceMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get addSourceMore;

  /// No description provided for @addSourceRangePages.
  ///
  /// In en, this message translates to:
  /// **'pp. {start}–{end}'**
  String addSourceRangePages(int start, int end);

  /// No description provided for @addSourceRange.
  ///
  /// In en, this message translates to:
  /// **'{start}–{end}'**
  String addSourceRange(int start, int end);

  /// No description provided for @addSourceChunkPages.
  ///
  /// In en, this message translates to:
  /// **'Pages {start}–{end}'**
  String addSourceChunkPages(int start, int end);

  /// No description provided for @addSourceChunkMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes {start}–{end}'**
  String addSourceChunkMinutes(int start, int end);

  /// No description provided for @addSourceChunkQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions {start}–{end}'**
  String addSourceChunkQuestions(int start, int end);

  /// No description provided for @addSourceShort.
  ///
  /// In en, this message translates to:
  /// **'Short — merge with next?'**
  String get addSourceShort;

  /// No description provided for @addSourceLong.
  ///
  /// In en, this message translates to:
  /// **'Long — will be read over {count} sessions'**
  String addSourceLong(int count);

  /// No description provided for @addSourceSaveSurvey.
  ///
  /// In en, this message translates to:
  /// **'Save and survey'**
  String get addSourceSaveSurvey;

  /// No description provided for @addSourceSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again.'**
  String get addSourceSaveFailed;

  /// No description provided for @addSourcePdfMissing.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF'**
  String get addSourcePdfMissing;

  /// No description provided for @addSourceTitleMissing.
  ///
  /// In en, this message translates to:
  /// **'Add a title'**
  String get addSourceTitleMissing;

  /// No description provided for @addSourceUnitsMissing.
  ///
  /// In en, this message translates to:
  /// **'Must be more than 0'**
  String get addSourceUnitsMissing;

  /// No description provided for @addSourceLinkMissing.
  ///
  /// In en, this message translates to:
  /// **'Add a link'**
  String get addSourceLinkMissing;

  /// No description provided for @unitAtPage.
  ///
  /// In en, this message translates to:
  /// **'p. {unit}'**
  String unitAtPage(int unit);

  /// No description provided for @unitAtMinute.
  ///
  /// In en, this message translates to:
  /// **'{unit} min'**
  String unitAtMinute(int unit);

  /// No description provided for @unitAtQuestion.
  ///
  /// In en, this message translates to:
  /// **'Q{unit}'**
  String unitAtQuestion(int unit);

  /// No description provided for @chaptersSummary.
  ///
  /// In en, this message translates to:
  /// **'{chapters, plural, =1{1 chapter} other{{chapters} chapters}} · {tasks, plural, =1{1 task} other{{tasks} tasks}} · surveyed {surveyed} of {chapters}'**
  String chaptersSummary(int chapters, int tasks, int surveyed);

  /// No description provided for @chaptersEditSurvey.
  ///
  /// In en, this message translates to:
  /// **'Edit survey'**
  String get chaptersEditSurvey;

  /// No description provided for @chaptersCreateTasks.
  ///
  /// In en, this message translates to:
  /// **'Create {count, plural, =1{1 task} other{{count} tasks}}'**
  String chaptersCreateTasks(int count);

  /// No description provided for @chaptersCaptionSurvey.
  ///
  /// In en, this message translates to:
  /// **'Uses your survey answers. Unsurveyed chapters count as Medium.'**
  String get chaptersCaptionSurvey;

  /// No description provided for @chaptersCaptionNoSurvey.
  ///
  /// In en, this message translates to:
  /// **'Chapters count as Medium. A survey makes this sharper.'**
  String get chaptersCaptionNoSurvey;

  /// No description provided for @chaptersCaptionAll.
  ///
  /// In en, this message translates to:
  /// **'Every chapter has a task.'**
  String get chaptersCaptionAll;

  /// No description provided for @chaptersAddTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get chaptersAddTask;

  /// No description provided for @chaptersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this source.'**
  String get chaptersLoadError;

  /// No description provided for @chaptersTasksCreated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task created} other{{count} tasks created}}'**
  String chaptersTasksCreated(int count);

  /// No description provided for @chapterRowSemantics.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}, {title}, {range}.'**
  String chapterRowSemantics(int number, String title, String range);

  /// No description provided for @chapterRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get chapterRead;

  /// No description provided for @chapterReadPart.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} read'**
  String chapterReadPart(int done, int total);

  /// No description provided for @chapterOpenTask.
  ///
  /// In en, this message translates to:
  /// **'Open task {title}'**
  String chapterOpenTask(String title);

  /// No description provided for @readingExplored.
  ///
  /// In en, this message translates to:
  /// **'Explored {done} of {size}'**
  String readingExplored(int done, String size);

  /// No description provided for @readingTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'about {time} left'**
  String readingTimeLeft(String time);

  /// No description provided for @readingStart.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get readingStart;

  /// No description provided for @readingFrom.
  ///
  /// In en, this message translates to:
  /// **'Read from {position}'**
  String readingFrom(String position);

  /// No description provided for @readingWatchFrom.
  ///
  /// In en, this message translates to:
  /// **'Watch from {position}'**
  String readingWatchFrom(String position);

  /// No description provided for @readingPartly.
  ///
  /// In en, this message translates to:
  /// **'{title} · {done} of {total} read'**
  String readingPartly(String title, int done, int total);

  /// No description provided for @readingSince.
  ///
  /// In en, this message translates to:
  /// **'Reading since {time}'**
  String readingSince(String time);

  /// No description provided for @readingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get readingFinish;

  /// No description provided for @readingAllRead.
  ///
  /// In en, this message translates to:
  /// **'Read to the end · {time}'**
  String readingAllRead(String time);

  /// No description provided for @readingNotOpened.
  ///
  /// In en, this message translates to:
  /// **'Reading started. Read it anywhere, then tap Finish.'**
  String get readingNotOpened;

  /// No description provided for @readingOpenFirst.
  ///
  /// In en, this message translates to:
  /// **'Finish your open reading first.'**
  String get readingOpenFirst;

  /// No description provided for @readingSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How far did you get?'**
  String get readingSheetTitle;

  /// No description provided for @readingOverline.
  ///
  /// In en, this message translates to:
  /// **'{title} · from {position}'**
  String readingOverline(String title, String position);

  /// No description provided for @readingAway.
  ///
  /// In en, this message translates to:
  /// **'You were away {time}'**
  String readingAway(String time);

  /// No description provided for @readingTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time reading'**
  String get readingTimeLabel;

  /// No description provided for @readingUpTo.
  ///
  /// In en, this message translates to:
  /// **'Up to'**
  String get readingUpTo;

  /// No description provided for @readingChapterEnd.
  ///
  /// In en, this message translates to:
  /// **'End of {title} · {position}'**
  String readingChapterEnd(String title, String position);

  /// No description provided for @readingPreviewTask.
  ///
  /// In en, this message translates to:
  /// **'Creates task {title} ({range}).'**
  String readingPreviewTask(String title, String range);

  /// No description provided for @readingPreviewFirstRead.
  ///
  /// In en, this message translates to:
  /// **'First read for {title}.'**
  String readingPreviewFirstRead(String title);

  /// No description provided for @readingPreviewPartial.
  ///
  /// In en, this message translates to:
  /// **'{title}: {done} of {total} read.'**
  String readingPreviewPartial(String title, int done, int total);

  /// No description provided for @readingPreviewNothing.
  ///
  /// In en, this message translates to:
  /// **'Saves your place.'**
  String get readingPreviewNothing;

  /// No description provided for @readingMakeTaskNow.
  ///
  /// In en, this message translates to:
  /// **'Make {title} a task now'**
  String readingMakeTaskNow(String title);

  /// No description provided for @readingDidntRead.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t read'**
  String get readingDidntRead;

  /// No description provided for @readingSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Reading saved} =1{Reading saved · 1 task created} other{Reading saved · {count} tasks created}}'**
  String readingSaved(int count);

  /// No description provided for @readingLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get readingLess;

  /// No description provided for @readingMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get readingMore;

  /// No description provided for @addTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTaskTitle;

  /// No description provided for @addTaskChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get addTaskChapters;

  /// No description provided for @addTaskNextChapter.
  ///
  /// In en, this message translates to:
  /// **'+ next chapter'**
  String get addTaskNextChapter;

  /// No description provided for @addTaskName.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get addTaskName;

  /// No description provided for @addTaskAlreadyRead.
  ///
  /// In en, this message translates to:
  /// **'Already read it?'**
  String get addTaskAlreadyRead;

  /// No description provided for @addTaskNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get addTaskNotYet;

  /// No description provided for @addTaskYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get addTaskYes;

  /// No description provided for @addTaskYesHint.
  ///
  /// In en, this message translates to:
  /// **'Starts at White with its first review scheduled.'**
  String get addTaskYesHint;

  /// No description provided for @addTaskCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get addTaskCreate;

  /// No description provided for @addTaskAdded.
  ///
  /// In en, this message translates to:
  /// **'Task added'**
  String get addTaskAdded;

  /// No description provided for @sessionReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review session'**
  String get sessionReviewTitle;

  /// No description provided for @sessionFirstReadTitle.
  ///
  /// In en, this message translates to:
  /// **'First read'**
  String get sessionFirstReadTitle;

  /// No description provided for @sessionWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get sessionWelcomeBack;

  /// No description provided for @sessionWhereStop.
  ///
  /// In en, this message translates to:
  /// **'Where did you stop?'**
  String get sessionWhereStop;

  /// No description provided for @sessionFinishedRange.
  ///
  /// In en, this message translates to:
  /// **'Finished the whole range'**
  String get sessionFinishedRange;

  /// No description provided for @sessionLeftForNext.
  ///
  /// In en, this message translates to:
  /// **'{left} left for next time'**
  String sessionLeftForNext(String left);

  /// No description provided for @sessionOpenAgain.
  ///
  /// In en, this message translates to:
  /// **'Open the source again'**
  String get sessionOpenAgain;

  /// No description provided for @sessionHowWell.
  ///
  /// In en, this message translates to:
  /// **'How well could you recall it?'**
  String get sessionHowWell;

  /// No description provided for @sessionHowFirstRead.
  ///
  /// In en, this message translates to:
  /// **'How did the first read go?'**
  String get sessionHowFirstRead;

  /// No description provided for @sessionFirstReadHint.
  ///
  /// In en, this message translates to:
  /// **'A first read earns White whatever you choose.'**
  String get sessionFirstReadHint;

  /// No description provided for @rateForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get rateForgot;

  /// No description provided for @rateHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get rateHard;

  /// No description provided for @rateGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get rateGood;

  /// No description provided for @rateEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get rateEasy;

  /// No description provided for @sessionBackTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Back tomorrow'**
  String get sessionBackTomorrow;

  /// No description provided for @sessionNextInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Next tomorrow} other{Next in {days} days}}'**
  String sessionNextInDays(int days);

  /// No description provided for @sessionNoMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'No more reviews planned'**
  String get sessionNoMoreReviews;

  /// No description provided for @sessionEarned.
  ///
  /// In en, this message translates to:
  /// **'{belt} earned'**
  String sessionEarned(String belt);

  /// No description provided for @sessionPromoted.
  ///
  /// In en, this message translates to:
  /// **'Promoted to {belt}'**
  String sessionPromoted(String belt);

  /// No description provided for @sessionStripeLost.
  ///
  /// In en, this message translates to:
  /// **'{belt}, one stripe lost'**
  String sessionStripeLost(String belt);

  /// No description provided for @sessionFading.
  ///
  /// In en, this message translates to:
  /// **'{belt} is fading'**
  String sessionFading(String belt);

  /// No description provided for @sessionXpAgainTomorrow.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP · again tomorrow'**
  String sessionXpAgainTomorrow(int xp);

  /// No description provided for @sessionXpNext.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP · next review in {days, plural, =1{1 day} other{{days} days}}'**
  String sessionXpNext(int xp, int days);

  /// No description provided for @sessionXpDone.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP · all planned reviews done'**
  String sessionXpDone(int xp);

  /// No description provided for @sessionPickRating.
  ///
  /// In en, this message translates to:
  /// **'Pick a rating to finish'**
  String get sessionPickRating;

  /// No description provided for @sessionDone.
  ///
  /// In en, this message translates to:
  /// **'Done · back to Today'**
  String get sessionDone;

  /// No description provided for @sessionClosed.
  ///
  /// In en, this message translates to:
  /// **'This session is already closed.'**
  String get sessionClosed;

  /// No description provided for @sessionBackToToday.
  ///
  /// In en, this message translates to:
  /// **'Back to Today'**
  String get sessionBackToToday;

  /// No description provided for @sessionLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave without rating'**
  String get sessionLeave;

  /// No description provided for @sessionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again.'**
  String get sessionSaveFailed;

  /// No description provided for @sessionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this session.'**
  String get sessionLoadFailed;

  /// No description provided for @sessionOpenFirst.
  ///
  /// In en, this message translates to:
  /// **'Finish your open session first.'**
  String get sessionOpenFirst;

  /// No description provided for @sessionNotOpened.
  ///
  /// In en, this message translates to:
  /// **'Session started. Study it anywhere, then come back to rate it.'**
  String get sessionNotOpened;

  /// No description provided for @sessionRatingSemantics.
  ///
  /// In en, this message translates to:
  /// **'{rating}, {next}'**
  String sessionRatingSemantics(String rating, String next);

  /// No description provided for @todayStreak.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{day streak} other{day streak}}'**
  String todayStreak(int days);

  /// No description provided for @todayStreakSemantics.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{No streak yet} =1{1 day streak} other{{days} day streak}}'**
  String todayStreakSemantics(int days);

  /// No description provided for @todayExamLine.
  ///
  /// In en, this message translates to:
  /// **'{name} · {date}'**
  String todayExamLine(String name, String date);

  /// No description provided for @todayDaysToGo.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Exam day} =1{1 day to go} other{{days} days to go}}'**
  String todayDaysToGo(int days);

  /// No description provided for @todaySessions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session · {time}} other{{count} sessions · {time}}}'**
  String todaySessions(int count, String time);

  /// No description provided for @todayKindReview.
  ///
  /// In en, this message translates to:
  /// **'REVIEW · {time}'**
  String todayKindReview(String time);

  /// No description provided for @todayKindOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{OVERDUE 1 DAY · {time}} other{OVERDUE {days} DAYS · {time}}}'**
  String todayKindOverdue(int days, String time);

  /// No description provided for @todayKindFirstRead.
  ///
  /// In en, this message translates to:
  /// **'FIRST READ · {time}'**
  String todayKindFirstRead(String time);

  /// No description provided for @todayKindReviewWord.
  ///
  /// In en, this message translates to:
  /// **'review'**
  String get todayKindReviewWord;

  /// No description provided for @todayKindFirstReadWord.
  ///
  /// In en, this message translates to:
  /// **'first read'**
  String get todayKindFirstReadWord;

  /// No description provided for @todayEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to train yet'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a PDF, book, video or link, then turn its chapters into tasks.'**
  String get todayEmptyBody;

  /// No description provided for @todayAddSource.
  ///
  /// In en, this message translates to:
  /// **'Add a source'**
  String get todayAddSource;

  /// No description provided for @todayDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All done for today'**
  String get todayDoneTitle;

  /// No description provided for @todayDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing else is due. Any task can be reviewed early from its page.'**
  String get todayDoneBody;

  /// No description provided for @todayLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load today\'s training.'**
  String get todayLoadFailed;

  /// No description provided for @todayRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get todayRetry;

  /// No description provided for @taskOverline.
  ///
  /// In en, this message translates to:
  /// **'TASK'**
  String get taskOverline;

  /// No description provided for @taskImportanceLine.
  ///
  /// In en, this message translates to:
  /// **'{importance} importance · {exam}'**
  String taskImportanceLine(String importance, String exam);

  /// No description provided for @taskLevelLine.
  ///
  /// In en, this message translates to:
  /// **'Level {level} of 7'**
  String taskLevelLine(int level);

  /// No description provided for @taskLevelTargetLine.
  ///
  /// In en, this message translates to:
  /// **'Level {level} of 7 · target {target}'**
  String taskLevelTargetLine(int level, String target);

  /// No description provided for @taskSteps.
  ///
  /// In en, this message translates to:
  /// **'{done} of {planned} reviews done'**
  String taskSteps(int done, int planned);

  /// No description provided for @taskDueToday.
  ///
  /// In en, this message translates to:
  /// **'Review due today'**
  String get taskDueToday;

  /// No description provided for @taskOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Overdue 1 day · the belt is fading} other{Overdue {days} days · the belt is fading}}'**
  String taskOverdue(int days);

  /// No description provided for @taskNextOn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Next review {date} · tomorrow} other{Next review {date} · in {days} days}}'**
  String taskNextOn(String date, int days);

  /// No description provided for @taskNotStartedLine.
  ///
  /// In en, this message translates to:
  /// **'Not started · first read about {time}'**
  String taskNotStartedLine(String time);

  /// No description provided for @taskAllDone.
  ///
  /// In en, this message translates to:
  /// **'All reviews done · review any time to keep it fresh'**
  String get taskAllDone;

  /// No description provided for @taskPausedSince.
  ///
  /// In en, this message translates to:
  /// **'Paused since {date}'**
  String taskPausedSince(String date);

  /// No description provided for @taskStartReview.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get taskStartReview;

  /// No description provided for @taskReviewEarly.
  ///
  /// In en, this message translates to:
  /// **'Review early'**
  String get taskReviewEarly;

  /// No description provided for @taskReviewEarlyHint.
  ///
  /// In en, this message translates to:
  /// **'Counts like any review.'**
  String get taskReviewEarlyHint;

  /// No description provided for @taskStartFirstRead.
  ///
  /// In en, this message translates to:
  /// **'Start first read'**
  String get taskStartFirstRead;

  /// No description provided for @taskCovers.
  ///
  /// In en, this message translates to:
  /// **'Covers'**
  String get taskCovers;

  /// No description provided for @taskHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get taskHistory;

  /// No description provided for @taskNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. The first read earns White.'**
  String get taskNoReviews;

  /// No description provided for @taskKindFirstRead.
  ///
  /// In en, this message translates to:
  /// **'First read'**
  String get taskKindFirstRead;

  /// No description provided for @taskKindReview.
  ///
  /// In en, this message translates to:
  /// **'Review {n}'**
  String taskKindReview(int n);

  /// No description provided for @taskKindRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get taskKindRetry;

  /// No description provided for @taskPromotedTo.
  ///
  /// In en, this message translates to:
  /// **'→ {belt}'**
  String taskPromotedTo(String belt);

  /// No description provided for @taskPromotedSemantics.
  ///
  /// In en, this message translates to:
  /// **'promoted to {belt}'**
  String taskPromotedSemantics(String belt);

  /// No description provided for @taskHistorySemantics.
  ///
  /// In en, this message translates to:
  /// **'{date}, {kind}, rated {rating}, {time}'**
  String taskHistorySemantics(
    String date,
    String kind,
    String rating,
    String time,
  );

  /// No description provided for @taskShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all {count}'**
  String taskShowAll(int count);

  /// No description provided for @taskRemoved.
  ///
  /// In en, this message translates to:
  /// **'This task was removed.'**
  String get taskRemoved;

  /// No description provided for @taskBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get taskBack;

  /// No description provided for @taskLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this task.'**
  String get taskLoadFailed;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s training is ready'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'A few minutes keeps your belts bright.'**
  String get reminderBody;

  /// No description provided for @reminderChannel.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderChannel;

  /// No description provided for @todayKindFinalReview.
  ///
  /// In en, this message translates to:
  /// **'FINAL REVIEW · {time}'**
  String todayKindFinalReview(String time);

  /// No description provided for @todayKindExplore.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE READING · {time}'**
  String todayKindExplore(String time);

  /// No description provided for @todayKindExploreWord.
  ///
  /// In en, this message translates to:
  /// **'reading'**
  String get todayKindExploreWord;

  /// No description provided for @examDateLine.
  ///
  /// In en, this message translates to:
  /// **'{date} · {days, plural, =0{exam day} =1{1 day left} other{{days} days left}}'**
  String examDateLine(String date, int days);

  /// No description provided for @examBeltToday.
  ///
  /// In en, this message translates to:
  /// **'Exam belt today'**
  String get examBeltToday;

  /// No description provided for @examProjected.
  ///
  /// In en, this message translates to:
  /// **'Projected {belt} by exam day'**
  String examProjected(String belt);

  /// No description provided for @examReady.
  ///
  /// In en, this message translates to:
  /// **'ready'**
  String get examReady;

  /// No description provided for @examAtTarget.
  ///
  /// In en, this message translates to:
  /// **'at target'**
  String get examAtTarget;

  /// No description provided for @examToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get examToday;

  /// No description provided for @examBeltSemantics.
  ///
  /// In en, this message translates to:
  /// **'Exam belt today {belt}, projected {projected} by exam day'**
  String examBeltSemantics(String belt, String projected);

  /// No description provided for @examWeakLinks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 weak link} other{{count} weak links}}'**
  String examWeakLinks(int count);

  /// No description provided for @examWeakHint.
  ///
  /// In en, this message translates to:
  /// **'high importance, below Yellow'**
  String get examWeakHint;

  /// No description provided for @examWeakNotStarted.
  ///
  /// In en, this message translates to:
  /// **'not started · first read {when}'**
  String examWeakNotStarted(String when);

  /// No description provided for @examWeakNotPlanned.
  ///
  /// In en, this message translates to:
  /// **'not started'**
  String get examWeakNotPlanned;

  /// No description provided for @examWeakNext.
  ///
  /// In en, this message translates to:
  /// **'{belt} · review {when}'**
  String examWeakNext(String belt, String when);

  /// No description provided for @examWhenToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get examWhenToday;

  /// No description provided for @examWhenTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get examWhenTomorrow;

  /// No description provided for @examActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get examActivity;

  /// No description provided for @examActivityHint.
  ///
  /// In en, this message translates to:
  /// **'study minutes per day'**
  String get examActivityHint;

  /// No description provided for @examActivityLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get examActivityLess;

  /// No description provided for @examActivityMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get examActivityMore;

  /// No description provided for @examActivitySemantics.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No study in the last {weeks} weeks} =1{Studied on 1 day in the last {weeks} weeks} other{Studied on {count} days in the last {weeks} weeks}}'**
  String examActivitySemantics(int count, int weeks);

  /// No description provided for @examPlanTight.
  ///
  /// In en, this message translates to:
  /// **'Not everything fits before the exam. Add study time each day to fit it all.'**
  String get examPlanTight;

  /// No description provided for @examsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No exam yet'**
  String get examsEmptyTitle;

  /// No description provided for @examsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your exam to get a day-by-day plan.'**
  String get examsEmptyBody;

  /// No description provided for @examsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add exam'**
  String get examsAdd;

  /// No description provided for @examLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this exam.'**
  String get examLoadFailed;

  /// No description provided for @addExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Add exam'**
  String get addExamTitle;

  /// No description provided for @addExamName.
  ///
  /// In en, this message translates to:
  /// **'Exam name'**
  String get addExamName;

  /// No description provided for @addExamDate.
  ///
  /// In en, this message translates to:
  /// **'Exam date'**
  String get addExamDate;

  /// No description provided for @addExamChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get addExamChooseDate;

  /// No description provided for @addExamDaysFrom.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Tomorrow} other{{days} days from today}}'**
  String addExamDaysFrom(int days);

  /// No description provided for @addExamTime.
  ///
  /// In en, this message translates to:
  /// **'Time each day'**
  String get addExamTime;

  /// No description provided for @addExamTimeHint.
  ///
  /// In en, this message translates to:
  /// **'The same every day for now. Set each weekday on the exam screen.'**
  String get addExamTimeHint;

  /// No description provided for @addExamTasks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Tasks you add will count toward this exam.} =1{Your 1 task will count toward this exam as Medium. Set importance in each source\'s survey.} other{Your {count} tasks will count toward this exam as Medium. Set importance in each source\'s survey.}}'**
  String addExamTasks(int count);

  /// No description provided for @addExamNameMissing.
  ///
  /// In en, this message translates to:
  /// **'Give the exam a name'**
  String get addExamNameMissing;

  /// No description provided for @addExamSave.
  ///
  /// In en, this message translates to:
  /// **'Add exam'**
  String get addExamSave;

  /// No description provided for @addExamFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again.'**
  String get addExamFailed;

  /// No description provided for @addExamLess.
  ///
  /// In en, this message translates to:
  /// **'Less time'**
  String get addExamLess;

  /// No description provided for @addExamMore.
  ///
  /// In en, this message translates to:
  /// **'More time'**
  String get addExamMore;

  /// No description provided for @triageTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan trimmed to fit'**
  String get triageTitle;

  /// No description provided for @triageBody.
  ///
  /// In en, this message translates to:
  /// **'The least important work was cut first. Keep any task in full and the plan cuts something else.'**
  String get triageBody;

  /// No description provided for @triageStepDropFinalLow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Final review dropped · 1 Low task} other{Final review dropped · {count} Low tasks}}'**
  String triageStepDropFinalLow(int count);

  /// No description provided for @triageStepLowToYellow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Aim for Yellow · 1 Low task} other{Aim for Yellow · {count} Low tasks}}'**
  String triageStepLowToYellow(int count);

  /// No description provided for @triageStepSkim.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Skim instead of read · 1 easy Low task} other{Skim instead of read · {count} easy Low tasks}}'**
  String triageStepSkim(int count);

  /// No description provided for @triageStepLowerMedium.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One belt lower · 1 Medium task} other{One belt lower · {count} Medium tasks}}'**
  String triageStepLowerMedium(int count);

  /// No description provided for @triageDroppedRow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Dropped by you · 1 task} other{Dropped by you · {count} tasks}}'**
  String triageDroppedRow(int count);

  /// No description provided for @triageKeepAction.
  ///
  /// In en, this message translates to:
  /// **'Keep {title} in full'**
  String triageKeepAction(String title);

  /// No description provided for @triageRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore {title}'**
  String triageRestoreAction(String title);

  /// No description provided for @triageDropAction.
  ///
  /// In en, this message translates to:
  /// **'Drop {title}'**
  String triageDropAction(String title);

  /// No description provided for @triageKeepTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep {title} in full?'**
  String triageKeepTitle(String title);

  /// No description provided for @triageKeepNext.
  ///
  /// In en, this message translates to:
  /// **'To make room, the plan also cuts:'**
  String get triageKeepNext;

  /// No description provided for @triageKeepNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing else needs to change.'**
  String get triageKeepNothing;

  /// No description provided for @triageKeepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get triageKeepConfirm;

  /// No description provided for @triageCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get triageCancel;

  /// No description provided for @triageNeedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Still doesn\'t fit'**
  String get triageNeedsTitle;

  /// No description provided for @triageNeedsReduced.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} more minutes a day keeps this reduced plan.'**
  String triageNeedsReduced(int minutes);

  /// No description provided for @triageNeedsFull.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} more keeps everything.'**
  String triageNeedsFull(int minutes);

  /// No description provided for @triageNeedsNoTime.
  ///
  /// In en, this message translates to:
  /// **'More time alone can\'t fit it. Drop some tasks, or accept a lower belt.'**
  String get triageNeedsNoTime;

  /// No description provided for @triageAddMinutes.
  ///
  /// In en, this message translates to:
  /// **'Add {minutes} min a day'**
  String triageAddMinutes(int minutes);

  /// No description provided for @triageDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop tasks'**
  String get triageDrop;

  /// No description provided for @triageDropTitle.
  ///
  /// In en, this message translates to:
  /// **'Drop a task from the plan'**
  String get triageDropTitle;

  /// No description provided for @triageAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept a lower belt'**
  String get triageAccept;

  /// No description provided for @triageAccepted.
  ///
  /// In en, this message translates to:
  /// **'Reduced plan accepted. You can still add time or drop tasks.'**
  String get triageAccepted;

  /// No description provided for @triageReview.
  ///
  /// In en, this message translates to:
  /// **'Review cuts in {step}'**
  String triageReview(String step);

  /// No description provided for @examStudyTime.
  ///
  /// In en, this message translates to:
  /// **'Study time'**
  String get examStudyTime;

  /// No description provided for @weekEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day · {time}'**
  String weekEveryDay(String time);

  /// No description provided for @weekOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get weekOff;

  /// No description provided for @weekSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Study time each day'**
  String get weekSheetTitle;

  /// No description provided for @weekSheetHint.
  ///
  /// In en, this message translates to:
  /// **'The plan uses these from today. A day off is planned around.'**
  String get weekSheetHint;

  /// No description provided for @weekSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get weekSave;

  /// No description provided for @weekLess.
  ///
  /// In en, this message translates to:
  /// **'Less time on {day}'**
  String weekLess(String day);

  /// No description provided for @weekMore.
  ///
  /// In en, this message translates to:
  /// **'More time on {day}'**
  String weekMore(String day);

  /// No description provided for @todayReady.
  ///
  /// In en, this message translates to:
  /// **'{percent}% ready'**
  String todayReady(int percent);

  /// No description provided for @todayOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track for {belt} by exam day'**
  String todayOnTrack(String belt);

  /// No description provided for @redefineTitle.
  ///
  /// In en, this message translates to:
  /// **'Redefine task'**
  String get redefineTitle;

  /// No description provided for @redefineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress and review history are never lost.'**
  String get redefineSubtitle;

  /// No description provided for @redefineEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get redefineEdit;

  /// No description provided for @redefineScope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get redefineScope;

  /// No description provided for @redefineSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get redefineSplit;

  /// No description provided for @redefinePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get redefinePause;

  /// No description provided for @redefineResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get redefineResume;

  /// No description provided for @redefineWhatHappens.
  ///
  /// In en, this message translates to:
  /// **'WHAT HAPPENS'**
  String get redefineWhatHappens;

  /// No description provided for @redefineCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get redefineCancel;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editName;

  /// No description provided for @editImportance.
  ///
  /// In en, this message translates to:
  /// **'Importance for {exam}'**
  String editImportance(String exam);

  /// No description provided for @editImpact.
  ///
  /// In en, this message translates to:
  /// **'Target {belt} · {count, plural, =1{1 review planned} other{{count} reviews planned}}'**
  String editImpact(String belt, int count);

  /// No description provided for @editNoChange.
  ///
  /// In en, this message translates to:
  /// **'Nothing changes for your belt or reviews.'**
  String get editNoChange;

  /// No description provided for @editSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get editSave;

  /// No description provided for @scopeFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get scopeFrom;

  /// No description provided for @scopeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get scopeTo;

  /// No description provided for @scopeShrink.
  ///
  /// In en, this message translates to:
  /// **'Keeps its belt and reviews.'**
  String get scopeShrink;

  /// No description provided for @scopeSame.
  ///
  /// In en, this message translates to:
  /// **'Change the range to see what happens.'**
  String get scopeSame;

  /// No description provided for @scopeAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {range}:'**
  String scopeAdded(String range);

  /// No description provided for @scopeGrowSplit.
  ///
  /// In en, this message translates to:
  /// **'Make it a new task'**
  String get scopeGrowSplit;

  /// No description provided for @scopeGrowKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep as one task'**
  String get scopeGrowKeep;

  /// No description provided for @scopeGrowSplitImpact.
  ///
  /// In en, this message translates to:
  /// **'The added pages start with a first read; this task keeps its belt.'**
  String get scopeGrowSplitImpact;

  /// No description provided for @scopeGrowKeepImpact.
  ///
  /// In en, this message translates to:
  /// **'The belt dims one step until the next Good review.'**
  String get scopeGrowKeepImpact;

  /// No description provided for @scopeSave.
  ///
  /// In en, this message translates to:
  /// **'Save scope'**
  String get scopeSave;

  /// No description provided for @scopeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scope works on a task with one chapter range.'**
  String get scopeUnavailable;

  /// No description provided for @splitDrag.
  ///
  /// In en, this message translates to:
  /// **'Drag to choose where to split'**
  String get splitDrag;

  /// No description provided for @splitAfter.
  ///
  /// In en, this message translates to:
  /// **'after {position}'**
  String splitAfter(String position);

  /// No description provided for @splitPart.
  ///
  /// In en, this message translates to:
  /// **'PART {letter} · {size}'**
  String splitPart(String letter, String size);

  /// No description provided for @splitPartName.
  ///
  /// In en, this message translates to:
  /// **'{title}, part {number}'**
  String splitPartName(String title, int number);

  /// No description provided for @splitKeep.
  ///
  /// In en, this message translates to:
  /// **'Both parts keep {belt}'**
  String splitKeep(String belt);

  /// No description provided for @splitStartFresh.
  ///
  /// In en, this message translates to:
  /// **'Both parts start with a first read'**
  String get splitStartFresh;

  /// No description provided for @splitNext.
  ///
  /// In en, this message translates to:
  /// **'Next reviews {a} and {b}'**
  String splitNext(String a, String b);

  /// No description provided for @splitUndoHint.
  ///
  /// In en, this message translates to:
  /// **'Undo anytime from the task\'s page'**
  String get splitUndoHint;

  /// No description provided for @splitApply.
  ///
  /// In en, this message translates to:
  /// **'Split into 2 tasks'**
  String get splitApply;

  /// No description provided for @splitUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Split needs a task with a page range of at least 2 pages.'**
  String get splitUnavailable;

  /// No description provided for @splitHandle.
  ///
  /// In en, this message translates to:
  /// **'Split after {position}'**
  String splitHandle(String position);

  /// No description provided for @pauseBody.
  ///
  /// In en, this message translates to:
  /// **'Pausing stops the belt from fading and takes the task out of the plan until you resume. Nothing is lost.'**
  String get pauseBody;

  /// No description provided for @pauseApply.
  ///
  /// In en, this message translates to:
  /// **'Pause task'**
  String get pauseApply;

  /// No description provided for @resumeBody.
  ///
  /// In en, this message translates to:
  /// **'Resuming puts the task back in the plan. Its reviews move later by the time it was paused.'**
  String get resumeBody;

  /// No description provided for @resumeApply.
  ///
  /// In en, this message translates to:
  /// **'Resume task'**
  String get resumeApply;

  /// No description provided for @redefineSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get redefineSaved;

  /// No description provided for @redefineSplitDone.
  ///
  /// In en, this message translates to:
  /// **'Split into 2 tasks'**
  String get redefineSplitDone;

  /// No description provided for @redefineUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get redefineUndo;

  /// No description provided for @redefineFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again.'**
  String get redefineFailed;

  /// No description provided for @taskUndoLast.
  ///
  /// In en, this message translates to:
  /// **'Undo last change'**
  String get taskUndoLast;

  /// No description provided for @taskUndone.
  ///
  /// In en, this message translates to:
  /// **'Change undone'**
  String get taskUndone;

  /// No description provided for @taskMore.
  ///
  /// In en, this message translates to:
  /// **'Redefine task'**
  String get taskMore;

  /// No description provided for @taskPartOf.
  ///
  /// In en, this message translates to:
  /// **'Split from {title}'**
  String taskPartOf(String title);

  /// No description provided for @beltWithStripes.
  ///
  /// In en, this message translates to:
  /// **'{belt}, {stripes, plural, =0{no stripes} =1{1 stripe} other{{stripes} stripes}}'**
  String beltWithStripes(String belt, int stripes);

  /// No description provided for @beltWithFading.
  ///
  /// In en, this message translates to:
  /// **'{belt}, fading'**
  String beltWithFading(String belt);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
