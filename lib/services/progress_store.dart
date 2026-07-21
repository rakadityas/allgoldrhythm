import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which content track a result belongs to. Ids aren't guaranteed unique
/// across tracks, so results are keyed by (domain, id) rather than id alone.
/// [designProblem] records design-canvas checks that fully matched the
/// reference architecture (score = matched items, total = reference items).
enum ProgressDomain { algorithm, fundamental, designProblem }

/// The best recorded attempt at a given quiz.
@immutable
class QuizResult {
  final int score;
  final int total;
  final DateTime completedAt;

  const QuizResult({
    required this.score,
    required this.total,
    required this.completedAt,
  });

  double get percent => total == 0 ? 0 : score / total;
}

/// Persists quiz results (best score per algorithm/concept) across app
/// launches via [SharedPreferences], and notifies listeners when a new
/// result is recorded so list/summary UI can update live.
///
/// Storage format is a simple pipe-delimited string per key
/// (`"$score|$total|$isoTimestamp"`) rather than JSON — see TECH_BACKLOG.md
/// for why, and when to revisit that.
class ProgressStore extends ChangeNotifier {
  static const _prefsPrefix = 'agr_quiz_result_';

  final SharedPreferences _prefs;
  final Map<String, QuizResult> _results = {};

  ProgressStore._(this._prefs) {
    _loadAll();
  }

  /// Creates a [ProgressStore] backed by the real, persisted
  /// [SharedPreferences] instance. Call once at app startup, before
  /// `runApp`.
  static Future<ProgressStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressStore._(prefs);
  }

  String _keyFor(ProgressDomain domain, String id) => '$_prefsPrefix${domain.name}_$id';

  void _loadAll() {
    for (final key in _prefs.getKeys()) {
      if (!key.startsWith(_prefsPrefix)) continue;
      final result = _decode(_prefs.getString(key));
      if (result != null) _results[key] = result;
    }
  }

  QuizResult? _decode(String? raw) {
    if (raw == null) return null;
    final parts = raw.split('|');
    if (parts.length != 3) return null;
    final score = int.tryParse(parts[0]);
    final total = int.tryParse(parts[1]);
    final completedAt = DateTime.tryParse(parts[2]);
    if (score == null || total == null || completedAt == null) return null;
    return QuizResult(score: score, total: total, completedAt: completedAt);
  }

  String _encode(QuizResult result) =>
      '${result.score}|${result.total}|${result.completedAt.toIso8601String()}';

  /// The best result recorded for this quiz, or `null` if it's never been
  /// completed.
  QuizResult? resultFor(ProgressDomain domain, String id) => _results[_keyFor(domain, id)];

  /// Records a completed quiz attempt, keeping the highest-scoring attempt
  /// (by raw score) if one already exists. Persists to disk and notifies
  /// listeners only when the stored result actually changes.
  Future<void> recordQuizResult(ProgressDomain domain, String id, int score, int total) async {
    final key = _keyFor(domain, id);
    final existing = _results[key];
    if (existing != null && existing.score >= score) return;

    final result = QuizResult(score: score, total: total, completedAt: DateTime.now());
    _results[key] = result;
    await _prefs.setString(key, _encode(result));
    notifyListeners();
  }

  /// How many of [ids] have at least one recorded result in [domain].
  /// Used for "X/Y completed" progress summaries.
  int completedCount(ProgressDomain domain, Iterable<String> ids) =>
      ids.where((id) => resultFor(domain, id) != null).length;

  /// Whether any quiz result has ever been recorded. Used to disable the
  /// "Reset Progress" action when there's nothing to reset.
  bool get hasAnyProgress => _results.isNotEmpty;

  /// Clears every recorded quiz result, both in memory and on disk. This is
  /// the only way to reset progress today (see PRODUCT_BACKLOG.md) — there's
  /// no per-item reset, only "clear everything".
  Future<void> resetAll() async {
    final keys = _results.keys.toList();
    _results.clear();
    for (final key in keys) {
      await _prefs.remove(key);
    }
    notifyListeners();
  }
}
