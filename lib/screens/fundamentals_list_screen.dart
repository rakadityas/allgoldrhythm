import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/fundamentals_data.dart';
import '../models/fundamental_concept.dart';
import '../services/progress_store.dart';
import '../theme/app_theme.dart';
import '../widgets/quiz_score_badge.dart';
import 'fundamental_detail_screen.dart';

class FundamentalsListScreen extends StatefulWidget {
  const FundamentalsListScreen({super.key});

  @override
  State<FundamentalsListScreen> createState() => _FundamentalsListScreenState();
}

class _FundamentalsListScreenState extends State<FundamentalsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final concepts = FundamentalsData.getConcepts();
    final query = _query.trim().toLowerCase();
    bool matches(FundamentalConcept c) =>
        query.isEmpty ||
        c.title.toLowerCase().contains(query) ||
        c.summary.toLowerCase().contains(query) ||
        c.category.toLowerCase().contains(query);

    final Map<String, List<FundamentalConcept>> categorized = {};
    for (final concept in concepts) {
      categorized.putIfAbsent(concept.category, () => []).add(concept);
    }
    final theme = Theme.of(context);
    final hasAnyMatch = categorized.values.any((list) => list.any(matches));

    return ListView(
      key: const Key('fundamentals_list'),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          // Derived from the data so it can never drift as content grows.
          'The core theory behind every system design interview — '
          '${concepts.length} concepts across ${categorized.length} categories, '
          'each with a quick quiz, independent of any specific case study.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search fundamentals',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      _searchController.clear();
                      _query = '';
                    }),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (!hasAnyMatch)
          _EmptySearchState(query: _query)
        else
          for (final entry in categorized.entries)
            if (entry.value.where(matches).toList() case final filtered when filtered.isNotEmpty) ...[
              Text(
                entry.key,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final concept in filtered) ...[
                _ConceptCard(concept: concept),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
            ],
      ],
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final FundamentalConcept concept;
  const _ConceptCard({required this.concept});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = context
        .watch<ProgressStore>()
        .resultFor(ProgressDomain.fundamental, concept.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundamentalDetailScreen(concept: concept),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  color: theme.colorScheme.onTertiaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(concept.title, style: theme.textTheme.titleMedium),
                        ),
                        if (result != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          QuizScoreBadge(result: result),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      concept.summary,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String query;
  const _EmptySearchState({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No fundamentals match "$query"',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
