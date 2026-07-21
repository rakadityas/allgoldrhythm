/// Derives a short label ("L", "R", "Mid", "Slow"...) for each currently
/// highlighted index, purely from the algorithm/pattern and how many
/// indices are highlighted right now — no per-step authoring needed. This
/// is what lets the user tell pointers apart step to step instead of just
/// seeing anonymous highlighted boxes.
class PointerLabels {
  /// Algorithms whose highlighted indices represent genuinely distinct,
  /// independently-tracked pointers (left/right, prev/next, node A/B...).
  /// For these, Simulation/Review split into one array row per pointer
  /// instead of cramming multiple highlights into a single row, since
  /// otherwise it's easy to lose track of which highlight is which.
  ///
  /// Deliberately excludes algorithms where multiple highlighted indices
  /// represent one contiguous group instead of separate pointers — e.g.
  /// Sliding Window's window, a Backtracking subset, a Trie path, or a
  /// Sorting comparison pair where adjacency itself is the point.
  static const Set<String> multiRowAlgorithms = {
    'two_pointers',
    'linked_list',
    'doubly_linked_list',
    'circular_linked_list',
    'binary_search',
    'union_find',
    'heap',
  };

  static Map<int, String> forStep({
    required String algorithmId,
    required String visualizationTitle,
    required List<int> highlightIndices,
  }) {
    if (highlightIndices.isEmpty) return const {};
    final indices = [...highlightIndices]..sort();

    switch (algorithmId) {
      case 'two_pointers':
        if (visualizationTitle == 'Fast-Slow Two Pointers') {
          if (indices.length == 2) return {indices[0]: 'Slow', indices[1]: 'Fast'};
          if (indices.length == 1) return {indices[0]: 'Slow/Fast'};
        }
        if (visualizationTitle == 'Same Direction Two Pointers') {
          if (indices.length == 2) return {indices[0]: 'Write', indices[1]: 'Read'};
          if (indices.length == 1) return {indices[0]: 'Write/Read'};
        }
        if (visualizationTitle == 'Three Pointers' && indices.length == 3) {
          return {indices[0]: 'P1', indices[1]: 'P2', indices[2]: 'P3'};
        }
        if (visualizationTitle == 'Partition Array') {
          return {indices[0]: 'Mid'};
        }
        if (indices.length == 2) return {indices[0]: 'L', indices[1]: 'R'};
        if (indices.length == 1) return {indices[0]: 'Ptr'};
        return const {};

      case 'sliding_window':
        if (indices.length >= 2) return {indices.first: 'Start', indices.last: 'End'};
        return {indices[0]: 'Start'};

      case 'stack':
        return indices.length == 1 ? {indices[0]: 'Top'} : const {};

      case 'queue':
        return indices.length == 1 ? {indices[0]: 'Rear'} : const {};

      case 'linked_list':
      case 'doubly_linked_list':
      case 'circular_linked_list':
        if (indices.length == 1) return {indices[0]: 'Current'};
        if (indices.length == 2) return {indices[0]: 'Prev', indices[1]: 'Next'};
        return const {};

      case 'binary_search':
        if (indices.length == 2) return {indices[0]: 'L', indices[1]: 'R'};
        if (indices.length == 1) return {indices[0]: 'Mid'};
        return const {};

      case 'trees':
      case 'graph':
      case 'matrix_traversal':
        return indices.length == 1 ? {indices[0]: 'Visiting'} : const {};

      case 'heap':
        if (indices.length == 3) return {indices[0]: 'Node', indices[1]: 'Child', indices[2]: 'Child'};
        if (indices.length == 2) return {indices[0]: 'Node', indices[1]: 'Child'};
        return indices.length == 1 ? {indices[0]: 'Node'} : const {};

      case 'hashing':
        return indices.length == 1 ? {indices[0]: 'Scan'} : const {};

      case 'dynamic_programming':
        return indices.length == 1 ? {indices[0]: 'dp[i]'} : const {};

      case 'union_find':
        return indices.length == 2 ? {indices[0]: 'A', indices[1]: 'B'} : const {};

      case 'bit_manipulation':
        return indices.length == 1 ? {indices[0]: 'XOR'} : const {};

      case 'math_geometry':
        if (visualizationTitle == 'Euclidean GCD') {
          if (indices.length == 2) return {indices[0]: 'a', indices[1]: 'b'};
          if (indices.length == 1) return {indices[0]: 'gcd'};
        }
        // Sieve: single highlight is the current prime candidate; a group of
        // highlights is the batch of multiples being crossed out (no labels).
        if (visualizationTitle == 'Sieve of Eratosthenes' && indices.length == 1) {
          return {indices[0]: 'p'};
        }
        return const {};

      default:
        return const {};
    }
  }
}
