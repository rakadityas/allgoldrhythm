# AllGoldRhythm — Product Backlog (PM review)

Reviewed as: Product Manager, evaluating UI/UX and content thoroughness for the
DS&A and System Design (theory-only) tracks against a "production ready,
user-friendly, complete" bar, using hellointerview.com's case-study structure
(functional/non-functional requirements → capacity estimation → API → high-level
design → reference architecture) as the quality benchmark. The three curricula
left in `theory/` (system design, monitoring, security) were extracted and used
to cross-check topic coverage.

Current state: 21 DSA patterns (each with Overview/Simulation/Code/Review/Quiz),
**73** system-design fundamentals (each with theory + quiz) across 21
categories, and 5 system-design practice problems.

## P0 — implemented

1. **Only 2 system design practice problems.** hellointerview's case-study
   library runs ~15-20 problems; 2 is not enough to call the "Practice
   Problems" tab complete, and it's the single biggest content gap.
   → Added 3 more full case studies (Design a Distributed Key-Value Cache,
   Design a Chat Application, Design a News Feed), each with the full
   requirements → capacity → API → high-level design → reference architecture
   structure, matching the existing two in depth. (5 total; still short of a
   "complete" catalog — see Future/P2.)

2. **DSA list groups by category, but all 21 algorithms share one literal
   category ("Data Structures & Algorithm").** The grouped-list UI exists but
   is dead code in practice — users get one giant undifferentiated list
   instead of the scannable, chunked list the fundamentals tab already gets.
   → Reassigned all 21 algorithms into 8 meaningful pattern groups (Arrays &
   Two Pointers, Linked Lists, Stacks & Queues, Trees & Heaps, Graphs,
   Sorting, Dynamic Programming Backtracking & Greedy, Hashing & Bit
   Manipulation).

3. **No sense of progress anywhere in the app.** A 21-pattern + 28-concept +
   5-problem interview-prep app with zero progress tracking means a user
   returning after a week has no idea what they've already mastered vs. still
   need to cover — this is the single largest gap against "production ready"
   for a study tool. `shared_preferences` was already a declared dependency
   but never used for this (or anything).
   → Added persistent quiz-result tracking (best score per algorithm/concept,
   via `shared_preferences`), progress badges on list cards, and a progress
   summary on the home screen ("12/21 algorithms", "9/28 fundamentals").

4. **Fundamentals tab has no search**, while the DSA tab does — inconsistent
   and, with 28 concepts across 14 categories, a real gap once a user knows
   what they're looking for (e.g. "cache").
   → Added the same search affordance to the Fundamentals list.

5. **Design canvas nodes have no accessibility labels.** Every icon-only
   `IconButton` elsewhere in the app already has a `tooltip` (which Flutter
   surfaces as a semantic label for free), so that part of the app was
   already fine on inspection. The real gap is narrower: the placed
   component nodes on the design canvas are a bare `GestureDetector` +
   `Draggable` with no semantic label at all, so a screen-reader user gets
   silent, unlabeled nodes with no indication of what tapping/long-pressing
   does.
   → Added `Semantics` labels to each placed node (component type, selection
   state when mid-connection) and hints describing what tap/long-press does
   in the current mode.

6. **Python code examples only existed for 7 of the 21 DSA patterns**
   (`AlgorithmPythonExamples` only had getters for two_pointers,
   sliding_window, stack, linked_list, binary_search, queue, and trees — the
   other 14 patterns silently fell through to an empty-state screen). For an
   interview-prep app, "learn the pattern, then see it coded" is core to the
   value proposition — leaving two-thirds of patterns without runnable code
   is a completeness gap, not a nice-to-have.
   → Wrote Python examples for the remaining 14 patterns (doubly/circular
   linked list, sorting, heap, greedy, backtracking, graph, hashing, dynamic
   programming, union-find, intervals, trie, bit manipulation, matrix
   traversal), matching the existing file's style (docstring header,
   commented solution, runnable example with expected output).

7. **Code examples were a separate screen reached via an app-bar icon**,
   disconnected from the Overview → Simulation → Review → Quiz learning flow
   that every other tab follows — easy to miss entirely, and inconsistent
   with how the rest of the detail screen is organized.
   → Moved code examples into the tab flow itself, as a new "Code" tab
   between Simulation and Review: **Overview → Simulation → Code → Review →
   Quiz**. Removed the old app-bar icon entry point and the now-redundant
   `CodeExamplesScreen`.

8. **Code tab showed the selected variant's name twice** — once in the
   dropdown itself, once in a redundant title row underneath it.
   → Removed the duplicate title row; the copy button now sits directly
   beside the dropdown instead.

9. **No way to reset quiz progress from within the app.** Once `ProgressStore`
   shipped (item 3), there was no UI path back to a clean slate — the only
   options were reinstalling the app or manually clearing app storage outside
   it, neither discoverable nor appropriate to ask a user to do.
   → Added a "Reset Progress" item to the drawer (disabled when there's
   nothing to reset), behind a confirmation dialog since it's destructive and
   irreversible, calling a new `ProgressStore.resetAll()`.

10. **Security theory was essentially unbuilt, and system-design theory covered
    only a fraction of the source curriculum.** A full re-audit against both
    `theory/Security curriculum copy.pages` and
    `theory/system design curriculum copy.pages` found the Security category
    had exactly 1 concept against a curriculum covering 40+ distinct topics,
    and system-design coverage (28 concepts) left entire categories
    unaddressed: distributed coordination, database internals, architecture
    patterns, communication protocols, reliability/resilience patterns, data
    structures for scale, and ID generation/estimation methodology.
    → Went to full parity with both curricula, grouped into coherent concepts
    (the same density/style as the original 28, not one micro-concept per
    source bullet — see the taxonomy below). Fundamentals grew from 28 to
    **73** concepts across 21 categories, each with the full
    summary/keyPoints/quiz structure. Security alone grew from 1 concept to
    13.

## P1 — documented, not implemented this pass

- Track "reviewed" status for the Simulation/Review tabs too, not just quiz
  completion, so progress reflects the whole learning flow, not just quizzes.
- Bookmark/favorite algorithms and concepts for quick re-access before an
  interview.
- Let users manually override system theme (light/dark toggle in the drawer)
  rather than following OS setting only.
- Difficulty/tag filtering on the DSA list (the model has no difficulty field
  today — would need a schema change, deliberately excluded from this pass to
  avoid touching all 21 records without a clear tagging taxonomy first).
- Language picker for code examples (Python only today) — e.g. Java/JS
  variants for candidates interviewing in those languages.

## P2 — future, larger investments (explicitly out of scope for this pass)

- Grow the practice-problem catalog toward hellointerview parity (~15-20
  problems): Ticketmaster/seat reservation, Uber/ride-matching, YouTube,
  Google Docs (collaborative editing), web crawler, proximity/Yelp-style
  search, notification system, payment system, ad click aggregation.
- "Deep dive" mode per practice problem (bottleneck component walkthrough,
  trade-off discussion) — the curriculum's own recommended structure goes one
  level deeper than what's modeled today (steps 1-7 are covered; the "then go
  deep" step is not).
- Cover the monitoring curriculum (`theory/monitoring curriculum copy.pages`)
  as its own fundamentals category — the security and system-design curricula
  are now both reflected in the app (see item 10 above); monitoring is the
  one remaining unused source file.
- Spaced-repetition scheduling for quiz retakes, driven by the `ProgressStore`.

## Fundamentals taxonomy (post item-10 expansion)

For reference, the 21 Fundamentals categories and concept counts as of this
pass — the 14 original categories (28 concepts) plus 7 new ones (45 concepts):

| Category | Concepts |
|---|---|
| Security | 13 (was 1) |
| Architecture Patterns | 7 *(new)* |
| Databases | 6 |
| Reliability & Resilience | 6 *(new)* |
| Database Internals | 5 *(new)* |
| Distributed Coordination | 4 *(new)* |
| Networking | 3 |
| APIs | 2 |
| Asynchronous Processing | 3 |
| Communication Protocols | 3 *(new)* |
| Consistency & Availability | 3 |
| Data Structures for Scale | 3 *(new)* |
| IDs & Estimation | 3 *(new)* |
| Caching | 2 |
| Scaling | 2 |
| Search | 2 (was 1) |
| Storage | 2 (was 1) |
| Load Balancing | 1 |
| Notifications | 1 |
| Rate Limiting | 1 |
| Geospatial | 1 |

New concepts were grouped to match the density of the original 28 (e.g. "OWASP
API Security Top 10" bundles BOLA/XSS/CSRF/SQLi/SSRF into one concept, the way
"SQL vs NoSQL" already bundled multiple database facts) rather than minting a
separate micro-concept per individual curriculum bullet — the latter would
have produced 150-200+ disconnected one-liners inconsistent with how the rest
of the app presents theory.
