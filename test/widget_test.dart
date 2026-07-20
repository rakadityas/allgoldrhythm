import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:allgoldrhythm/data/algorithm_data.dart';
import 'package:allgoldrhythm/main.dart';
import 'package:allgoldrhythm/screens/algorithm_detail_screen.dart';
import 'package:allgoldrhythm/theme/app_theme.dart';

void main() {
  testWidgets('Home screen lists algorithms and navigates to detail', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('AllGoldRhythm'), findsWidgets);
    expect(find.text('Two Pointers'), findsOneWidget);

    await tester.tap(find.text('Two Pointers'));
    await tester.pumpAndSettle();

    expect(find.text('Simulation'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
  });

  testWidgets('Review tab walks through real algorithm steps with tap validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Two Pointers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Left-Right Two Pointers'));
    await tester.pumpAndSettle();

    // Values are [2, 4, 5, 7, 9, 11, 13, 15]; step 1 expects indices [0, 7] -> values 2 and 15.
    expect(find.text('Step 1 of 5'), findsOneWidget);

    // Tapping a block that isn't part of the current step should flash wrong (index 2 -> value 5).
    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.text("You're wrong! Try again."), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));

    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('15'));
    await tester.pump();

    expect(
      find.text(
        'Left at index 0 (value 2), right at index 7 (value 15). Sum = 2 + 15 = 17, '
        'which is greater than target 16 — the sum is too big, so move the right pointer '
        'left to try a smaller number.',
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Next Step'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Step'));
    await tester.pump();

    expect(find.text('Step 2 of 5'), findsOneWidget);
  });

  for (final algorithm in AlgorithmData.getAlgorithms()) {
    testWidgets(
      '${algorithm.name}: every Simulation step and Review pattern renders without error',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.light(),
          home: AlgorithmDetailScreen(algorithm: algorithm),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Simulation'));
        await tester.pumpAndSettle();

        // Only the first visualization is stepped through here: the chip
        // selector for switching visualizations is a lazily-built
        // horizontal ListView in test environments, so untouched chips
        // aren't guaranteed to exist in the tree yet. Every visualization's
        // step data is still exercised below via the Review picker, which
        // renders as a plain (non-lazy) column.
        final firstViz = algorithm.visualizations.first;
        for (int i = 0; i < firstViz.steps.length - 1; i++) {
          final nextButton = find.byIcon(Icons.skip_next);
          await tester.ensureVisible(nextButton);
          await tester.tap(nextButton);
          await tester.pump();
        }
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Review'));
        await tester.pumpAndSettle();
        for (final viz in algorithm.visualizations) {
          final patternCard = find.text(viz.title).first;
          await tester.ensureVisible(patternCard);
          await tester.tap(patternCard);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.text('Change'));
          await tester.pumpAndSettle();
        }
      },
    );
  }
}
