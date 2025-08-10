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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text(
                'AllGoldRhythm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'AllGoldRhythm',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.school,
                    size: 48,
                    color: Colors.amber,
                  ),
                  children: [
                    const Text(
                      'A Data Structures & Algorithm visualization app for learning algorithms.',
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Licenses'),
              onTap: () {
                Navigator.pop(context);
                showLicensePage(
                  context: context,
                  applicationName: 'AllGoldRhythm',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.school,
                    size: 48,
                    color: Colors.amber,
                  ),
                );
              },
            ),
          ],
        ),
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
            initiallyExpanded: category == 'Data Structures & Algorithm',
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