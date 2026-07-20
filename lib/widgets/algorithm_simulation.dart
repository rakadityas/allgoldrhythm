import 'package:flutter/material.dart';
import '../models/algorithm.dart';
import '../theme/app_theme.dart';
import '../utils/graph_layout.dart';
import '../utils/pointer_labels.dart';

class AlgorithmSimulation extends StatefulWidget {
  final Algorithm algorithm;

  const AlgorithmSimulation({super.key, required this.algorithm});

  @override
  State<AlgorithmSimulation> createState() => _AlgorithmSimulationState();
}

class _AlgorithmSimulationState extends State<AlgorithmSimulation> {
  int _currentVisualizationIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;

  /// Bumped on every reset/manual-navigation/visualization-change so a
  /// pending `Future.delayed` from an old `_playAnimation` chain can tell
  /// it's stale and stop, instead of resuming playback on whatever step the
  /// user has since navigated to.
  int _playToken = 0;

  @override
  void dispose() {
    _isPlaying = false;
    _playToken++;
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_currentStepIndex <
          widget.algorithm.visualizations[_currentVisualizationIndex].steps.length - 1) {
        _currentStepIndex++;
      } else {
        _isPlaying = false;
      }
    });
  }

  /// User-initiated navigation (tapping Previous/Next/Restart directly)
  /// pauses any running auto-play, so a manual tap can't be raced by the
  /// pending auto-advance timer into an extra, unexpected step change.
  void _previousStepManual() {
    setState(() {
      _isPlaying = false;
      _playToken++;
      if (_currentStepIndex > 0) {
        _currentStepIndex--;
      }
    });
  }

  void _nextStepManual() {
    setState(() {
      _isPlaying = false;
      _playToken++;
    });
    _nextStep();
  }

  void _resetSimulation() {
    setState(() {
      _currentStepIndex = 0;
      _isPlaying = false;
      _playToken++;
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playAnimation(_playToken);
      } else {
        _playToken++;
      }
    });
  }

  void _playAnimation(int token) async {
    if (!_isPlaying || token != _playToken) return;

    if (_currentStepIndex <
        widget.algorithm.visualizations[_currentVisualizationIndex].steps.length - 1) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted || !_isPlaying || token != _playToken) return;
      _nextStep();
      _playAnimation(token);
    } else {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _changeVisualization(int index) {
    setState(() {
      _currentVisualizationIndex = index;
      _currentStepIndex = 0;
      _isPlaying = false;
      _playToken++;
    });
  }

  Widget _buildTreeVisualization(VisualizationStep currentStep, Map<int, String> labels) {
    final treeValues = [50, 30, 70, 20, 40, 60, 80];
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: CustomPaint(
        painter: TreePainter(
          highlightedIndices: currentStep.highlightIndices,
          previousIndices: currentStep.previousIndices,
          treeValues: treeValues,
          scheme: Theme.of(context).colorScheme,
          labels: labels,
        ),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildGraphVisualization(AlgorithmVisualization viz, VisualizationStep currentStep, Map<int, String> labels) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: CustomPaint(
        painter: GraphPainter(
          highlightedIndices: currentStep.highlightIndices,
          previousIndices: currentStep.previousIndices,
          nodeValues: List.generate(GraphLayout.nodeCount, (i) => viz.valueAt(i)),
          scheme: Theme.of(context).colorScheme,
          labels: labels,
        ),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildArrayCell({
    required ThemeData theme,
    required int index,
    required int value,
    required bool isHighlighted,
    required bool wasHighlighted,
    required bool isRemoved,
    required String? label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
          child: label == null
              ? null
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isRemoved
                ? theme.colorScheme.errorContainer
                : isHighlighted
                    ? theme.colorScheme.primary
                    : wasHighlighted
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Center(
            child: Text(
              '$value',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isRemoved
                    ? theme.colorScheme.onErrorContainer
                    : isHighlighted
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                decoration: isRemoved ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 14,
          child: isRemoved
              ? Text('removed', style: theme.textTheme.labelMedium?.copyWith(fontSize: 10, color: theme.colorScheme.error))
              : wasHighlighted && !isHighlighted
                  ? Text('prev', style: theme.textTheme.labelMedium?.copyWith(fontSize: 10))
                  : null,
        ),
      ],
    );
  }

  Widget _buildPointerRow(
    ThemeData theme,
    AlgorithmVisualization viz,
    VisualizationStep step,
    int highlightIdx,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: List.generate(viz.arrayLength, (index) {
            return _buildArrayCell(
              theme: theme,
              index: index,
              value: viz.valueAtStep(index, step),
              isHighlighted: index == highlightIdx,
              wasHighlighted: false,
              isRemoved: step.removedIndices.contains(index),
              label: null,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPointerArrayRows(
    ThemeData theme,
    AlgorithmVisualization viz,
    VisualizationStep step,
    Map<int, String> labels,
  ) {
    final indices = step.highlightIndices.toSet().toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < indices.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          _buildPointerRow(theme, viz, step, indices[i], labels[indices[i]] ?? 'Pointer ${i + 1}'),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualizations = widget.algorithm.visualizations;
    final currentVisualization = visualizations[_currentVisualizationIndex];
    final currentStep = currentVisualization.steps[_currentStepIndex];
    final isLastStep = _currentStepIndex == currentVisualization.steps.length - 1;
    final pointerLabels = PointerLabels.forStep(
      algorithmId: widget.algorithm.id,
      visualizationTitle: currentVisualization.title,
      highlightIndices: currentStep.highlightIndices,
    );
    final hasMultiplePointers = PointerLabels.multiRowAlgorithms.contains(widget.algorithm.id) &&
        currentStep.highlightIndices.toSet().length > 1;

    // The stage (title, scenario, visualization, explanation) varies in
    // height from step to step — different explanation lengths, a
    // conditional current/previous legend, a different number of pointer
    // rows. It scrolls in its own region so that never shifts the transport
    // controls below, which stay pinned at a fixed position on screen.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (visualizations.length > 1)
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: visualizations.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            return ChoiceChip(
                              label: Text(visualizations[index].title),
                              selected: _currentVisualizationIndex == index,
                              onSelected: (selected) {
                                if (selected) _changeVisualization(index);
                              },
                            );
                          },
                        ),
                      ),
                    if (visualizations.length > 1) const SizedBox(height: AppSpacing.md),

                    Text(currentVisualization.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(currentVisualization.description, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.md),
                    _ScenarioCallout(question: currentVisualization.mockQuestion),
                    const SizedBox(height: AppSpacing.md),

                    if (widget.algorithm.id != 'trees' && widget.algorithm.id != 'graph' && !hasMultiplePointers && currentStep.previousIndices.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('current', style: theme.textTheme.labelMedium),
                            const SizedBox(width: AppSpacing.md),
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('previous', style: theme.textTheme.labelMedium),
                          ],
                        ),
                      ),

                    if (widget.algorithm.id == 'trees')
                      _buildTreeVisualization(currentStep, pointerLabels)
                    else if (widget.algorithm.id == 'graph')
                      _buildGraphVisualization(currentVisualization, currentStep, pointerLabels)
                    else if (hasMultiplePointers)
                      _buildPointerArrayRows(theme, currentVisualization, currentStep, pointerLabels)
                    else
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: List.generate(currentVisualization.arrayLength, (index) {
                            return _buildArrayCell(
                              theme: theme,
                              index: index,
                              value: currentVisualization.valueAtStep(index, currentStep),
                              isHighlighted: currentStep.highlightIndices.contains(index),
                              wasHighlighted: currentStep.previousIndices.contains(index),
                              isRemoved: currentStep.removedIndices.contains(index),
                              label: pointerLabels[index],
                            );
                          }),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm + 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(currentStep.explanation, style: theme.textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildControls(theme, currentVisualization, isLastStep),
      ],
    );
  }

  /// Transport controls pinned outside the scrollable stage above, so their
  /// on-screen position never shifts as step content changes height.
  Widget _buildControls(ThemeData theme, AlgorithmVisualization currentVisualization, bool isLastStep) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  tooltip: 'Previous step',
                  onPressed: _currentStepIndex > 0 ? _previousStepManual : null,
                ),
                IconButton.filled(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  tooltip: _isPlaying ? 'Pause' : 'Play',
                  onPressed: isLastStep && !_isPlaying ? null : _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  tooltip: 'Next step',
                  onPressed: !isLastStep ? _nextStepManual : null,
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  tooltip: 'Restart',
                  onPressed: _resetSimulation,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                currentVisualization.steps.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: index == _currentStepIndex ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: index == _currentStepIndex
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCallout extends StatelessWidget {
  final String question;

  const _ScenarioCallout({required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 18, color: theme.colorScheme.tertiary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(question, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final List<int> highlightedIndices;
  final List<int>? previousIndices;
  final List<int> treeValues;
  final ColorScheme scheme;
  final Map<int, String> labels;

  TreePainter({
    required this.highlightedIndices,
    this.previousIndices,
    required this.treeValues,
    required this.scheme,
    this.labels = const {},
  });

  static const _treeStructure = <int, List<int?>>{
    0: [1, 2],
    1: [3, 4],
    2: [5, 6],
    3: [null, null],
    4: [null, null],
    5: [null, null],
    6: [null, null],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = scheme.outlineVariant;

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    _treeStructure.forEach((parentIndex, children) {
      final parentPos = _getNodePosition(parentIndex, size.height, size.width);
      for (final childIndex in children) {
        if (childIndex != null) {
          final childPos = _getNodePosition(childIndex, size.height, size.width);
          canvas.drawLine(parentPos, childPos, linePaint);
        }
      }
    });

    for (int i = 0; i < treeValues.length; i++) {
      final position = _getNodePosition(i, size.height, size.width);

      Color nodeColor;
      Color borderColor;
      if (highlightedIndices.contains(i)) {
        nodeColor = scheme.primary;
        borderColor = scheme.primary;
      } else if (previousIndices?.contains(i) ?? false) {
        nodeColor = scheme.primaryContainer;
        borderColor = scheme.primary.withValues(alpha: 0.5);
      } else {
        nodeColor = scheme.surfaceContainerHigh;
        borderColor = scheme.outlineVariant;
      }

      fillPaint.color = nodeColor;
      canvas.drawCircle(position, 28, fillPaint);
      borderPaint.color = borderColor;
      canvas.drawCircle(position, 28, borderPaint);

      final isHighlighted = highlightedIndices.contains(i);
      textPainter.text = TextSpan(
        text: treeValues[i].toString(),
        style: TextStyle(
          color: isHighlighted ? scheme.onPrimary : scheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2),
      );

      final label = labels[i];
      if (label != null) {
        final labelPainter = TextPainter(textDirection: TextDirection.ltr)
          ..text = TextSpan(
            text: label,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          )
          ..layout();
        labelPainter.paint(
          canvas,
          Offset(position.dx - labelPainter.width / 2, position.dy - 28 - labelPainter.height - 2),
        );
      }
    }
  }

  Offset _getNodePosition(int index, double height, double width) {
    final levels = [
      [0],
      [1, 2],
      [3, 4, 5, 6],
    ];

    for (int level = 0; level < levels.length; level++) {
      if (levels[level].contains(index)) {
        final positionInLevel = levels[level].indexOf(index);
        final nodesInLevel = levels[level].length;
        final y = 52.0 + level * 88.0;
        final x = width / (nodesInLevel + 1) * (positionInLevel + 1);
        return Offset(x, y);
      }
    }
    return Offset(width / 2, height / 2);
  }

  @override
  bool shouldRepaint(TreePainter oldDelegate) {
    return oldDelegate.highlightedIndices != highlightedIndices ||
        oldDelegate.previousIndices != previousIndices ||
        oldDelegate.scheme != scheme ||
        oldDelegate.labels != labels;
  }
}

class GraphPainter extends CustomPainter {
  final List<int> highlightedIndices;
  final List<int> previousIndices;
  final List<int> nodeValues;
  final ColorScheme scheme;
  final Map<int, String> labels;

  GraphPainter({
    required this.highlightedIndices,
    required this.previousIndices,
    required this.nodeValues,
    required this.scheme,
    this.labels = const {},
  });

  static const double _radius = 26;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = scheme.outlineVariant;

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final edge in GraphLayout.edges) {
      final from = GraphLayout.positionFor(edge[0], size.width, size.height);
      final to = GraphLayout.positionFor(edge[1], size.width, size.height);
      canvas.drawLine(from, to, linePaint);
    }

    for (int i = 0; i < nodeValues.length; i++) {
      final position = GraphLayout.positionFor(i, size.width, size.height);
      final isHighlighted = highlightedIndices.contains(i);
      final wasVisited = previousIndices.contains(i);

      Color nodeColor;
      Color borderColor;
      if (isHighlighted) {
        nodeColor = scheme.primary;
        borderColor = scheme.primary;
      } else if (wasVisited) {
        nodeColor = scheme.primaryContainer;
        borderColor = scheme.primary.withValues(alpha: 0.5);
      } else {
        nodeColor = scheme.surfaceContainerHigh;
        borderColor = scheme.outlineVariant;
      }

      fillPaint.color = nodeColor;
      canvas.drawCircle(position, _radius, fillPaint);
      borderPaint.color = borderColor;
      canvas.drawCircle(position, _radius, borderPaint);

      textPainter.text = TextSpan(
        text: nodeValues[i].toString(),
        style: TextStyle(
          color: isHighlighted ? scheme.onPrimary : scheme.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2),
      );

      final label = labels[i];
      if (label != null) {
        final labelPainter = TextPainter(textDirection: TextDirection.ltr)
          ..text = TextSpan(
            text: label,
            style: TextStyle(color: scheme.primary, fontSize: 11, fontWeight: FontWeight.w700),
          )
          ..layout();
        labelPainter.paint(
          canvas,
          Offset(position.dx - labelPainter.width / 2, position.dy - _radius - labelPainter.height - 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.highlightedIndices != highlightedIndices ||
        oldDelegate.previousIndices != previousIndices ||
        oldDelegate.scheme != scheme ||
        oldDelegate.labels != labels;
  }
}
