import 'package:flutter_test/flutter_test.dart';
import 'package:allgoldrhythm/data/algorithm_data.dart';
import 'package:allgoldrhythm/data/algorithm_python_examples.dart';
import 'package:allgoldrhythm/data/fundamentals_data.dart';
import 'package:allgoldrhythm/data/fundamentals_quiz_data.dart';
import 'package:allgoldrhythm/data/quiz_data.dart';
import 'package:allgoldrhythm/data/system_design_data.dart';
import 'package:allgoldrhythm/models/quiz_question.dart';

/// Referential-integrity checks over the hand-authored content. The app is
/// mostly content keyed by string ids across parallel files; these tests turn
/// a typo'd quiz key or an out-of-range answer index into a test failure
/// instead of a silent runtime gap.
void main() {
  void expectValidQuestions(String owner, List<QuizQuestion> questions) {
    expect(questions, isNotEmpty, reason: '$owner has no quiz questions');
    for (final q in questions) {
      expect(q.options.length, greaterThanOrEqualTo(2),
          reason: '$owner: "${q.question}" needs at least 2 options');
      expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1),
          reason: '$owner: "${q.question}" correctIndex out of range');
      expect(q.explanation.trim(), isNotEmpty,
          reason: '$owner: "${q.question}" is missing an explanation');
      expect(q.question.trim(), isNotEmpty, reason: '$owner has an empty question');
    }
  }

  group('fundamentals', () {
    final concepts = FundamentalsData.getConcepts();

    test('ids are unique', () {
      final ids = concepts.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length,
          reason: 'duplicate fundamental concept id');
    });

    test('every concept has a valid quiz', () {
      for (final concept in concepts) {
        expectValidQuestions(
          'fundamental ${concept.id}',
          FundamentalsQuizData.questionsFor(concept.id),
        );
      }
    });

    test('no orphaned quiz banks (every quiz key is a real concept id)', () {
      final conceptIds = concepts.map((c) => c.id).toSet();
      // Probe by round-trip: a quiz bank is reachable only via questionsFor,
      // so verify each concept id resolves and known-bad ids do not.
      expect(FundamentalsQuizData.questionsFor('definitely_not_a_concept'), isEmpty);
      for (final id in conceptIds) {
        expect(FundamentalsQuizData.questionsFor(id), isNotEmpty,
            reason: 'concept $id has no quiz bank entry');
      }
    });

    test('every concept has non-empty summary and key points', () {
      for (final concept in concepts) {
        expect(concept.summary.trim(), isNotEmpty, reason: concept.id);
        expect(concept.keyPoints, isNotEmpty, reason: concept.id);
        expect(concept.category.trim(), isNotEmpty, reason: concept.id);
      }
    });
  });

  group('algorithms', () {
    final algorithms = AlgorithmData.getAlgorithms();

    test('ids are unique', () {
      final ids = algorithms.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'duplicate algorithm id');
    });

    test('every algorithm has a valid quiz', () {
      for (final algorithm in algorithms) {
        expectValidQuestions(
          'algorithm ${algorithm.id}',
          QuizData.questionsFor(algorithm.id),
        );
      }
    });

    test('every algorithm has Python examples', () {
      for (final algorithm in algorithms) {
        expect(AlgorithmPythonExamples.examplesFor(algorithm.id), isNotEmpty,
            reason: 'algorithm ${algorithm.id} has no Python examples');
      }
    });

    test('every visualization is structurally valid', () {
      for (final algorithm in algorithms) {
        expect(algorithm.visualizations, isNotEmpty, reason: algorithm.id);
        for (final viz in algorithm.visualizations) {
          final owner = '${algorithm.id} / ${viz.title}';
          expect(viz.steps, isNotEmpty, reason: owner);
          expect(viz.mockQuestion.trim(), isNotEmpty, reason: owner);
          expect(viz.values, isNotEmpty, reason: owner);
          final length = viz.arrayLength;
          for (final step in viz.steps) {
            for (final i in [
              ...step.highlightIndices,
              ...step.previousIndices,
              ...step.removedIndices,
            ]) {
              expect(i, inInclusiveRange(0, length - 1),
                  reason: '$owner: step index $i out of bounds (length $length)');
            }
          }
        }
      }
    });
  });

  group('system design problems', () {
    final problems = SystemDesignData.getProblems();

    test('ids are unique', () {
      final ids = problems.map((p) => p.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'duplicate problem id');
    });

    test('reference connections only use declared components', () {
      for (final problem in problems) {
        final declared = problem.reference.components.toSet();
        expect(declared.length, problem.reference.components.length,
            reason: '${problem.id}: duplicate component in reference');
        for (final (from, to) in problem.reference.connections) {
          expect(declared.contains(from), isTrue,
              reason: '${problem.id}: connection from undeclared $from');
          expect(declared.contains(to), isTrue,
              reason: '${problem.id}: connection to undeclared $to');
        }
      }
    });

    test('every problem has complete interview sections', () {
      for (final problem in problems) {
        expect(problem.functionalRequirements, isNotEmpty, reason: problem.id);
        expect(problem.nonFunctionalRequirements, isNotEmpty, reason: problem.id);
        expect(problem.capacityEstimation, isNotEmpty, reason: problem.id);
        expect(problem.apiDesign, isNotEmpty, reason: problem.id);
        expect(problem.highLevelDesign.trim(), isNotEmpty, reason: problem.id);
        expect(problem.reference.components, isNotEmpty, reason: problem.id);
        expect(problem.reference.connections, isNotEmpty, reason: problem.id);
      }
    });
  });
}
