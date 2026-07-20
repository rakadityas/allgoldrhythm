import 'package:flutter/material.dart';
import '../data/fundamentals_quiz_data.dart';
import '../models/fundamental_concept.dart';
import '../theme/app_theme.dart';
import '../widgets/architecture_diagram.dart';
import '../widgets/quiz_view.dart';

class FundamentalDetailScreen extends StatelessWidget {
  final FundamentalConcept concept;
  const FundamentalDetailScreen({super.key, required this.concept});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(concept.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Theory', icon: Icon(Icons.menu_book_outlined)),
              Tab(text: 'Quiz', icon: Icon(Icons.quiz_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TheoryView(concept: concept),
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: QuizView(
                questions: FundamentalsQuizData.questionsFor(concept.id),
                emptyStateMessage: 'No quiz questions available yet for ${concept.title}.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TheoryView extends StatelessWidget {
  final FundamentalConcept concept;
  const _TheoryView({required this.concept});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const Key('fundamental_detail_list'),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            concept.category,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(concept.summary, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        if (concept.diagram != null) ...[
          ArchitectureDiagram(
            components: concept.diagram!.components,
            connections: concept.diagram!.connections,
          ),
          if (concept.diagramCaption != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              concept.diagramCaption!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
        Text('Key points', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        for (final point in concept.keyPoints)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(point, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
