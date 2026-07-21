import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:allgoldrhythm/services/progress_store.dart';

/// Store-level tests for progress recording. The design-canvas completion
/// path can't be widget-tested headless (the palette drag gesture doesn't
/// register in the test harness — see README), so the store is the testable
/// seam for the designProblem domain.
void main() {
  Future<ProgressStore> freshStore() async {
    SharedPreferences.setMockInitialValues({});
    return ProgressStore.create();
  }

  test('designProblem results round-trip and count as progress', () async {
    final store = await freshStore();
    expect(store.resultFor(ProgressDomain.designProblem, 'url_shortener'), isNull);

    await store.recordQuizResult(ProgressDomain.designProblem, 'url_shortener', 11, 11);

    final result = store.resultFor(ProgressDomain.designProblem, 'url_shortener');
    expect(result, isNotNull);
    expect(result!.score, 11);
    expect(result.total, 11);
    expect(store.hasAnyProgress, isTrue);
    expect(store.completedCount(ProgressDomain.designProblem, ['url_shortener', 'web_crawler']), 1);
  });

  test('domains with the same id do not collide', () async {
    final store = await freshStore();
    await store.recordQuizResult(ProgressDomain.algorithm, 'same_id', 5, 15);
    await store.recordQuizResult(ProgressDomain.fundamental, 'same_id', 3, 5);

    expect(store.resultFor(ProgressDomain.algorithm, 'same_id')!.total, 15);
    expect(store.resultFor(ProgressDomain.fundamental, 'same_id')!.total, 5);
    expect(store.resultFor(ProgressDomain.designProblem, 'same_id'), isNull);
  });

  test('allResults parses (domain, id) back out of storage keys', () async {
    final store = await freshStore();
    await store.recordQuizResult(ProgressDomain.algorithm, 'two_pointers', 10, 15);
    await store.recordQuizResult(ProgressDomain.fundamental, 'cap_theorem', 4, 5);
    await store.recordQuizResult(ProgressDomain.designProblem, 'video_platform', 18, 18);

    final entries = store.allResults;
    expect(entries, hasLength(3));
    final byDomain = {for (final (d, id, r) in entries) d: (id, r)};
    expect(byDomain[ProgressDomain.algorithm]!.$1, 'two_pointers');
    expect(byDomain[ProgressDomain.fundamental]!.$1, 'cap_theorem');
    expect(byDomain[ProgressDomain.designProblem]!.$1, 'video_platform');
    expect(byDomain[ProgressDomain.algorithm]!.$2.score, 10);
  });

  test('lower scores never overwrite a better recorded attempt', () async {
    final store = await freshStore();
    await store.recordQuizResult(ProgressDomain.algorithm, 'heap', 12, 15);
    await store.recordQuizResult(ProgressDomain.algorithm, 'heap', 8, 15);

    expect(store.resultFor(ProgressDomain.algorithm, 'heap')!.score, 12);
  });

  test('resetAll clears every domain', () async {
    final store = await freshStore();
    await store.recordQuizResult(ProgressDomain.algorithm, 'heap', 12, 15);
    await store.recordQuizResult(ProgressDomain.designProblem, 'file_storage', 14, 14);

    await store.resetAll();

    expect(store.hasAnyProgress, isFalse);
    expect(store.allResults, isEmpty);
    expect(store.resultFor(ProgressDomain.designProblem, 'file_storage'), isNull);
  });
}
