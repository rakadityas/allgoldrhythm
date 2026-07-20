import 'package:flutter/material.dart';
import '../models/algorithm.dart';
import '../theme/app_theme.dart';
import '../widgets/algorithm_definition.dart';
import '../widgets/algorithm_simulation.dart';
import '../widgets/algorithm_review.dart';
import '../widgets/algorithm_quiz.dart';
import 'code_examples_screen.dart';

class AlgorithmDetailScreen extends StatelessWidget {
  final Algorithm algorithm;

  const AlgorithmDetailScreen({super.key, required this.algorithm});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(algorithm.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.code),
              tooltip: 'Python Code Examples',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CodeExamplesScreen(algorithm: algorithm),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Overview', icon: Icon(Icons.menu_book_outlined)),
              Tab(text: 'Simulation', icon: Icon(Icons.play_circle_outline)),
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
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AlgorithmSimulation(algorithm: algorithm),
            ),
            SingleChildScrollView(
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
