import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_info.dart';
import '../data/algorithm_data.dart';
import '../data/fundamentals_data.dart';
import '../services/progress_store.dart';
import '../theme/app_theme.dart';
import '../widgets/quiz_score_badge.dart';
import 'algorithm_detail_screen.dart';
import 'algorithm_list_screen.dart';
import 'fundamental_detail_screen.dart';
import 'system_design_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppInfo.appName,
      applicationVersion: AppInfo.appVersion,
      applicationIcon: Icon(
        Icons.school,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: const [
        Text(AppInfo.description),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = context.watch<ProgressStore>();
    final algorithmIds = AlgorithmData.getAlgorithms().map((a) => a.id);
    final fundamentalIds = FundamentalsData.getConcepts().map((c) => c.id);
    final algorithmsDone = progress.completedCount(ProgressDomain.algorithm, algorithmIds);
    final fundamentalsDone = progress.completedCount(ProgressDomain.fundamental, fundamentalIds);
    final algorithmsTotal = algorithmIds.length;
    final fundamentalsTotal = fundamentalIds.length;

    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('AllGoldRhythm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => _showAbout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('What do you want to practice?', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pick a track to get started.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.lg),
          _FocusCard(
            icon: Icons.code,
            title: 'Data Structures & Algorithms',
            description: 'Simulate, review, and quiz yourself on 21 core patterns.',
            color: theme.colorScheme.primaryContainer,
            onColor: theme.colorScheme.onPrimaryContainer,
            progressDone: algorithmsDone,
            progressTotal: algorithmsTotal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlgorithmListScreen()),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _FocusCard(
            icon: Icons.architecture_outlined,
            title: 'System Design',
            description: 'Learn the fundamentals, then practice on an interactive design canvas.',
            color: theme.colorScheme.tertiaryContainer,
            onColor: theme.colorScheme.onTertiaryContainer,
            progressDone: fundamentalsDone,
            progressTotal: fundamentalsTotal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SystemDesignListScreen()),
            ),
          ),
          ..._buildReviewSection(context, progress),
        ],
      ),
    );
  }

  /// Up to 3 imperfect quiz results, weakest first — a lightweight
  /// "retake your weakest quizzes" loop. Perfect scores and design-canvas
  /// completions (which are only recorded when perfect) never appear.
  List<Widget> _buildReviewSection(BuildContext context, ProgressStore progress) {
    final theme = Theme.of(context);
    final algorithms = {for (final a in AlgorithmData.getAlgorithms()) a.id: a};
    final concepts = {for (final c in FundamentalsData.getConcepts()) c.id: c};

    final suggestions = <_ReviewSuggestion>[];
    for (final (domain, id, result) in progress.allResults) {
      if (result.percent >= 1.0) continue;
      switch (domain) {
        case ProgressDomain.algorithm:
          final algorithm = algorithms[id];
          if (algorithm != null) {
            suggestions.add(_ReviewSuggestion(
              title: algorithm.name,
              subtitle: 'Data Structures & Algorithms',
              result: result,
              destination: () => AlgorithmDetailScreen(algorithm: algorithm),
            ));
          }
        case ProgressDomain.fundamental:
          final concept = concepts[id];
          if (concept != null) {
            suggestions.add(_ReviewSuggestion(
              title: concept.title,
              subtitle: 'System Design · ${concept.category}',
              result: result,
              destination: () => FundamentalDetailScreen(concept: concept),
            ));
          }
        case ProgressDomain.designProblem:
          break;
      }
    }
    if (suggestions.isEmpty) return const [];

    suggestions.sort((a, b) {
      final byScore = a.result.percent.compareTo(b.result.percent);
      if (byScore != 0) return byScore;
      return a.result.completedAt.compareTo(b.result.completedAt);
    });

    return [
      const SizedBox(height: AppSpacing.lg),
      Text('Suggested review', style: theme.textTheme.titleMedium),
      const SizedBox(height: 2),
      Text(
        'Your weakest quiz scores — retake them to lock the material in.',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
      ),
      const SizedBox(height: AppSpacing.sm),
      for (final suggestion in suggestions.take(3)) ...[
        _ReviewSuggestionCard(suggestion: suggestion),
        const SizedBox(height: AppSpacing.sm),
      ],
    ];
  }
}

class _ReviewSuggestion {
  final String title;
  final String subtitle;
  final QuizResult result;
  final Widget Function() destination;

  const _ReviewSuggestion({
    required this.title,
    required this.subtitle,
    required this.result,
    required this.destination,
  });
}

class _ReviewSuggestionCard extends StatelessWidget {
  final _ReviewSuggestion suggestion;
  const _ReviewSuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => suggestion.destination()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(Icons.refresh, size: 22, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(suggestion.title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      suggestion.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              QuizScoreBadge(result: suggestion.result),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color onColor;
  final int progressDone;
  final int progressTotal;
  final VoidCallback onTap;

  const _FocusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onColor,
    required this.progressDone,
    required this.progressTotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressFraction = progressTotal == 0 ? 0.0 : progressDone / progressTotal;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: color,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: onColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(icon, size: 26, color: onColor),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: onColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(color: onColor.withValues(alpha: 0.85)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.arrow_forward_ios, size: 16, color: onColor.withValues(alpha: 0.7)),
                ],
              ),
              if (progressTotal > 0) ...[
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  label: '$progressDone of $progressTotal quizzes completed',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      minHeight: 6,
                      backgroundColor: onColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(onColor),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$progressDone/$progressTotal quizzes completed',
                  style: theme.textTheme.labelMedium?.copyWith(color: onColor.withValues(alpha: 0.85)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  Future<void> _confirmResetProgress(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text(
          'This clears every recorded quiz score for Data Structures & '
          'Algorithms and System Design, plus completed design-canvas checks. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<ProgressStore>().resetAll();
    if (!context.mounted) return;
    Navigator.pop(context); // close the drawer
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Progress reset')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasProgress = context.watch<ProgressStore>().hasAnyProgress;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'AllGoldRhythm',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Data Structures & Algorithms'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlgorithmListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.architecture_outlined),
            title: const Text('System Design'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SystemDesignListScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.restart_alt,
              color: hasProgress ? theme.colorScheme.error : theme.disabledColor,
            ),
            title: Text(
              'Reset Progress',
              style: TextStyle(color: hasProgress ? theme.colorScheme.error : theme.disabledColor),
            ),
            enabled: hasProgress,
            onTap: hasProgress ? () => _confirmResetProgress(context) : null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Licenses'),
            onTap: () {
              Navigator.pop(context);
              showLicensePage(
                context: context,
                applicationName: AppInfo.appName,
                applicationVersion: AppInfo.appVersion,
                applicationIcon: Icon(
                  Icons.school,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
