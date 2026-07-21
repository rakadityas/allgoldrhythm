import 'dart:math';
import 'package:flutter/material.dart';
import '../models/system_design.dart';
import '../theme/app_theme.dart';

const double _nodeSize = 76;
const Size _canvasSize = Size(1000, 720);

class DesignCanvas extends StatefulWidget {
  final SystemDesignProblem problem;

  const DesignCanvas({super.key, required this.problem});

  @override
  State<DesignCanvas> createState() => _DesignCanvasState();
}

class _DesignCanvasState extends State<DesignCanvas> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<PlacedComponent> _placed = [];
  final List<Connection> _connections = [];
  bool _connectMode = false;
  String? _connectFrom;
  bool _showReference = false;
  _ValidationResult? _result;
  int _nextId = 0;

  void _addComponent(ComponentType type, Offset localPosition) {
    setState(() {
      _placed.add(
        PlacedComponent(
          id: 'c${_nextId++}',
          type: type,
          position: Offset(
            (localPosition.dx - _nodeSize / 2).clamp(
              0,
              _canvasSize.width - _nodeSize,
            ),
            (localPosition.dy - _nodeSize / 2).clamp(
              0,
              _canvasSize.height - _nodeSize,
            ),
          ),
        ),
      );
      _result = null;
    });
  }

  void _deleteComponent(String id) {
    final removedIndex = _placed.indexWhere((p) => p.id == id);
    if (removedIndex == -1) return;
    final removedComponent = _placed[removedIndex];
    final removedConnections = _connections
        .where((c) => c.fromId == id || c.toId == id)
        .toList();

    setState(() {
      _placed.removeAt(removedIndex);
      _connections.removeWhere((c) => c.fromId == id || c.toId == id);
      if (_connectFrom == id) _connectFrom = null;
      _result = null;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Removed ${removedComponent.type.label}'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _placed.insert(removedIndex, removedComponent);
                _connections.addAll(removedConnections);
                _result = null;
              });
            },
          ),
        ),
      );
  }

  void _handleTapComponent(String id) {
    if (!_connectMode) return;
    setState(() {
      if (_connectFrom == null) {
        _connectFrom = id;
      } else if (_connectFrom == id) {
        _connectFrom = null;
      } else {
        final exists = _connections.any(
          (c) => c.fromId == _connectFrom && c.toId == id,
        );
        if (!exists) {
          _connections.add(Connection(fromId: _connectFrom!, toId: id));
        }
        _connectFrom = null;
        _result = null;
      }
    });
  }

  void _clearCanvas() {
    setState(() {
      _placed.clear();
      _connections.clear();
      _connectFrom = null;
      _result = null;
    });
  }

  void _checkDesign() {
    final placedTypes = _placed.map((p) => p.type).toSet();
    final missingComponents = widget.problem.reference.components
        .where((t) => !placedTypes.contains(t))
        .toSet()
        .toList();

    final placedTypePairs = _connections.map((c) {
      final from = _placed.firstWhere((p) => p.id == c.fromId);
      final to = _placed.firstWhere((p) => p.id == c.toId);
      return (from.type, to.type);
    }).toSet();
    final missingConnections = widget.problem.reference.connections
        .where((pair) => !placedTypePairs.contains(pair))
        .toList();

    setState(() {
      _result = _ValidationResult(
        missingComponents: missingComponents,
        missingConnections: missingConnections,
        totalComponents: widget.problem.reference.components.length,
        totalConnections: widget.problem.reference.connections.length,
      );
      _connectMode = false;
      _connectFrom = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drag components onto the canvas',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 68,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ComponentType.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final type = ComponentType.values[i];
                return Draggable<ComponentType>(
                  data: type,
                  feedback: _ComponentChip(type: type, dragging: true),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: _ComponentChip(type: type),
                  ),
                  child: _ComponentChip(type: type),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => setState(() {
                  _connectMode = !_connectMode;
                  _connectFrom = null;
                }),
                icon: Icon(_connectMode ? Icons.close : Icons.timeline),
                label: Text(_connectMode ? 'Cancel Connecting' : 'Connect'),
              ),
              OutlinedButton.icon(
                onPressed: _placed.isEmpty ? null : _clearCanvas,
                icon: const Icon(Icons.refresh),
                label: const Text('Clear'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    setState(() => _showReference = !_showReference),
                icon: Icon(
                  _showReference
                      ? Icons.visibility_off
                      : Icons.lightbulb_outline,
                ),
                label: Text(_showReference ? 'Hide Solution' : 'Show Solution'),
              ),
              FilledButton.icon(
                onPressed: _placed.isEmpty ? null : _checkDesign,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Check Design'),
              ),
            ],
          ),
          if (_connectMode) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _connectFrom == null
                  ? 'Tap a component to start a connection.'
                  : 'Now tap the component it connects to.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (_showReference) ...[
            _ReferencePanel(problem: widget.problem),
            const SizedBox(height: AppSpacing.md),
          ],
          if (_result != null) ...[
            _ResultPanel(result: _result!),
            const SizedBox(height: AppSpacing.md),
          ],
          SizedBox(
            height: 460,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                color: theme.colorScheme.surfaceContainerLow,
                child: InteractiveViewer(
                  constrained: false,
                  minScale: 0.4,
                  maxScale: 1.5,
                  boundaryMargin: const EdgeInsets.all(40),
                  child: DragTarget<ComponentType>(
                    onAcceptWithDetails: (details) {
                      final box =
                          _canvasKey.currentContext!.findRenderObject()
                              as RenderBox;
                      final local = box.globalToLocal(details.offset);
                      _addComponent(details.data, local);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return SizedBox(
                        key: _canvasKey,
                        width: _canvasSize.width,
                        height: _canvasSize.height,
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: _canvasSize,
                              painter: _GridPainter(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            CustomPaint(
                              size: _canvasSize,
                              painter: _ConnectionPainter(
                                placed: _placed,
                                connections: _connections,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            if (_placed.isEmpty)
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    'Drag a component from above and drop it here',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                            for (final c in _placed)
                              Positioned(
                                left: c.position.dx,
                                top: c.position.dy,
                                child: Semantics(
                                  label: '${c.type.label} component'
                                      '${_connectFrom == c.id ? ", selected as connection start" : ""}',
                                  hint: _connectMode
                                      ? 'Double tap to ${_connectFrom == null ? "start a connection from here" : "connect to here"}'
                                      : 'Long press to remove',
                                  button: true,
                                  child: GestureDetector(
                                  onTap: () => _handleTapComponent(c.id),
                                  onLongPress: () => _deleteComponent(c.id),
                                  child: Draggable<String>(
                                    data: c.id,
                                    feedback: _NodeChip(
                                      type: c.type,
                                      selected: false,
                                    ),
                                    childWhenDragging: const Opacity(
                                      opacity: 0.3,
                                      child: SizedBox(
                                        width: _nodeSize,
                                        height: _nodeSize,
                                      ),
                                    ),
                                    onDragEnd: (details) {
                                      final box =
                                          _canvasKey.currentContext!
                                                  .findRenderObject()
                                              as RenderBox;
                                      final local = box.globalToLocal(
                                        details.offset,
                                      );
                                      setState(() {
                                        c.position = Offset(
                                          local.dx.clamp(
                                            0,
                                            _canvasSize.width - _nodeSize,
                                          ),
                                          local.dy.clamp(
                                            0,
                                            _canvasSize.height - _nodeSize,
                                          ),
                                        );
                                      });
                                    },
                                    child: _NodeChip(
                                      type: c.type,
                                      selected: _connectFrom == c.id,
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tip: pinch or scroll to pan the canvas. Long-press a component to delete it.',
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _ComponentChip extends StatelessWidget {
  final ComponentType type;
  final bool dragging;

  const _ComponentChip({required this.type, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: dragging ? 4 : 0,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      color: theme.colorScheme.surfaceContainerHigh,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(type.label, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _NodeChip extends StatelessWidget {
  final ComponentType type;
  final bool selected;

  const _NodeChip({required this.type, required this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: _nodeSize,
      height: _nodeSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primaryContainer,
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: 2,
              ),
            ),
            child: Icon(
              type.icon,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            type.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ConnectionPainter extends CustomPainter {
  final List<PlacedComponent> placed;
  final List<Connection> connections;
  final Color color;

  _ConnectionPainter({
    required this.placed,
    required this.connections,
    required this.color,
  });

  PlacedComponent? _find(String id) {
    for (final p in placed) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = color;

    for (final conn in connections) {
      final from = _find(conn.fromId);
      final to = _find(conn.toId);
      if (from == null || to == null) continue;

      final fromCenter =
          from.position + const Offset(_nodeSize / 2, _nodeSize / 2);
      final toCenter = to.position + const Offset(_nodeSize / 2, _nodeSize / 2);

      final direction = (toCenter - fromCenter);
      final distance = direction.distance;
      if (distance == 0) continue;
      final unit = direction / distance;
      final start = fromCenter + unit * 30;
      final end = toCenter - unit * 30;

      canvas.drawLine(start, end, linePaint);

      const arrowSize = 9.0;
      final angle = atan2(unit.dy, unit.dx);
      final p1 =
          end -
          Offset(cos(angle - 0.5) * arrowSize, sin(angle - 0.5) * arrowSize);
      final p2 =
          end -
          Offset(cos(angle + 0.5) * arrowSize, sin(angle + 0.5) * arrowSize);
      final path = Path()
        ..moveTo(end.dx, end.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();
      canvas.drawPath(path, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter oldDelegate) => true;
}

class _ValidationResult {
  final List<ComponentType> missingComponents;
  final List<(ComponentType, ComponentType)> missingConnections;
  final int totalComponents;
  final int totalConnections;

  _ValidationResult({
    required this.missingComponents,
    required this.missingConnections,
    required this.totalComponents,
    required this.totalConnections,
  });

  bool get isPerfect => missingComponents.isEmpty && missingConnections.isEmpty;
}

class _ResultPanel extends StatelessWidget {
  final _ValidationResult result;
  const _ResultPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foundComponents =
        result.totalComponents - result.missingComponents.length;
    final foundConnections =
        result.totalConnections - result.missingConnections.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: result.isPerfect
            ? context.appColors.success.withValues(alpha: 0.15)
            : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isPerfect ? Icons.check_circle : Icons.info_outline,
                color: result.isPerfect
                    ? context.appColors.success
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                result.isPerfect
                    ? 'Matches the reference architecture!'
                    : 'Components: $foundComponents/${result.totalComponents} · Connections: $foundConnections/${result.totalConnections}',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          if (result.missingComponents.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Missing components: ${result.missingComponents.map((c) => c.label).join(", ")}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
          if (result.missingConnections.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Missing connections: ${result.missingConnections.map((c) => "${c.$1.label} → ${c.$2.label}").join(", ")}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReferencePanel extends StatelessWidget {
  final SystemDesignProblem problem;
  const _ReferencePanel({required this.problem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reference architecture', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: problem.reference.components
                .map((c) => _ComponentChip(type: c))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...problem.reference.connections.map(
            (pair) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${pair.$1.label} → ${pair.$2.label}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
