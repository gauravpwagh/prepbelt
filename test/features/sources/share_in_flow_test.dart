import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/router.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../../support/test_db.dart';

class _Inbox implements ShareInbox {
  _Inbox(this.first);

  final SharedItem? first;
  // Closed at the end of the test.
  // ignore: close_sinks
  final controller = StreamController<SharedItem>.broadcast();
  int handledCount = 0;

  @override
  Future<SharedItem?> initial() async => first;

  @override
  Stream<SharedItem> get incoming => controller.stream;

  @override
  Future<void> handled() async => handledCount++;
}

void main() {
  testWidgets('a shared link opens Add source pre-filled, cold or warm', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final t = openTestContext();
    final inbox = _Inbox(
      const SharedLink('https://youtu.be/x9', title: 'Rotational motion'),
    );
    Future<void> settle() async {
      for (var i = 0; i < 3; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pumpAndSettle();
      }
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(t.clock),
          appDatabaseProvider.overrideWithValue(t.db),
          writeContextProvider.overrideWithValue(t.ctx),
          shareInboxProvider.overrideWithValue(inbox),
          reminderSchedulerProvider.overrideWithValue(const NoReminders()),
          routerProvider.overrideWithValue(buildRouter()),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle();

    // Cold start: the share that launched the app.
    expect(find.text('Add source'), findsOneWidget);
    expect(find.text('https://youtu.be/x9'), findsOneWidget);
    expect(find.text('Rotational motion'), findsOneWidget);
    expect(inbox.handledCount, 1);

    await tester.tap(find.text('Save'));
    await settle();
    expect(find.text('Rotational motion'), findsWidgets);
    final saved = await tester.runAsync(
      () => t.db.select(t.db.sources).getSingle(),
    );
    expect((saved!.type, saved.uri), (SourceType.link, 'https://youtu.be/x9'));

    // Warm: a share while the app runs opens a fresh Add source.
    inbox.controller.add(const SharedLink('https://example.org/k'));
    await settle();
    expect(find.text('https://example.org/k'), findsOneWidget);
    expect(inbox.handledCount, 2);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(t.db.close);
    await inbox.controller.close();
  });
}
