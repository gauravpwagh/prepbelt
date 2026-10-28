import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/l10n/gen/app_localizations.dart';
import 'package:prepbelt/theme/app_theme.dart';

/// Wraps [child] in the app theme and localisations.
Widget themed(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light
          ? AppTheme.light()
          : AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        ),
      ),
    );

/// Renders [child] at [width] in light and dark mode and compares each with
/// `goldens/<name>_<mode>.png`.
void goldenBoth(
  String name,
  Widget Function() child, {
  double width = 390,
  double height = 300,
}) {
  for (final b in Brightness.values) {
    final mode = b == Brightness.light ? 'light' : 'dark';
    testWidgets('$name ($mode)', (tester) async {
      tester.view
        ..physicalSize = Size(width, height)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(themed(child(), brightness: b));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${name}_$mode.png'),
      );
    });
  }
}
