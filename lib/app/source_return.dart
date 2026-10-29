import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/session/state/session_providers.dart';
import '../features/sources/state/reading_providers.dart';
import '../features/today/state/reminder_providers.dart';
import '../features/today/ui/reminder_text.dart';
import '../l10n/gen/app_localizations.dart';
import 'router.dart';

/// Brings the student back to what they left PrepBelt for, when it starts
/// or returns to the foreground: "Back from source" for an open review
/// session (docs/05-architecture.md), or "How far did you get?" for an open
/// reading sitting (D27). Both are in the database, so this works even
/// after the OS closed the app.
class SourceReturn extends ConsumerStatefulWidget {
  const SourceReturn({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SourceReturn> createState() => _SourceReturnState();
}

class _SourceReturnState extends ConsumerState<SourceReturn>
    with WidgetsBindingObserver {
  bool _left = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        _left = true;
      case AppLifecycleState.resumed when _left:
        _left = false;
        unawaited(_check());
      default:
    }
  }

  Future<void> _check() async {
    if (mounted) {
      unawaited(
        ref
            .read(remindersProvider.notifier)
            .sync(reminderText(AppLocalizations.of(context))),
      );
    }
    final session = await ref.read(sessionRepositoryProvider).active();
    final target = session != null
        ? Routes.session(session.taskId)
        : await ref.read(readingRepositoryProvider).openSession() != null
        ? Routes.reading
        : null;
    if (target == null || !mounted) return;
    final router = ref.read(routerProvider);
    final here = router.routerDelegate.currentConfiguration.uri.path;
    if (here != target) await router.push(target);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
