import 'package:flutter/material.dart';
import '../data/algorithm_data.dart';
import '../models/algorithm.dart';
import 'algorithm_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Group algorithms by category
    final algorithms = AlgorithmData.getAlgorithms();
    final Map<String, List<Algorithm>> categorizedAlgorithms = {};
    
    for (var algorithm in algorithms) {
      if (!categorizedAlgorithms.containsKey(algorithm.category)) {
        categorizedAlgorithms[algorithm.category] = [];
      }
      categorizedAlgorithms[algorithm.category]!.add(algorithm);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AllGoldRhythm'),
        backgroundColor: Colors.amber[700],
      ),
      body: ListView.builder(
        itemCount: categorizedAlgorithms.length,
        itemBuilder: (context, index) {
          final category = categorizedAlgorithms.keys.elementAt(index);
          final categoryAlgorithms = categorizedAlgorithms[category]!;
          
          return ExpansionTile(
            title: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: categoryAlgorithms.map((algorithm) {
              return ListTile(
                title: Text(algorithm.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlgorithmDetailScreen(algorithm: algorithm),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}