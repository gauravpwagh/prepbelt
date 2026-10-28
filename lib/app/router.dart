import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/ui/nav_bar.dart';
import '../core/ui/placeholder_screen.dart';
import '../features/settings/ui/settings_screen.dart';
import '../features/today/ui/today_screen.dart';
import '../l10n/gen/app_localizations.dart';

part 'router.g.dart';

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

  static String session(String taskId) => '/session/$taskId';
  static String survey(String sourceId) => '/sources/$sourceId/survey';
  static String exam(String id) => '/exams/$id';
  static String task(String id) => '/tasks/$id';
  static String redefine(String id) => '/tasks/$id/redefine';
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) => buildRouter();

/// The app's routes. First-launch and active-session redirects arrive with
/// onboarding (milestone 6) and the return flow (milestone 4).
GoRouter buildRouter({String initialLocation = Routes.today}) {
  Widget placeholder(String Function(AppLocalizations l) title) => Builder(
    builder: (context) => Scaffold(
      body: PlaceholderScreen(
        title: title(AppLocalizations.of(context)),
        showBack: true,
      ),
    ),
  );

  GoRoute tab(
    String path,
    Widget screen, {
    List<RouteBase> routes = const [],
  }) => GoRoute(
    path: path,
    pageBuilder: (context, state) => NoTransitionPage(child: screen),
    routes: routes,
  );

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => Routes.today),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _Shell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [tab(Routes.today, const TodayScreen())]),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.exams,
                Builder(
                  builder: (context) => PlaceholderScreen(
                    title: AppLocalizations.of(context).screenExams,
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.sources,
                Builder(
                  builder: (context) => PlaceholderScreen(
                    title: AppLocalizations.of(context).screenSources,
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.progress,
                Builder(
                  builder: (context) => PlaceholderScreen(
                    title: AppLocalizations.of(context).screenProgress,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/sources/new',
        builder: (_, _) => placeholder((l) => l.screenAddSource),
      ),
      GoRoute(
        path: '/sources/:id/survey',
        builder: (_, _) => placeholder((l) => l.screenSurvey),
      ),
      GoRoute(
        path: '/exams/:id',
        builder: (_, _) => placeholder((l) => l.screenExam),
      ),
      GoRoute(
        path: '/session/:taskId',
        builder: (_, _) => placeholder((l) => l.screenSession),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (_, _) => placeholder((l) => l.screenTask),
        routes: [
          GoRoute(
            path: 'redefine',
            builder: (_, _) => placeholder((l) => l.screenRedefine),
          ),
        ],
      ),
      GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => placeholder((l) => l.screenOnboarding),
      ),
    ],
  );
}

class _Shell extends StatelessWidget {
  const _Shell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: AppNavBar(
      currentIndex: shell.currentIndex,
      onSelect: (i) =>
          shell.goBranch(i, initialLocation: i == shell.currentIndex),
      onAdd: () => context.push(Routes.newSource),
    ),
  );
}
