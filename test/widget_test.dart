import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:allgoldrhythm/data/algorithm_data.dart';
import 'package:allgoldrhythm/data/fundamentals_data.dart';
import 'package:allgoldrhythm/data/system_design_data.dart';
import 'package:allgoldrhythm/main.dart';
import 'package:allgoldrhythm/models/system_design.dart';
import 'package:allgoldrhythm/screens/algorithm_detail_screen.dart';
import 'package:allgoldrhythm/screens/fundamental_detail_screen.dart';
import 'package:allgoldrhythm/screens/system_design_detail_screen.dart';
import 'package:allgoldrhythm/theme/app_theme.dart';

void main() {
  testWidgets('Home screen has two focus cards and navigates to the DSA list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('AllGoldRhythm'), findsWidgets);
    expect(find.text('Data Structures & Algorithms'), findsOneWidget);
    expect(find.text('System Design'), findsOneWidget);
    expect(find.text('Two Pointers'), findsNothing);

    await tester.tap(find.text('Data Structures & Algorithms'));
    await tester.pumpAndSettle();

    expect(find.text('Two Pointers'), findsOneWidget);
    await tester.tap(find.text('Two Pointers'));
    await tester.pumpAndSettle();

    expect(find.text('Simulation'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
  });

  testWidgets('Hamburger drawer links directly to both sections', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Both the drawer's ListTile and the home card behind it now share the
    // same label text, so scope the finders to the drawer's ListTiles.
    final dsaTile = find.widgetWithText(ListTile, 'Data Structures & Algorithms');
    final systemDesignTile = find.widgetWithText(ListTile, 'System Design');
    expect(dsaTile, findsOneWidget);
    expect(systemDesignTile, findsOneWidget);

    await tester.tap(systemDesignTile);
    await tester.pumpAndSettle();

    expect(find.text('Fundamentals'), findsOneWidget);
    expect(find.text('Practice Problems'), findsOneWidget);
  });

  testWidgets('Review tab walks through real algorithm steps with tap validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Data Structures & Algorithms'));
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

  testWidgets('Home screen has a System Design entry that opens fundamentals and practice problems', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('System Design'), findsOneWidget);
    await tester.tap(find.text('System Design'));
    await tester.pumpAndSettle();

    // Fundamentals tab is the default.
    expect(find.text('Fundamentals'), findsOneWidget);
    expect(find.text('DNS & Request Routing'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('CAP Theorem'),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('fundamentals_list')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('CAP Theorem'), findsOneWidget);

    await tester.tap(find.text('Practice Problems'));
    await tester.pumpAndSettle();

    expect(find.text('Design a URL Shortener'), findsOneWidget);
    expect(find.text('Design a Rate Limiter'), findsOneWidget);
  });

  testWidgets('Fundamentals detail screen renders theory, diagram, and key points', (WidgetTester tester) async {
    final concept = FundamentalsData.getConcepts().firstWhere((c) => c.diagram != null);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      home: FundamentalDetailScreen(concept: concept),
    ));
    await tester.pumpAndSettle();

    expect(find.text(concept.title), findsWidgets);
    expect(find.text(concept.summary), findsOneWidget);
    for (final point in concept.keyPoints) {
      await tester.scrollUntilVisible(
        find.text(point),
        300,
        scrollable: find.descendant(
          of: find.byKey(const Key('fundamental_detail_list')),
          matching: find.byType(Scrollable),
        ).first,
      );
      expect(find.text(point), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  for (final problem in SystemDesignData.getProblems()) {
    testWidgets('${problem.title}: requirements render and design canvas is usable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: SystemDesignDetailScreen(problem: problem),
      ));
      await tester.pumpAndSettle();

      // Requirements tab (default) should show every section.
      expect(find.text(problem.prompt), findsOneWidget);
      for (final req in problem.functionalRequirements) {
        expect(find.text(req), findsOneWidget);
      }
      expect(find.text(problem.highLevelDesign), findsOneWidget);

      await tester.tap(find.text('Design Canvas'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // The palette is a lazily-built horizontal ListView in test
      // environments, so only chips within the initial viewport are
      // guaranteed to exist; just confirm the first one renders.
      expect(find.text(ComponentType.client.label), findsWidgets);

      // Nothing placed yet — "Check Design" should be disabled, so tapping
      // it is a no-op and no result panel should appear.
      await tester.tap(find.text('Check Design'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Missing components'), findsNothing);

      // "Show Solution" reveals the reference architecture, listing every
      // component and connection defined for this problem.
      await tester.tap(find.text('Show Solution'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (final component in problem.reference.components.toSet()) {
        expect(find.text(component.label), findsWidgets);
      }
      for (final pair in problem.reference.connections) {
        expect(find.text('${pair.$1.label} → ${pair.$2.label}'), findsOneWidget);
      }
    });
  }

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
