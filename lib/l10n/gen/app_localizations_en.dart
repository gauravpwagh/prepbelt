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
}
