import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/algorithm_python_examples.dart';
import '../models/algorithm.dart';
import '../theme/app_theme.dart';

/// Python code examples for an algorithm, shown as a "Code" tab alongside
/// Overview/Simulation/Review/Quiz rather than a separate screen — code is
/// part of the same learning flow as the rest of the pattern, not a
/// side-quest reached via an app-bar icon.
class AlgorithmCodeView extends StatefulWidget {
  final Algorithm algorithm;

  const AlgorithmCodeView({super.key, required this.algorithm});

  @override
  State<AlgorithmCodeView> createState() => _AlgorithmCodeViewState();
}

class _AlgorithmCodeViewState extends State<AlgorithmCodeView> {
  String? selectedVariant;
  late final Map<String, String> examples;

  @override
  void initState() {
    super.initState();
    examples = AlgorithmPythonExamples.examplesFor(widget.algorithm.id);
    if (examples.isNotEmpty) {
      selectedVariant = examples.keys.first;
    }
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (examples.isEmpty) {
      return _EmptyExamplesState(algorithmName: widget.algorithm.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Variant'),
                value: selectedVariant,
                items: examples.keys.map((String variant) {
                  return DropdownMenuItem<String>(
                    value: variant,
                    child: Text(variant, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedVariant = newValue;
                  });
                },
              ),
            ),
            if (selectedVariant != null)
              IconButton(
                icon: const Icon(Icons.copy_outlined),
                onPressed: () => _copyToClipboard(examples[selectedVariant]!),
                tooltip: 'Copy code',
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (selectedVariant != null) ...[
          Container(
            decoration: BoxDecoration(
              color: context.appColors.codeBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SelectableText(
              examples[selectedVariant] ?? '',
              style: TextStyle(
                fontFamily: 'monospace',
                color: context.appColors.codeForeground,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyExamplesState extends StatelessWidget {
  final String algorithmName;
  const _EmptyExamplesState({required this.algorithmName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.code_off, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No code examples yet for $algorithmName',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
