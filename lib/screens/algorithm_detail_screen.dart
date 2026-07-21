import 'package:flutter/material.dart';
import '../models/algorithm.dart';
import '../theme/app_theme.dart';
import '../widgets/algorithm_code_view.dart';
import '../widgets/algorithm_definition.dart';
import '../widgets/algorithm_simulation.dart';
import '../widgets/algorithm_review.dart';
import '../widgets/algorithm_quiz.dart';

class AlgorithmDetailScreen extends StatelessWidget {
  final Algorithm algorithm;

  const AlgorithmDetailScreen({super.key, required this.algorithm});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(algorithm.name),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Overview', icon: Icon(Icons.menu_book_outlined)),
              Tab(text: 'Simulation', icon: Icon(Icons.play_circle_outline)),
              Tab(text: 'Code', icon: Icon(Icons.code)),
              Tab(text: 'Review', icon: Icon(Icons.psychology_outlined)),
              Tab(text: 'Quiz', icon: Icon(Icons.quiz_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AlgorithmDefinition(algorithm: algorithm),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AlgorithmSimulation(algorithm: algorithm),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AlgorithmCodeView(algorithm: algorithm),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AlgorithmReview(algorithm: algorithm),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AlgorithmQuiz(algorithm: algorithm),
            ),
          ],
        ),
      ),
    );
  }
}
