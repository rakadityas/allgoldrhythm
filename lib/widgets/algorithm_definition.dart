import 'package:flutter/material.dart';
import '../models/algorithm.dart';
import '../theme/app_theme.dart';

class AlgorithmDefinition extends StatelessWidget {
  final Algorithm algorithm;

  const AlgorithmDefinition({super.key, required this.algorithm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(algorithm.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            Text('Key Steps', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            ...algorithm.steps.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${entry.key + 1}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(entry.value, style: theme.textTheme.bodyLarge),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
