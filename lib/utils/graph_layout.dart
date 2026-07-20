import 'package:flutter/material.dart';

/// Fixed 6-node graph layout (2 rows of 3) shared by the Simulation and
/// Review widgets for the Graph algorithm, mirroring how TreePainter shares
/// a fixed tree shape for the Trees algorithm.
class GraphLayout {
  static const int nodeCount = 6;

  static const List<List<int>> edges = [
    [0, 1],
    [1, 2],
    [0, 3],
    [1, 4],
    [2, 5],
    [3, 4],
    [4, 5],
  ];

  /// Node position within a canvas of the given [width]/[height], laid out
  /// as two rows of three.
  static Offset positionFor(int index, double width, double height) {
    final row = index < 3 ? 0 : 1;
    final col = index % 3;
    final x = width * (col + 1) / 4;
    final y = height * (row == 0 ? 0.3 : 0.7);
    return Offset(x, y);
  }
}
