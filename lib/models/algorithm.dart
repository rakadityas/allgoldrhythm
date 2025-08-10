class Algorithm {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> steps;
  final List<AlgorithmVisualization> visualizations;

  Algorithm({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.steps,
    required this.visualizations,
  });
}

class AlgorithmVisualization {
  final String type; // 'simulation' or 'interactive'
  final String title;
  final String description;
  final List<VisualizationStep> steps;

  AlgorithmVisualization({
    required this.type,
    required this.title,
    required this.description,
    required this.steps,
  });
}

class VisualizationStep {
  final List<int> highlightIndices; // Indices to highlight in the array
  final List<int> previousIndices; // Previous indices for comparison
  final String explanation; // Explanation for this step

  VisualizationStep({
    required this.highlightIndices,
    this.previousIndices = const [],
    required this.explanation,
  });
}