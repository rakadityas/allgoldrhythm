import 'package:flutter/material.dart';
import '../data/fundamentals_data.dart';
import '../models/fundamental_concept.dart';
import '../theme/app_theme.dart';
import 'fundamental_detail_screen.dart';

class FundamentalsListScreen extends StatelessWidget {
  const FundamentalsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final concepts = FundamentalsData.getConcepts();
    final Map<String, List<FundamentalConcept>> categorized = {};
    for (final concept in concepts) {
      categorized.putIfAbsent(concept.category, () => []).add(concept);
    }
    final theme = Theme.of(context);

    return ListView(
      key: const Key('fundamentals_list'),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          'The core theory behind every system design interview — networking, APIs, load balancing, '
          'caching, databases, scaling, consistency, async processing, rate limiting, storage, security, '
          'search, notifications, and geospatial indexing — independent of any specific case study.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final entry in categorized.entries) ...[
          Text(
            entry.key,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final concept in entry.value) ...[
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
                    Text(concept.title, style: theme.textTheme.titleMedium),
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
