import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:allgoldrhythm/data/algorithm_data.dart';
import 'package:allgoldrhythm/data/algorithm_python_examples.dart';
import 'package:allgoldrhythm/data/fundamentals_data.dart';
import 'package:allgoldrhythm/data/fundamentals_quiz_data.dart';
import 'package:allgoldrhythm/data/system_design_data.dart';
import 'package:allgoldrhythm/main.dart';
import 'package:allgoldrhythm/models/system_design.dart';
import 'package:allgoldrhythm/screens/algorithm_detail_screen.dart';
import 'package:allgoldrhythm/screens/fundamental_detail_screen.dart';
import 'package:allgoldrhythm/screens/fundamentals_list_screen.dart';
import 'package:allgoldrhythm/screens/system_design_detail_screen.dart';
import 'package:allgoldrhythm/services/progress_store.dart';
import 'package:allgoldrhythm/theme/app_theme.dart';

/// Every screen now reads a [ProgressStore] from the widget tree (for quiz
/// score badges/progress summaries), which itself is backed by
/// [SharedPreferences]. Tests get a fresh, empty, in-memory-mocked instance
/// each time so results from one test never leak into another.
Future<ProgressStore> _freshProgressStore() async {
  SharedPreferences.setMockInitialValues({});
  return ProgressStore.create();
}

/// Wraps [child] in the same [ChangeNotifierProvider] the real app provides
/// via [MyApp], for tests that pump a bare screen instead of the full app.
Widget _withProgressStore(ProgressStore store, Widget child) {
  return ChangeNotifierProvider<ProgressStore>.value(
    value: store,
    child: MaterialApp(theme: AppTheme.light(), home: child),
  );
}

void main() {
  testWidgets('Home screen has two focus cards and navigates to the DSA list', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(progressStore: await _freshProgressStore()));
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
    await tester.pumpWidget(MyApp(progressStore: await _freshProgressStore()));
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
    await tester.pumpWidget(MyApp(progressStore: await _freshProgressStore()));
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

    // 'Next Step' lives in the transport controls' fixed footer (outside any
    // Scrollable), so it's always on screen — no ensureVisible needed, and
    // calling it here would walk up to the TabBarView's own PageView and
    // swipe tabs instead of scrolling the (non-existent) nearer ancestor.
    await tester.tap(find.text('Next Step'));
    await tester.pump();

    expect(find.text('Step 2 of 5'), findsOneWidget);
  });

  testWidgets('Home screen has a System Design entry that opens fundamentals and practice problems', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(progressStore: await _freshProgressStore()));
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
      // The list now has a search TextField ahead of the results, and
      // EditableText builds its own internal Scrollable for text overflow
      // — .first picks the outer ListView's Scrollable, not the field's.
      scrollable: find.descendant(
        of: find.byKey(const Key('fundamentals_list')),
        matching: find.byType(Scrollable),
      ).first,
    );
    expect(find.text('CAP Theorem'), findsOneWidget);

    await tester.tap(find.text('Practice Problems'));
    await tester.pumpAndSettle();

    expect(find.text('Design a URL Shortener'), findsOneWidget);
    expect(find.text('Design a Rate Limiter'), findsOneWidget);
  });

  testWidgets('Fundamentals detail screen renders theory, diagram, and key points', (WidgetTester tester) async {
    final concept = FundamentalsData.getConcepts().firstWhere((c) => c.diagram != null);
    await tester.pumpWidget(_withProgressStore(
      await _freshProgressStore(),
      FundamentalDetailScreen(concept: concept),
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

  for (final concept in FundamentalsData.getConcepts()) {
    testWidgets('${concept.title}: Theory and Quiz tabs render without error', (WidgetTester tester) async {
      await tester.pumpWidget(_withProgressStore(
        await _freshProgressStore(),
        FundamentalDetailScreen(concept: concept),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Quiz'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Question 1 of 5'), findsOneWidget);
    });
  }

  for (final problem in SystemDesignData.getProblems()) {
    testWidgets('${problem.title}: requirements render and design canvas is usable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_withProgressStore(
        await _freshProgressStore(),
        SystemDesignDetailScreen(problem: problem),
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
        await tester.pumpWidget(_withProgressStore(
          await _freshProgressStore(),
          AlgorithmDetailScreen(algorithm: algorithm),
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
        // The transport controls live in a fixed footer outside any
        // Scrollable, so they're always on screen — ensureVisible would walk
        // up to the TabBarView's own PageView and swipe tabs instead.
        final firstViz = algorithm.visualizations.first;
        for (int i = 0; i < firstViz.steps.length - 1; i++) {
          final nextButton = find.byIcon(Icons.skip_next);
          await tester.tap(nextButton);
          await tester.pump();
        }
        expect(tester.takeException(), isNull);

        // Every algorithm now has at least one Python code example, shown
        // as its own tab (between Simulation and Review) rather than a
        // separate screen reached via an app-bar icon.
        await tester.tap(find.text('Code'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final examples = AlgorithmPythonExamples.examplesFor(algorithm.id);
        expect(examples, isNotEmpty, reason: '${algorithm.name} is missing Python code examples');
        expect(find.text(examples.keys.first), findsWidgets);

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

  testWidgets('Completing a fundamentals quiz persists a score and shows a badge on the list card', (
    WidgetTester tester,
  ) async {
    final store = await _freshProgressStore();
    final concept = FundamentalsData.getConcepts().first;
    final questions = FundamentalsQuizData.questionsFor(concept.id);
    expect(questions, isNotEmpty, reason: 'test needs a concept with quiz questions');

    await tester.pumpWidget(_withProgressStore(store, FundamentalDetailScreen(concept: concept)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();

    // Answer every question (always tap the first option — right or wrong,
    // it still drives the quiz to completion so onCompleted fires). The
    // quiz tab lives inside a SingleChildScrollView, so the Next/See
    // Results button isn't necessarily within the viewport once the
    // explanation box pushes it down — ensureVisible before each tap.
    for (var i = 0; i < questions.length; i++) {
      final optionFinder = find.text(questions[i].options.first);
      await tester.ensureVisible(optionFinder);
      await tester.tap(optionFinder);
      await tester.pumpAndSettle();

      final nextFinder = find.text(i < questions.length - 1 ? 'Next' : 'See Results');
      await tester.ensureVisible(nextFinder);
      await tester.tap(nextFinder);
      await tester.pumpAndSettle();
    }

    final result = store.resultFor(ProgressDomain.fundamental, concept.id);
    expect(result, isNotNull);
    expect(result!.total, questions.length);

    // Reopening the (now-tracked) fundamentals list should render a score
    // badge on this concept's card. FundamentalsListScreen has no Scaffold
    // of its own (it's normally hosted inside SystemDesignListScreen's), so
    // wrap it in one here to give the TextField a Material ancestor.
    await tester.pumpWidget(_withProgressStore(
      store,
      const Scaffold(body: FundamentalsListScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('${result.score}/${result.total}'), findsOneWidget);
  });

  testWidgets('Home screen progress summary reflects completed quizzes', (WidgetTester tester) async {
    final store = await _freshProgressStore();
    final firstAlgorithm = AlgorithmData.getAlgorithms().first;
    await store.recordQuizResult(ProgressDomain.algorithm, firstAlgorithm.id, 3, 5);

    await tester.pumpWidget(MyApp(progressStore: store));
    await tester.pumpAndSettle();

    expect(find.textContaining('1/${AlgorithmData.getAlgorithms().length} quizzes completed'), findsOneWidget);
    expect(find.textContaining('0/${FundamentalsData.getConcepts().length} quizzes completed'), findsOneWidget);
  });

  testWidgets('Reset Progress in the drawer is disabled until there is progress, then clears it', (
    WidgetTester tester,
  ) async {
    final store = await _freshProgressStore();
    await tester.pumpWidget(MyApp(progressStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // No progress yet: the tile is disabled. The drawer stays open and
    // rebuilds live (it watches ProgressStore), so no need to close/reopen
    // it around recording a result below.
    final resetTile = find.widgetWithText(ListTile, 'Reset Progress');
    expect(tester.widget<ListTile>(resetTile).enabled, isFalse);

    final firstAlgorithm = AlgorithmData.getAlgorithms().first;
    await store.recordQuizResult(ProgressDomain.algorithm, firstAlgorithm.id, 4, 5);
    await tester.pumpAndSettle();

    expect(tester.widget<ListTile>(resetTile).enabled, isTrue);
    await tester.tap(resetTile);
    await tester.pumpAndSettle();

    // Confirmation dialog appears; cancelling leaves progress intact.
    expect(find.text('Reset progress?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(store.resultFor(ProgressDomain.algorithm, firstAlgorithm.id), isNotNull);

    // Confirm this time.
    await tester.tap(resetTile);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(store.resultFor(ProgressDomain.algorithm, firstAlgorithm.id), isNull);
    expect(find.text('Progress reset'), findsOneWidget);
    expect(find.textContaining('0/${AlgorithmData.getAlgorithms().length} quizzes completed'), findsOneWidget);
  });
}
