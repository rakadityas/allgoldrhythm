import 'dart:math';
import 'package:flutter/material.dart';
import '../models/system_design.dart';
import '../theme/app_theme.dart';

/// A static, read-only architecture diagram — the "pre-drawn board" used to
/// illustrate a system design fundamental. Reuses the same [ComponentType]
/// icons and arrow-connection visual language as the interactive
/// [DesignCanvas] so fundamentals and practice problems feel like one
/// consistent tool, but nothing here is draggable: it just lays components
/// out left-to-right in reading order and draws arrows between them.
class ArchitectureDiagram extends StatelessWidget {
  final List<ComponentType> components;
  final List<(ComponentType, ComponentType)> connections;
  final int columns;

  const ArchitectureDiagram({
    super.key,
    required this.components,
    required this.connections,
    this.columns = 3,
  });

  static const double _slotWidth = 140;
  static const double _slotHeight = 100;
  static const double _nodeSize = 56;

  Offset _centerFor(int index) {
    final col = index % columns;
    final row = index ~/ columns;
    return Offset(
      col * _slotWidth + _slotWidth / 2,
      row * _slotHeight + _slotHeight / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cols = min(columns, components.length).clamp(1, columns);
    final rows = (components.length / cols).ceil();
    final size = Size(cols * _slotWidth, rows * _slotHeight);
    final positions = [for (int i = 0; i < components.length; i++) _centerFor(i)];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              CustomPaint(
                size: size,
                painter: _DiagramConnectionPainter(
                  types: components,
                  positions: positions,
                  connections: connections,
                  color: theme.colorScheme.primary,
                ),
              ),
              for (int i = 0; i < components.length; i++)
                Positioned(
                  left: positions[i].dx - _slotWidth / 2,
                  top: positions[i].dy - _nodeSize / 2 - 8,
                  width: _slotWidth,
                  child: _DiagramNode(type: components[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagramNode extends StatelessWidget {
  final ComponentType type;
  const _DiagramNode({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ArchitectureDiagram._nodeSize,
          height: ArchitectureDiagram._nodeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primaryContainer,
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
          ),
          child: Icon(type.icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 4),
        Text(
          type.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class _DiagramConnectionPainter extends CustomPainter {
  final List<ComponentType> types;
  final List<Offset> positions;
  final List<(ComponentType, ComponentType)> connections;
  final Color color;

  _DiagramConnectionPainter({
    required this.types,
    required this.positions,
    required this.connections,
    required this.color,
  });

  int? _indexOf(ComponentType type) {
    final i = types.indexOf(type);
    return i == -1 ? null : i;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = color;

    for (final pair in connections) {
      final fromIndex = _indexOf(pair.$1);
      final toIndex = _indexOf(pair.$2);
      if (fromIndex == null || toIndex == null) continue;

      final fromCenter = positions[fromIndex];
      final toCenter = positions[toIndex];
      final direction = toCenter - fromCenter;
      final distance = direction.distance;
      if (distance == 0) continue;
      final unit = direction / distance;
      final start = fromCenter + unit * 32;
      final end = toCenter - unit * 32;

      canvas.drawLine(start, end, linePaint);

      const arrowSize = 9.0;
      final angle = atan2(unit.dy, unit.dx);
      final p1 = end -
          Offset(cos(angle - 0.5) * arrowSize, sin(angle - 0.5) * arrowSize);
      final p2 = end -
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
  bool shouldRepaint(covariant _DiagramConnectionPainter oldDelegate) => true;
}
