# AllGoldRhythm — Technical Backlog (Architect review)

Reviewed as: Technical Architect, auditing the Flutter codebase
(`allgoldrhythm/`) for structural issues independent of content. Baseline:
`flutter analyze` is clean (0 issues) and the existing widget-test suite
(parametrized over every algorithm/concept/problem) passes — code hygiene is
already good, so this list is about gaps, not cleanup of existing mess.

## P0 — implemented

1. **Unused dependencies.** `flutter_svg`, `animated_text_kit`, and
   `shared_preferences` are declared in `pubspec.yaml` but never imported
   anywhere in `lib/` (`provider` is also declared but was never wired up as
   `ChangeNotifierProvider`/`Consumer` — only string-matched by grep because
   the word "provider" appears in unrelated curriculum text). Unused deps
   inflate build size, widen the update/CVE surface, and mislead future
   contributors into thinking there's SVG/animation/persistence support that
   doesn't exist.
   → Removed `flutter_svg` and `animated_text_kit` (no call sites, no product
   need identified). Put `shared_preferences` and `provider` to actual use
   (see item 2) rather than removing them, since the product backlog's
   progress-tracking feature needs exactly this combination.

2. **No state-management/persistence layer.** Every screen is `Stateless` or
   holds purely ephemeral `State` (quiz score resets on navigation away,
   design-canvas layout is lost on back-navigation, etc.) — there is no place
   to put anything that should survive a session. This blocks the product
   backlog's #1 priority (progress tracking) and would block any future
   feature needing durable state (bookmarks, theme override, canvas
   autosave).
   → Added `lib/services/progress_store.dart`: a `ChangeNotifier` backed by
   `SharedPreferences`, storing best quiz score per (domain, id). Wired via
   `ChangeNotifierProvider` at the app root in `main.dart`. `main()` is now
   `async` and awaits `ProgressStore.create()` before `runApp`, since
   `SharedPreferences.getInstance()` is async — this is the standard Flutter
   pattern for pre-loading persisted state before first frame.

3. **`QuizView` is a good, decoupled reusable component — kept it that way.**
   Rather than reaching into `Provider` from inside `QuizView` (which would
   force every current and future call site to sit under a `ProgressStore`
   provider, including tests that don't need it), added an optional
   `onCompleted(score, total)` callback. The two call sites (`AlgorithmQuiz`,
   `FundamentalDetailScreen`'s quiz tab) supply it and do the
   `context.read<ProgressStore>()` call themselves. This keeps `QuizView`
   framework-agnostic and matches its existing doc comment ("both just supply
   their own question list").

4. **Test suite needed updating for the `MyApp` constructor change and new
   Provider dependency.** `main()`'s signature change means `const MyApp()`
   no longer compiles as-is in `widget_test.dart`. Updated the suite to mock
   `SharedPreferences` (`SharedPreferences.setMockInitialValues({})`) and
   construct a real `ProgressStore` per test, wrapping screens under test in
   `ChangeNotifierProvider<ProgressStore>.value` where they weren't already
   under `MyApp`. Added new coverage for: quiz completion persisting a
   result, progress badges rendering on list cards, and the home-screen
   progress summary.

5. **`AlgorithmPythonExamples` only covered 7 of 21 algorithm ids** — the
   other 14 silently rendered an empty state, and the dispatch was a raw
   `switch` in `CodeExamplesScreen` rather than living alongside the data
   itself. This was really a content gap (see Product Backlog #6) but it also
   meant the "does every algorithm have code" question could only be answered
   by reading a `switch` statement in a screen file, not the data layer.
   → Filled in the missing 14 categories and added a single
   `AlgorithmPythonExamples.examplesFor(id)` dispatcher in the data file
   itself, so "which algorithms have code" is now answerable by reading one
   place, and callers don't need their own id-to-getter switch.

6. **Code examples lived in their own `Scaffold`-based screen
   (`CodeExamplesScreen`), reached only via an app-bar icon**, rather than as
   a tab alongside Overview/Simulation/Review/Quiz. This was both a UX
   inconsistency (Product Backlog #7) and a structural one: the detail
   screen's tab flow and the code-examples screen were two separate
   navigation stacks for what is conceptually one learning flow per
   algorithm.
   → Extracted the code-viewing UI (variant dropdown + code block, minus its
   `Scaffold`/`AppBar`) into a reusable `lib/widgets/algorithm_code_view.dart`
   and mounted it as a fifth tab in `AlgorithmDetailScreen`. Deleted
   `lib/screens/code_examples_screen.dart` — nothing else referenced it.

7. **Stray `.idea/` project files at the outer `allgoldrhythm_project/`
   directory**, one level above the actual Flutter project and its git repo
   (`allgoldrhythm_project/allgoldrhythm/`). These weren't tracked by any VCS
   (the outer folder isn't a git repo) and aren't referenced by any build
   tooling — they're leftover IDE state from opening the outer folder
   directly at some point, and they invite confusion about which directory
   is actually "the project."
   → Removed `allgoldrhythm_project/.idea/` and its `.iml`. The real
   project's own `.idea/` (inside `allgoldrhythm/`) is untouched — it's
   already correctly gitignored there (`.idea/` is in
   `allgoldrhythm/.gitignore`) and is the one an IDE should open.

8. **`fundamentals_data.dart`/`fundamentals_quiz_data.dart` grew from 28 to 73
   concepts** (see PRODUCT_BACKLOG.md item 10) without changing their
   structure — `FundamentalsData.getConcepts()` gained 7 new category-list
   spreads, and `FundamentalsQuizData._bank` gained 45 new entries, all
   following the exact existing pattern (`static const _categoryName = [...]`
   lists, `id → questions` map). No model or screen changes were needed for
   this — `FundamentalConcept` and `QuizQuestion` already generalized cleanly
   to the new content, which is a good sign the original data model was
   well-designed. Verified with `flutter analyze` after every batch (14
   batches total) rather than one large edit, to keep any mistakes localized
   and cheap to fix, plus a script check that every concept `id` has exactly
   one matching entry in the quiz bank (73/73, no duplicates, no orphans).

## P1 — documented, not implemented this pass

- `ProgressStore` stores results as a manually-delimited string
  (`"$score|$total|$isoDate"`) rather than JSON, to avoid pulling in
  `dart:convert`'s extra ceremony for a 3-field record. If more fields get
  added later (e.g. "reviewed" status per P1 product item), switch this to
  `jsonEncode`/`jsonDecode` before it gets unwieldy.
- No integration/golden tests for the design canvas's drag-and-drop
  interactions — the existing test suite exercises "Check Design" and "Show
  Solution" but not actual drag gestures. Flutter's `Draggable`/`DragTarget`
  are awkward to drive in `WidgetTester` (no built-in drag-and-drop helper);
  would need a small test utility.
- `ComponentType` enum lives in `lib/models/system_design.dart` and is now
  referenced by 5 problems' `ReferenceArchitecture`s — fine at this size, but
  if the P2 product backlog item (growing to 15-20 problems) happens, worth
  reconsidering whether new component types are needed (e.g. a
  `webSocketServer` or `searchIndex` type) rather than overloading existing
  ones.
- `algorithm_python_examples.dart` is now a ~2000+ line single file covering
  all 21 patterns. Fine for now; if it keeps growing (multiple languages per
  pattern, per the product backlog's language-picker P1 item), consider
  splitting per-category or moving to loaded content files (see the
  `lib/data/*.dart` note below).

## P2 — future

- CI: no GitHub Actions / CI config exists in the repo. Recommend a basic
  `flutter analyze && flutter test` workflow so this backlog's "clean
  analyze, passing tests" baseline doesn't silently regress.
- `lib/data/*.dart` files (up to ~2000 lines each) are large generated-feeling
  literal lists. Fine for now, but if content keeps growing per the P2
  product backlog, consider moving to JSON/YAML content files loaded at
  build/runtime instead of Dart literals, so non-engineers can contribute
  content without touching `.dart` files.
