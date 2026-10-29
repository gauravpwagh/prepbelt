import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/ui/bottom_sheet.dart';
import '../core/ui/nav_bar.dart';
import '../core/ui/placeholder_screen.dart';
import '../features/exams/ui/add_exam_screen.dart';
import '../features/exams/ui/exam_screen.dart';
import '../features/session/ui/session_screen.dart';
import '../features/settings/ui/settings_screen.dart';
import '../features/sources/ui/add_source_screen.dart';
import '../features/sources/ui/reading_sheet.dart';
import '../features/sources/ui/source_chapters_screen.dart';
import '../features/sources/ui/sources_screen.dart';
import '../features/survey/ui/survey_screen.dart';
import '../features/tasks/ui/task_detail_screen.dart';
import '../features/today/ui/today_screen.dart';
import '../l10n/gen/app_localizations.dart';
import '../platform/share_in/share_in.dart';
import 'routes.dart';

export 'routes.dart';

part 'router.g.dart';

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
          StatefulShellBranch(routes: [tab(Routes.exams, const ExamsTab())]),
          StatefulShellBranch(
            routes: [tab(Routes.sources, const SourcesScreen())],
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
        builder: (_, state) =>
            AddSourceScreen(shared: state.extra as SharedItem?),
      ),
      GoRoute(
        path: '/sources/:id',
        builder: (_, state) =>
            SourceChaptersScreen(sourceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.reading,
        pageBuilder: (_, state) =>
            SheetPage<void>(key: state.pageKey, child: const ReadingSheet()),
      ),
      GoRoute(
        path: '/sources/:id/survey',
        builder: (_, state) =>
            SurveyScreen(sourceId: state.pathParameters['id']!),
      ),
      GoRoute(path: Routes.newExam, builder: (_, _) => const AddExamScreen()),
      GoRoute(
        path: '/exams/:id',
        builder: (_, state) => ExamScreen(examId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/session/:taskId',
        builder: (_, state) =>
            SessionScreen(taskId: state.pathParameters['taskId']!),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (_, state) =>
            TaskDetailScreen(taskId: state.pathParameters['id']!),
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
