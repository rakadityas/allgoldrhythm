import 'package:flutter/material.dart';
import '../data/system_design_data.dart';
import '../models/system_design.dart';
import '../theme/app_theme.dart';
import 'fundamentals_list_screen.dart';
import 'system_design_detail_screen.dart';

class SystemDesignListScreen extends StatelessWidget {
  const SystemDesignListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('System Design'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Fundamentals'),
              Tab(text: 'Practice Problems'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FundamentalsListScreen(),
            _PracticeProblemsView(),
          ],
        ),
      ),
    );
  }
}

class _PracticeProblemsView extends StatelessWidget {
  const _PracticeProblemsView();

  @override
  Widget build(BuildContext context) {
    final problems = SystemDesignData.getProblems();
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          'Apply the fundamentals to full interview-style prompts: read the requirements, then sketch '
          'the architecture yourself on an interactive canvas before checking it against a reference design.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final problem in problems) ...[
          _ProblemCard(problem: problem),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final SystemDesignProblem problem;
  const _ProblemCard({required this.problem});

  Color _difficultyColor(BuildContext context, ThemeData theme) {
    switch (problem.difficulty) {
      case 'Easy':
        return context.appColors.success;
      case 'Hard':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final difficultyColor = _difficultyColor(context, theme);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SystemDesignDetailScreen(problem: problem),
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
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.architecture_outlined, color: theme.colorScheme.onPrimaryContainer, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(problem.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      problem.prompt,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: difficultyColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        problem.difficulty,
                        style: theme.textTheme.labelMedium?.copyWith(color: difficultyColor),
                      ),
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
