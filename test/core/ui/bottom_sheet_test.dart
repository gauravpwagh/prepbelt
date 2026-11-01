import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/ui/bottom_sheet.dart';
import 'package:prepbelt/theme/app_theme.dart';

void main() {
  testWidgets('a sheet page keeps its last row above the system '
      'navigation bar', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 800)
      ..devicePixelRatio = 1
      // Three-button navigation: 48 px at the bottom, 24 px status bar.
      ..padding = const FakeViewPadding(top: 24, bottom: 48)
      ..viewPadding = const FakeViewPadding(top: 24, bottom: 48);
    addTearDown(tester.view.reset);

    const button = Key('button');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Navigator(
          pages: const [
            MaterialPage<void>(child: Scaffold()),
            SheetPage<void>(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 200),
                  SizedBox(key: button, height: 52, width: 200),
                ],
              ),
            ),
          ],
          onDidRemovePage: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getBottomLeft(find.byKey(button)).dy,
      lessThanOrEqualTo(800 - 48),
    );
  });
}
