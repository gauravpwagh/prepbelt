import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/sources/state/source_providers.dart';
import '../platform/share_in/share_in.dart';
import 'router.dart';

/// Opens Add source pre-filled when a PDF or link is shared into PrepBelt:
/// the share that launched the app, then each one that arrives while it
/// runs (docs/05-architecture.md, "Share into the app").
class ShareReceiver extends ConsumerStatefulWidget {
  const ShareReceiver({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ShareReceiver> createState() => _ShareReceiverState();
}

class _ShareReceiverState extends ConsumerState<ShareReceiver> {
  StreamSubscription<SharedItem>? _sub;

  @override
  void initState() {
    super.initState();
    final inbox = ref.read(shareInboxProvider);
    _sub = inbox.incoming.listen(_open);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final first = await inbox.initial();
      if (first != null) await _open(first);
    });
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  Future<void> _open(SharedItem item) async {
    if (!mounted) return;
    unawaited(ref.read(shareInboxProvider).handled());
    await ref.read(routerProvider).push(Routes.newSource, extra: item);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
