import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/onboarding/state/onboarding_providers.dart';
import 'router.dart';

/// Sends a fresh install to first launch (`/onboarding`) once, on start
/// (docs/05-architecture.md, "Routes").
class OnboardingGate extends ConsumerStatefulWidget {
  const OnboardingGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends ConsumerState<OnboardingGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_check()));
  }

  Future<void> _check() async {
    final needed = await ref.read(onboardingProvider.notifier).needed();
    if (!needed || !mounted) return;
    ref.read(routerProvider).go(Routes.onboarding);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
