import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/algorithm.dart';
import '../data/algorithm_python_examples.dart';
import '../theme/app_theme.dart';

class CodeExamplesScreen extends StatefulWidget {
  final Algorithm algorithm;

  const CodeExamplesScreen({super.key, required this.algorithm});

  @override
  State<CodeExamplesScreen> createState() => _CodeExamplesScreenState();
}

class _CodeExamplesScreenState extends State<CodeExamplesScreen> {
  String? selectedVariant;
  late final Map<String, String> examples;

  @override
  void initState() {
    super.initState();
    examples = _loadExamples();
    if (examples.isNotEmpty) {
      selectedVariant = examples.keys.first;
    }
  }

  Map<String, String> _loadExamples() {
    switch (widget.algorithm.id) {
      case 'two_pointers':
        return AlgorithmPythonExamples.getTwoPointersExamples();
      case 'sliding_window':
        return AlgorithmPythonExamples.getSlidingWindowExamples();
      case 'stack':
        return AlgorithmPythonExamples.getStackExamples();
      case 'linked_list':
        return AlgorithmPythonExamples.getLinkedListExamples();
      case 'binary_search':
        return AlgorithmPythonExamples.getBinarySearchExamples();
      case 'queue':
        return AlgorithmPythonExamples.getQueueExamples();
      case 'trees':
        return AlgorithmPythonExamples.getTreesExamples();
      default:
        return {};
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm.name} Code'),
      ),
      body: examples.isEmpty
          ? _EmptyExamplesState(algorithmName: widget.algorithm.name)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Variant'),
                    value: selectedVariant,
                    items: examples.keys.map((String variant) {
                      return DropdownMenuItem<String>(
                        value: variant,
                        child: Text(variant),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVariant = newValue;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: selectedVariant == null
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            0,
                            AppSpacing.md,
                            AppSpacing.md,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedVariant!,
                                      style: theme.textTheme.titleLarge,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy_outlined),
                                    onPressed: () => _copyToClipboard(examples[selectedVariant]!),
                                    tooltip: 'Copy code',
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
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
                          ),
                        ),
                ),
              ],
            ),
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
