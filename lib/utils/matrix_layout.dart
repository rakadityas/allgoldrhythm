/// Fixed 3x4 grid shape shared by Simulation and Review for the Matrix
/// Traversal algorithm, mirroring how GraphLayout shares a fixed shape for
/// the Graph algorithm. Values are addressed by a single row-major linear
/// index (row * cols + col) so they still fit VisualizationStep's existing
/// `List<int>` highlightIndices/previousIndices/removedIndices.
class MatrixLayout {
  static const int rows = 3;
  static const int cols = 4;
  static const int cellCount = rows * cols;

  static int rowOf(int index) => index ~/ cols;
  static int colOf(int index) => index % cols;
}
