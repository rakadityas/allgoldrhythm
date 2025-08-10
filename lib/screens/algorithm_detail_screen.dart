import 'package:flutter/material.dart';
import '../models/algorithm.dart';
import '../widgets/algorithm_definition.dart';
import '../widgets/algorithm_simulation.dart';
import '../widgets/algorithm_review.dart';
import 'code_examples_screen.dart';

class AlgorithmDetailScreen extends StatelessWidget {
  final Algorithm algorithm;

  const AlgorithmDetailScreen({super.key, required this.algorithm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(algorithm.name),
        backgroundColor: Colors.amber[700],
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Definition Section
              AlgorithmDefinition(algorithm: algorithm),
              const SizedBox(height: 24),
              
              // Simulation Section
              const Text(
                'Simulation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AlgorithmSimulation(algorithm: algorithm),
              const SizedBox(height: 24),
              
              // Interactive Review Section
              const Text(
                'Interactive Review',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AlgorithmReview(algorithm: algorithm),
            ],
          ),
        ),
      ),
    );
  }
}