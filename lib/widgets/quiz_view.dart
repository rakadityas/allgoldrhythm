import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../theme/app_theme.dart';

/// Reusable multiple-choice quiz UI: score tracking, per-option
/// correct/incorrect feedback, and a results screen. Shared by
/// [AlgorithmQuiz] (DSA) and the System Design fundamentals detail screen,
/// which both just supply their own question list.
class QuizView extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String emptyStateMessage;

  /// Called once, with the final (score, total), the moment the quiz is
  /// completed — including on a retake. Callers own what "completed" means
  /// for their domain (e.g. persisting a best score); this widget stays
  /// framework-agnostic and doesn't reach into any storage itself.
  final void Function(int score, int total)? onCompleted;

  const QuizView({
    super.key,
    required this.questions,
    required this.emptyStateMessage,
    this.onCompleted,
  });

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _index = 0;
  int _score = 0;
  int? _selectedOption;
  bool _showResult = false;

  void _selectOption(int optionIndex) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = optionIndex;
      if (optionIndex == widget.questions[_index].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    setState(() {
      if (_index < widget.questions.length - 1) {
        _index++;
        _selectedOption = null;
      } else {
        _showResult = true;
        widget.onCompleted?.call(_score, widget.questions.length);
      }
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _selectedOption = null;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            widget.emptyStateMessage,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: _showResult ? _buildResult(context) : _buildQuestion(context),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.questions[_index];
    final answered = _selectedOption != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Question ${_index + 1} of ${widget.questions.length}', style: theme.textTheme.labelMedium),
            const Spacer(),
            Text('Score: $_score', style: theme.textTheme.labelMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (_index + (answered ? 1 : 0)) / widget.questions.length,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHigh,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(question.question, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(question.options.length, (i) {
          final isCorrect = i == question.correctIndex;
          final isSelected = i == _selectedOption;

          Color? borderColor;
          Color? fillColor;
          IconData? trailingIcon;
          if (answered) {
            if (isCorrect) {
              borderColor = context.appColors.success;
              fillColor = context.appColors.success.withValues(alpha: 0.12);
              trailingIcon = Icons.check_circle;
            } else if (isSelected) {
              borderColor = theme.colorScheme.error;
              fillColor = theme.colorScheme.error.withValues(alpha: 0.12);
              trailingIcon = Icons.cancel;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: answered ? null : () => _selectOption(i),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
                decoration: BoxDecoration(
                  color: fillColor ?? theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: borderColor ?? theme.colorScheme.outlineVariant,
                    width: borderColor != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(question.options[i], style: theme.textTheme.bodyLarge)),
                    if (trailingIcon != null)
                      Icon(trailingIcon, color: borderColor, size: 20),
                  ],
                ),
              ),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm + 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(question.explanation, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _next,
              icon: Icon(_index < widget.questions.length - 1 ? Icons.arrow_forward : Icons.flag),
              label: Text(_index < widget.questions.length - 1 ? 'Next' : 'See Results'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.questions.length;
    final percent = _score / total;

    final String headline;
    final IconData icon;
    final Color color;
    if (percent >= 0.8) {
      headline = 'Excellent!';
      icon = Icons.emoji_events;
      color = context.appColors.success;
    } else if (percent >= 0.5) {
      headline = 'Good effort!';
      icon = Icons.thumb_up_alt_outlined;
      color = theme.colorScheme.primary;
    } else {
      headline = 'Keep practicing!';
      icon = Icons.school_outlined;
      color = theme.colorScheme.error;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: color),
        const SizedBox(height: AppSpacing.sm),
        Text(headline, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$_score / $total correct (${(percent * 100).round()}%)',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.refresh),
          label: const Text('Retake Quiz'),
        ),
      ],
    );
  }
}
