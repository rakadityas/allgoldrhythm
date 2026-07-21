import 'package:flutter/material.dart';
import '../services/progress_store.dart';
import '../theme/app_theme.dart';

/// A small pill showing a completed quiz's best score (e.g. "4/5"), used on
/// algorithm/fundamental list cards so users can see progress at a glance.
/// A filled check instead of an outline once the score is perfect.
class QuizScoreBadge extends StatelessWidget {
  final QuizResult result;

  const QuizScoreBadge({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPerfect = result.score == result.total;
    final color = isPerfect ? context.appColors.success : theme.colorScheme.primary;

    return Semantics(
      label: 'Best quiz score ${result.score} out of ${result.total}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPerfect ? Icons.check_circle : Icons.check_circle_outline,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              '${result.score}/${result.total}',
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
