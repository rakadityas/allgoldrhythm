import 'package:flutter/material.dart';
import '../models/algorithm.dart';
import '../theme/app_theme.dart';
import '../utils/graph_layout.dart';
import '../utils/matrix_layout.dart';
import '../utils/pointer_labels.dart';

class GraphReviewPainter extends CustomPainter {
  final Color lineColor;

  GraphReviewPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final edge in GraphLayout.edges) {
      final from = GraphLayout.positionFor(edge[0], size.width, size.height);
      final to = GraphLayout.positionFor(edge[1], size.width, size.height);
      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GraphReviewPainter oldDelegate) => oldDelegate.lineColor != lineColor;
}

class TreeReviewPainter extends CustomPainter {
  final Set<int> selectedIndices;
  final Color lineColor;

  TreeReviewPainter(this.selectedIndices, {required this.lineColor});

  static const _connections = [
    [0, 1],
    [0, 2],
    [1, 3],
    [1, 4],
    [2, 5],
    [2, 6],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final connection in _connections) {
      final fromPos = _getNodePosition(connection[0]);
      final toPos = _getNodePosition(connection[1]);
      canvas.drawLine(fromPos, toPos, paint);
    }
  }

  Offset _getNodePosition(int index) {
    const double centerX = 150;
    const double startY = 52;
    const double levelHeight = 88;

    switch (index) {
      case 0: return const Offset(centerX, startY);
      case 1: return const Offset(centerX - 70, startY + levelHeight);
      case 2: return const Offset(centerX + 70, startY + levelHeight);
      case 3: return const Offset(centerX - 105, startY + 2 * levelHeight);
      case 4: return const Offset(centerX - 35, startY + 2 * levelHeight);
      case 5: return const Offset(centerX + 35, startY + 2 * levelHeight);
      case 6: return const Offset(centerX + 105, startY + 2 * levelHeight);
      default: return const Offset(centerX, startY);
    }
  }

  @override
  bool shouldRepaint(covariant TreeReviewPainter oldDelegate) =>
      oldDelegate.selectedIndices != selectedIndices || oldDelegate.lineColor != lineColor;
}

/// Interactive review: the user picks one of the algorithm's real
/// visualizations, then reproduces it step by step by tapping the same
/// indices [AlgorithmSimulation] would highlight at each step. Every tap is
/// validated against that exact step only, and on success we surface the
/// same [VisualizationStep.explanation] text the Simulation tab shows.
class AlgorithmReview extends StatefulWidget {
  final Algorithm algorithm;

  const AlgorithmReview({super.key, required this.algorithm});

  @override
  State<AlgorithmReview> createState() => _AlgorithmReviewState();
}

class _AlgorithmReviewState extends State<AlgorithmReview> {
  static const List<int> _treeValues = [50, 30, 70, 20, 40, 60, 80];

  AlgorithmVisualization? _selected;
  int _stepIndex = 0;
  final Set<int> _tapped = {};
  bool _stepComplete = false;
  bool _wrong = false;
  bool _finished = false;
  final ScrollController _historyScroll = ScrollController();
  final ScrollController _stageScroll = ScrollController();

  bool get _isTree => widget.algorithm.id == 'trees';
  bool get _isGraph => widget.algorithm.id == 'graph';
  bool get _isMatrix => widget.algorithm.id == 'matrix_traversal';
  bool get _hasMultiplePointers =>
      PointerLabels.multiRowAlgorithms.contains(widget.algorithm.id) && _expected.length > 1;

  Set<int> get _expected =>
      _selected!.steps[_stepIndex].highlightIndices.toSet();

  /// Number of steps whose explanation has already been confirmed correct,
  /// i.e. how many entries belong in the history trail.
  int get _completedCount {
    if (_selected == null) return 0;
    if (_finished) return _selected!.steps.length;
    return _stepIndex + (_stepComplete ? 1 : 0);
  }

  @override
  void dispose() {
    _historyScroll.dispose();
    _stageScroll.dispose();
    super.dispose();
  }

  /// The picker and challenge views share one scrollable stage region. Since
  /// they're wildly different heights, carrying over a scroll offset from
  /// one into the other (e.g. after scrolling down a long pattern picker)
  /// would leave the next view rendered mid-scroll instead of at the top.
  void _resetStageScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_stageScroll.hasClients) return;
      _stageScroll.jumpTo(0);
    });
  }

  void _scrollHistoryToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_historyScroll.hasClients) return;
      _historyScroll.animateTo(
        _historyScroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _choosePattern(AlgorithmVisualization viz) {
    setState(() {
      _selected = viz;
      _stepIndex = 0;
      _tapped.clear();
      _wrong = false;
      _finished = false;
      _stepComplete = _expected.isEmpty;
    });
    _resetStageScroll();
  }

  void _changePattern() {
    setState(() {
      _selected = null;
      _stepIndex = 0;
      _tapped.clear();
      _wrong = false;
      _finished = false;
      _stepComplete = false;
    });
    _resetStageScroll();
  }

  void _restart() {
    setState(() {
      _stepIndex = 0;
      _tapped.clear();
      _wrong = false;
      _finished = false;
      _stepComplete = _expected.isEmpty;
    });
  }

  void _nextStep() {
    setState(() {
      if (_stepIndex == _selected!.steps.length - 1) {
        _finished = true;
        return;
      }
      _stepIndex++;
      _tapped.clear();
      _stepComplete = _expected.isEmpty;
    });
  }

  void _handleTap(int index) {
    if (_selected == null || _wrong || _stepComplete || _finished) return;

    final expected = _expected;
    if (_tapped.contains(index)) {
      setState(() => _tapped.remove(index));
      return;
    }
    if (!expected.contains(index)) {
      _flagWrong();
      return;
    }
    setState(() {
      _tapped.add(index);
      if (_tapped.length == expected.length) _stepComplete = true;
    });
  }

  void _flagWrong() {
    setState(() => _wrong = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _wrong = false;
        _tapped.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualizations = widget.algorithm.visualizations;

    if (visualizations.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'No review patterns available yet for ${widget.algorithm.name}.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    // The stage below varies in height per step (feedback text, history
    // trail, legend), so it scrolls in its own region and the primary
    // Restart/Next-Step actions are pinned in a fixed footer instead of
    // trailing the variable content, so they never shift on screen.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _stageScroll,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _selected == null
                    ? _buildPicker(theme, visualizations)
                    : _buildChallenge(theme, _selected!),
              ),
            ),
          ),
        ),
        if (_selected != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _buildFooter(theme),
        ],
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final showNextAction = !_finished;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart'),
            ),
            const Spacer(),
            if (showNextAction)
              FilledButton.icon(
                onPressed: _stepComplete ? _nextStep : null,
                icon: Icon(_stepIndex < _selected!.steps.length - 1 ? Icons.arrow_forward : Icons.flag),
                label: Text(_stepIndex < _selected!.steps.length - 1 ? 'Next Step' : 'Finish'),
              )
            else
              FilledButton.icon(
                onPressed: _changePattern,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Choose Another'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker(ThemeData theme, List<AlgorithmVisualization> visualizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Test Your Understanding', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Choose a pattern to reproduce, step by step. We\'ll only check your taps against that pattern\'s real steps.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        ...visualizations.map(
          (viz) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => _choosePattern(viz),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm + 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(viz.title, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 2),
                          Text(
                            '${viz.steps.length} steps',
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallenge(ThemeData theme, AlgorithmVisualization viz) {
    final totalSteps = viz.steps.length;
    final expected = _finished ? const <int>{} : _expected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(viz.title, style: theme.textTheme.titleMedium)),
            TextButton.icon(
              onPressed: _changePattern,
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
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
              Expanded(child: Text(viz.mockQuestion, style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (!_finished) ...[
          Row(
            children: [
              Text('Step ${_stepIndex + 1} of $totalSteps', style: theme.textTheme.labelMedium),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_stepIndex + (_stepComplete ? 1 : 0)) / totalSteps,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildHistory(theme, viz),
          if (_completedCount > 0) const SizedBox(height: AppSpacing.md),
          if (_selected!.steps[_stepIndex].previousIndices.isNotEmpty && !(_stepComplete && _hasMultiplePointers))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text('selected', style: theme.textTheme.labelMedium),
                  const SizedBox(width: AppSpacing.md),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text('previous step', style: theme.textTheme.labelMedium),
                ],
              ),
            ),
          _isTree
              ? _buildTreeVisualization(theme.colorScheme, theme.textTheme)
              : _isGraph
                  ? _buildGraphVisualization(theme.colorScheme, theme.textTheme, viz)
                  : _isMatrix
                      ? _buildMatrixTapVisualization(theme.colorScheme, theme.textTheme, viz)
                      : _stepComplete && _hasMultiplePointers
                          ? _buildPointerArrayRows(theme.colorScheme, theme.textTheme, viz)
                          : _buildArrayVisualization(theme.colorScheme, theme.textTheme, viz),
          const SizedBox(height: AppSpacing.md),
          _buildFeedback(theme, expected),
        ] else
          _buildCompletion(theme, viz),
      ],
    );
  }

  Widget _buildFeedback(ThemeData theme, Set<int> expected) {
    final remaining = expected.length - _tapped.length;
    final step = _selected!.steps[_stepIndex];

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm + 4),
          decoration: BoxDecoration(
            color: _stepComplete
                ? context.appColors.success.withValues(alpha: 0.15)
                : _wrong
                    ? theme.colorScheme.error.withValues(alpha: 0.15)
                    : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_stepComplete) Icon(Icons.check_circle, color: context.appColors.success, size: 20),
              if (_wrong) Icon(Icons.cancel, color: theme.colorScheme.error, size: 20),
              if (_stepComplete || _wrong) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  _stepComplete
                      ? step.explanation
                      : _wrong
                          ? "You're wrong! Try again."
                          : expected.isEmpty
                              ? step.explanation
                              : 'Tap $remaining more ${_isTree || _isGraph ? "node" : "element"}${remaining == 1 ? "" : "s"} for this step.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _stepComplete
                        ? context.appColors.success
                        : _wrong
                            ? theme.colorScheme.error
                            : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A scrollable trail of every completed step's explanation, so the user
  /// can look back at what already happened instead of relying on memory.
  Widget _buildHistory(ThemeData theme, AlgorithmVisualization viz) {
    final completed = _completedCount;
    if (completed == 0) return const SizedBox.shrink();

    _scrollHistoryToEnd();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 160),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 4, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Scrollbar(
        controller: _historyScroll,
        child: ListView.separated(
          controller: _historyScroll,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: completed,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, i) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, size: 16, color: context.appColors.success),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Step ${i + 1}: ',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: viz.steps[i].explanation),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletion(ThemeData theme, AlgorithmVisualization viz) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.emoji_events, size: 48, color: context.appColors.success),
        const SizedBox(height: AppSpacing.sm),
        Text('Great job!', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'You walked through all ${viz.steps.length} steps of "${viz.title}".',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Align(alignment: Alignment.centerLeft, child: Text('Full journey', style: theme.textTheme.titleSmall)),
        const SizedBox(height: AppSpacing.sm),
        _buildHistory(theme, viz),
      ],
    );
  }

  Widget _buildArrayVisualization(ColorScheme scheme, TextTheme textTheme, AlgorithmVisualization viz) {
    final step = viz.steps[_stepIndex];
    final previousIndices = step.previousIndices.toSet();
    final labels = PointerLabels.forStep(
      algorithmId: widget.algorithm.id,
      visualizationTitle: viz.title,
      highlightIndices: _tapped.toList(),
    );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: List.generate(
          viz.arrayLength,
          (index) => _buildTapCell(scheme, textTheme, viz, step, previousIndices, labels, index),
        ),
      ),
    );
  }

  /// Same tappable cells as [_buildArrayVisualization], arranged in a fixed
  /// grid instead of a wrapping row — for algorithms whose data is
  /// genuinely 2D (e.g. Matrix Traversal) rather than a flat array.
  Widget _buildMatrixTapVisualization(ColorScheme scheme, TextTheme textTheme, AlgorithmVisualization viz) {
    final step = viz.steps[_stepIndex];
    final previousIndices = step.previousIndices.toSet();
    final labels = PointerLabels.forStep(
      algorithmId: widget.algorithm.id,
      visualizationTitle: viz.title,
      highlightIndices: _tapped.toList(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int row = 0; row < MatrixLayout.rows; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int col = 0; col < MatrixLayout.cols; col++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: _buildTapCell(
                      scheme,
                      textTheme,
                      viz,
                      step,
                      previousIndices,
                      labels,
                      row * MatrixLayout.cols + col,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTapCell(
    ColorScheme scheme,
    TextTheme textTheme,
    AlgorithmVisualization viz,
    VisualizationStep step,
    Set<int> previousIndices,
    Map<int, String> labels,
    int index,
  ) {
    final isSelected = _tapped.contains(index);
    final wasPrevious = previousIndices.contains(index) && !isSelected;
    final isWrongFlash = _wrong && !isSelected;
    final isRemoved = step.removedIndices.contains(index);
    final label = labels[index];

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
            child: label == null
                ? null
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _stepComplete ? context.appColors.success : scheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      label,
                      style: textTheme.labelMedium?.copyWith(color: scheme.onPrimary, fontSize: 10),
                    ),
                  ),
          ),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isRemoved
                  ? scheme.errorContainer
                  : isSelected
                      ? (_stepComplete ? context.appColors.success : scheme.primary)
                      : wasPrevious
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: isWrongFlash ? Border.all(color: scheme.error, width: 2) : null,
            ),
            child: Center(
              child: Text(
                '${viz.valueAtStep(index, step)}',
                style: textTheme.titleMedium?.copyWith(
                  color: isRemoved
                      ? scheme.onErrorContainer
                      : isSelected
                          ? scheme.onPrimary
                          : scheme.onSurface,
                  decoration: isRemoved ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 14,
            child: isRemoved
                ? Text('removed', style: textTheme.labelMedium?.copyWith(fontSize: 10, color: scheme.error))
                : wasPrevious
                    ? Text('prev', style: textTheme.labelMedium?.copyWith(fontSize: 10))
                    : null,
          ),
        ],
      ),
    );
  }

  /// Once a step is fully solved, show one row per pointer instead of both
  /// highlights crammed into a shared row — safe to reveal now since the
  /// user has already found every index correctly.
  Widget _buildPointerArrayRows(ColorScheme scheme, TextTheme textTheme, AlgorithmVisualization viz) {
    final step = viz.steps[_stepIndex];
    final indices = _tapped.toList()..sort();
    final labels = PointerLabels.forStep(
      algorithmId: widget.algorithm.id,
      visualizationTitle: viz.title,
      highlightIndices: indices,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < indices.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.appColors.success,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  labels[indices[i]] ?? 'Pointer ${i + 1}',
                  style: textTheme.labelMedium?.copyWith(color: scheme.onPrimary),
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: List.generate(viz.arrayLength, (index) {
                  final isThisPointer = index == indices[i];
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isThisPointer ? context.appColors.success : scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Center(
                      child: Text(
                        '${viz.valueAtStep(index, step)}',
                        style: textTheme.titleMedium?.copyWith(
                          color: isThisPointer ? scheme.onPrimary : scheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTreeVisualization(ColorScheme scheme, TextTheme textTheme) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(300, 280),
            painter: TreeReviewPainter(
              _tapped.toSet(),
              lineColor: scheme.outlineVariant,
            ),
          ),
          ..._buildTreeNodes(scheme, textTheme),
        ],
      ),
    );
  }

  List<Widget> _buildTreeNodes(ColorScheme scheme, TextTheme textTheme) {
    final previousIndices = _selected!.steps[_stepIndex].previousIndices.toSet();
    final labels = PointerLabels.forStep(
      algorithmId: widget.algorithm.id,
      visualizationTitle: _selected!.title,
      highlightIndices: _tapped.toList(),
    );
    final List<Widget> nodes = [];
    for (int i = 0; i < _treeValues.length; i++) {
      final position = _getNodePosition(i);
      final isSelected = _tapped.contains(i);
      final wasPrevious = previousIndices.contains(i) && !isSelected;
      final label = labels[i];

      if (label != null) {
        nodes.add(
          Positioned(
            left: position.dx - 20,
            top: position.dy - 28 - 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: _stepComplete ? context.appColors.success : scheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: textTheme.labelMedium?.copyWith(color: scheme.onPrimary, fontSize: 10),
              ),
            ),
          ),
        );
      }

      nodes.add(
        Positioned(
          left: position.dx - 28,
          top: position.dy - 28,
          child: GestureDetector(
            onTap: () => _handleTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? (_stepComplete ? context.appColors.success : scheme.primary)
                    : wasPrevious
                        ? scheme.primaryContainer
                        : scheme.surfaceContainerHigh,
                border: Border.all(
                  color: isSelected ? Colors.transparent : scheme.outlineVariant,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${_treeValues[i]}',
                  style: textTheme.labelLarge?.copyWith(
                    color: isSelected ? scheme.onPrimary : scheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      if (wasPrevious) {
        nodes.add(
          Positioned(
            left: position.dx - 12,
            top: position.dy + 28 + 2,
            child: Text('prev', style: textTheme.labelMedium?.copyWith(fontSize: 10)),
          ),
        );
      }
    }
    return nodes;
  }

  Offset _getNodePosition(int index) {
    const double centerX = 150;
    const double startY = 52;
    const double levelHeight = 88;

    switch (index) {
      case 0: return const Offset(centerX, startY);
      case 1: return const Offset(centerX - 70, startY + levelHeight);
      case 2: return const Offset(centerX + 70, startY + levelHeight);
      case 3: return const Offset(centerX - 105, startY + 2 * levelHeight);
      case 4: return const Offset(centerX - 35, startY + 2 * levelHeight);
      case 5: return const Offset(centerX + 35, startY + 2 * levelHeight);
      case 6: return const Offset(centerX + 105, startY + 2 * levelHeight);
      default: return const Offset(centerX, startY);
    }
  }

  Widget _buildGraphVisualization(ColorScheme scheme, TextTheme textTheme, AlgorithmVisualization viz) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(300, 220),
            painter: GraphReviewPainter(lineColor: scheme.outlineVariant),
          ),
          ..._buildGraphNodes(scheme, textTheme, viz),
        ],
      ),
    );
  }

  List<Widget> _buildGraphNodes(ColorScheme scheme, TextTheme textTheme, AlgorithmVisualization viz) {
    final previousIndices = _selected!.steps[_stepIndex].previousIndices.toSet();
    final labels = PointerLabels.forStep(
      algorithmId: widget.algorithm.id,
      visualizationTitle: viz.title,
      highlightIndices: _tapped.toList(),
    );
    final List<Widget> nodes = [];
    for (int i = 0; i < GraphLayout.nodeCount; i++) {
      final position = GraphLayout.positionFor(i, 300, 220);
      final isSelected = _tapped.contains(i);
      final wasPrevious = previousIndices.contains(i) && !isSelected;
      final label = labels[i];

      if (label != null) {
        nodes.add(
          Positioned(
            left: position.dx - 20,
            top: position.dy - 26 - 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: _stepComplete ? context.appColors.success : scheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: textTheme.labelMedium?.copyWith(color: scheme.onPrimary, fontSize: 10),
              ),
            ),
          ),
        );
      }

      nodes.add(
        Positioned(
          left: position.dx - 26,
          top: position.dy - 26,
          child: GestureDetector(
            onTap: () => _handleTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? (_stepComplete ? context.appColors.success : scheme.primary)
                    : wasPrevious
                        ? scheme.primaryContainer
                        : scheme.surfaceContainerHigh,
                border: Border.all(
                  color: isSelected ? Colors.transparent : scheme.outlineVariant,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${viz.valueAt(i)}',
                  style: textTheme.labelLarge?.copyWith(
                    color: isSelected ? scheme.onPrimary : scheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      if (wasPrevious) {
        nodes.add(
          Positioned(
            left: position.dx - 12,
            top: position.dy + 26 + 2,
            child: Text('prev', style: textTheme.labelMedium?.copyWith(fontSize: 10)),
          ),
        );
      }
    }
    return nodes;
  }
}
