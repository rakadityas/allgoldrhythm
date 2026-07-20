import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/algorithm.dart';
import 'quiz_view.dart';

class AlgorithmQuiz extends StatelessWidget {
  final Algorithm algorithm;

  const AlgorithmQuiz({super.key, required this.algorithm});

  @override
  Widget build(BuildContext context) {
    return QuizView(
      questions: QuizData.questionsFor(algorithm.id),
      emptyStateMessage: 'No quiz questions available yet for ${algorithm.name}.',
    );
  }
}
