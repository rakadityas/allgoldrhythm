import 'package:flutter/material.dart';
import '../models/system_design.dart';
import '../theme/app_theme.dart';
import '../widgets/design_canvas.dart';

class SystemDesignDetailScreen extends StatelessWidget {
  final SystemDesignProblem problem;

  const SystemDesignDetailScreen({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(problem.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Requirements', icon: Icon(Icons.checklist_outlined)),
              Tab(text: 'Design Canvas', icon: Icon(Icons.dashboard_customize_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _RequirementsView(problem: problem),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: DesignCanvas(problem: problem),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementsView extends StatelessWidget {
  final SystemDesignProblem problem;
  const _RequirementsView({required this.problem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(problem.prompt, style: theme.textTheme.bodyLarge),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _Section(
          icon: Icons.task_alt,
          title: 'Functional Requirements',
          items: problem.functionalRequirements,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Section(
          icon: Icons.speed_outlined,
          title: 'Non-Functional Requirements',
          items: problem.nonFunctionalRequirements,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Section(
          icon: Icons.calculate_outlined,
          title: 'Capacity Estimation',
          items: problem.capacityEstimation,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Section(
          icon: Icons.api_outlined,
          title: 'API Design',
          items: problem.apiDesign,
          monospace: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Icon(Icons.architecture_outlined, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text('High-Level Design', style: theme.textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(problem.highLevelDesign, style: theme.textTheme.bodyLarge),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, size: 18, color: theme.colorScheme.tertiary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Head to the Design Canvas tab to sketch this architecture yourself before checking it against the reference.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final bool monospace;

  const _Section({
    required this.icon,
    required this.title,
    required this.items,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(title, style: theme.textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary)),
                          Expanded(
                            child: Text(
                              item,
                              style: monospace
                                  ? theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace')
                                  : theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
