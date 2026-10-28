/// Route paths from docs/05-architecture.md, plus `/exams` and `/progress`
/// for the Exams and Progress tabs, which the route list leaves out.
abstract final class Routes {
  static const today = '/today';
  static const exams = '/exams';
  static const progress = '/progress';
  static const sources = '/sources';
  static const newSource = '/sources/new';
  static const settings = '/settings';
  static const onboarding = '/onboarding';

  /// "How far did you get?" over the current screen (D27).
  static const reading = '/reading';

  static String session(String taskId) => '/session/$taskId';
  static String sourceChapters(String sourceId) => '/sources/$sourceId';
  static String survey(String sourceId) => '/sources/$sourceId/survey';
  static String exam(String id) => '/exams/$id';
  static String task(String id) => '/tasks/$id';
  static String redefine(String id) => '/tasks/$id/redefine';
}
