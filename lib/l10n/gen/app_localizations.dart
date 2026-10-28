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
