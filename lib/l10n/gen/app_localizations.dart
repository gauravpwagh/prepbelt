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
