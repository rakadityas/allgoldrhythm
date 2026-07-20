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

  /// A simple, concrete scenario ("Given [1,3,5,7], find...") that motivates
  /// why this pattern traverses the way it does. Shown in both Simulation
  /// and Review so the index-highlighting isn't just abstract movement.
  final String mockQuestion;

  /// The actual data sitting at each array slot, so blocks display real
  /// values (e.g. "12") instead of a meaningless position number.
  final List<int> values;

  AlgorithmVisualization({
    required this.type,
    required this.title,
    required this.description,
    required this.steps,
    required this.mockQuestion,
    required this.values,
  });

  /// Number of array slots to render for this visualization: at least as
  /// many as [values], but grows if any step references a higher index
  /// (e.g. linked list insertion growing past its starting size).
  int get arrayLength {
    int maxIndex = values.length - 1;
    for (final step in steps) {
      for (final i in [...step.highlightIndices, ...step.previousIndices]) {
        if (i > maxIndex) maxIndex = i;
      }
    }
    return maxIndex + 1;
  }

  /// The value to show for [index], falling back to a 1-based position
  /// label if this visualization's array grew past its authored [values].
  int valueAt(int index) => index < values.length ? values[index] : index + 1;

  /// Same as [valueAt] but honors a step's [VisualizationStep.valuesOverride]
  /// when present, so swap-based algorithms (sorting, heap sift) can show
  /// the array as it actually looks at that point instead of the original.
  int valueAtStep(int index, VisualizationStep step) {
    final source = step.valuesOverride ?? values;
    return index < source.length ? source[index] : index + 1;
  }
}

class VisualizationStep {
  final List<int> highlightIndices; // Indices to highlight in the array
  final List<int> previousIndices; // Previous indices for comparison
  final String explanation; // Explanation for this step

  /// Indices that have been logically removed as of this step (e.g. a
  /// deleted linked-list node). Rendered as struck-through/greyed rather
  /// than actually vanishing, since slot positions stay fixed.
  final List<int> removedIndices;

  /// When set, overrides the visualization's base `values` for rendering
  /// this step — lets algorithms that physically rearrange data (sorting,
  /// heap sift-up/down) show the array as it truly looks at this point.
  final List<int>? valuesOverride;

  VisualizationStep({
    required this.highlightIndices,
    this.previousIndices = const [],
    required this.explanation,
    this.removedIndices = const [],
    this.valuesOverride,
  });
}