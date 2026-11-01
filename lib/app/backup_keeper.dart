import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/state/auto_backup.dart';
import '../features/sources/state/study_files.dart';

/// Keeps the study folder current (D51): when the app starts and each
/// time it goes to the background, moves any files still in app storage
/// into the folder, then writes an automatic backup if one is due.
class BackupKeeper extends ConsumerStatefulWidget {
  const BackupKeeper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<BackupKeeper> createState() => _BackupKeeperState();
}

class _BackupKeeperState extends ConsumerState<BackupKeeper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_keep()));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) unawaited(_keep());
  }

  @override
  Widget build(BuildContext context) => widget.child;

  Future<void> _keep() async {
    if (!mounted) return;
    final files = ref.read(studyFilesProvider.notifier);
    final backup = ref.read(autoBackupProvider.notifier);
    try {
      await files.tidy();
    } on Object {
      // Files that cannot move stay where they are.
    }
    await backup.maybeRun();
  }
}
