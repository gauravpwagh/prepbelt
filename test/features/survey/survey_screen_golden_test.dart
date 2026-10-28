@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/enums.dart';
import 'package:prepbelt/features/survey/state/survey_providers.dart';
import 'package:prepbelt/features/survey/ui/survey_screen.dart';

import '../../support/pump.dart';

/// The state of design/mockups/3-survey.html: HC Verma Vol 1, chapter 8
/// of 22 (Work and Energy, pp. 130–158), the first 7 surveyed with High,
/// Hard, Seen it.
SurveyView mockupView({bool withExam = true}) => SurveyView(
  sourceId: 's1',
  sourceTitle: 'HC Verma Vol 1',
  unitType: UnitType.page,
  examId: withExam ? 'e1' : null,
  examName: withExam ? 'JEE Main' : null,
  chapters: [
    for (var i = 1; i <= 22; i++)
      SurveyChapter(
        id: 'c$i',
        title: i == 8 ? 'Work and Energy' : 'Chapter $i',
        startUnit: i == 8 ? 130 : i * 10,
        endUnit: i == 8 ? 158 : i * 10 + 9,
        difficulty: i < 8 ? 3 : null,
        familiarity: i < 8 ? 1 : null,
        importance: i < 8 ? Importance.high : null,
      ),
  ],
);

Widget survey({bool withExam = true}) => ProviderScope(
  child: Scaffold(
    body: SafeArea(
      child: SurveyBody(
        view: mockupView(withExam: withExam),
        onDone: () {},
      ),
    ),
  ),
);

void main() {
  goldenBoth('survey_390', survey, height: 844);
  goldenBoth('survey_360', survey, width: 360, height: 780);
  goldenBoth('survey_no_exam', () => survey(withExam: false), height: 844);

  testWidgets('survey at 1.3x text size', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: themed(survey()),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/survey_text130_light.png'),
    );
  });
}
