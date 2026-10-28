import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/sources/state/reading_providers.dart';
import 'router.dart';

/// Opens "How far did you get?" when PrepBelt starts or comes back to the
/// foreground with a reading sitting open (D27). The sitting is in the
/// database, so this works even after the OS closed the app.
class ReadingReturn extends ConsumerStatefulWidget {
  const ReadingReturn({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ReadingReturn> createState() => _ReadingReturnState();
}

class _ReadingReturnState extends ConsumerState<ReadingReturn>
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
    final open = await ref.read(readingRepositoryProvider).openSession();
    if (open == null || !mounted) return;
    final router = ref.read(routerProvider);
    final here = router.routerDelegate.currentConfiguration.uri.path;
    if (here != Routes.reading) await router.push(Routes.reading);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
