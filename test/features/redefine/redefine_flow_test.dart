import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/router.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../../support/test_db.dart';

void main() {
  testWidgets('Task detail → Redefine → Split → part A; undo brings the '
      'original back', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1300)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
    late String taskId;
    await tester.runAsync(() async {
      final s = await SourceRepository(t.ctx).createWithChunks(
        type: SourceType.book,
        title: 'HC Verma Vol 2',
        unitType: UnitType.page,
        totalUnits: 300,
        chapters: const [
          ChunkDraft(title: 'Thermodynamics', startUnit: 210, endUnit: 228),
        ],
      );
      await SurveyRepository(t.ctx).createTasks(s.id);
      taskId = (await t.db.select(t.db.tasks).getSingle()).id;
      await ReviewRepository(
        t.ctx,
        config: () async => const ReviewConfig(),
      ).record(taskId: taskId, rating: Rating.good, kind: ReviewKind.firstRead);
    });

    Future<void> settle() async {
      for (var i = 0; i < 4; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 60)),
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
          shareInboxProvider.overrideWithValue(const NoShareInbox()),
          reminderSchedulerProvider.overrideWithValue(const NoReminders()),
          routerProvider.overrideWithValue(
            buildRouter(initialLocation: Routes.task(taskId)),
          ),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle();
    expect(find.text('Thermodynamics'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Redefine task'));
    await settle();
    expect(find.text('Drag to choose where to split'), findsOneWidget);
    expect(find.text('after p. 219'), findsOneWidget);

    await tester.tap(find.text('Split into 2 tasks'));
    await settle();
    expect(find.text('Split into 2 tasks'), findsOneWidget, reason: 'snackbar');
    expect(find.text('Thermodynamics, part 1'), findsWidgets);
    expect(find.text('pp. 210–219'), findsOneWidget);
    expect(find.text('Undo last change'), findsOneWidget);

    var tasks = await tester.runAsync(
      () => (t.db.select(t.db.tasks)..where((x) => x.deletedAt.isNull())).get(),
    );
    expect(tasks!.where((x) => x.status == TaskStatus.active), hasLength(2));

    await tester.tap(find.text('Undo last change'));
    await settle();
    tasks = await tester.runAsync(
      () => (t.db.select(t.db.tasks)..where((x) => x.deletedAt.isNull())).get(),
    );
    expect(tasks!.map((x) => (x.id, x.status)), [(taskId, TaskStatus.active)]);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 60)),
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.runAsync(t.db.close);
  });
}
