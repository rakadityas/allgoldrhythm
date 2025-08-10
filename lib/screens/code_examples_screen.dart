import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/algorithm.dart';
import '../data/algorithm_python_examples.dart';

class CodeExamplesScreen extends StatefulWidget {
  final Algorithm algorithm;

  const CodeExamplesScreen({super.key, required this.algorithm});

  @override
  State<CodeExamplesScreen> createState() => _CodeExamplesScreenState();
}

class _CodeExamplesScreenState extends State<CodeExamplesScreen> {
  String? selectedVariant;
  Map<String, String> examples = {};

  @override
  void initState() {
    super.initState();
    _loadExamples();
  }

  void _loadExamples() {
    if (widget.algorithm.id == 'two_pointers') {
      examples = AlgorithmPythonExamples.getTwoPointersExamples();
    } else if (widget.algorithm.id == 'sliding_window') {
      examples = AlgorithmPythonExamples.getSlidingWindowExamples();
    }

    if (examples.isNotEmpty) {
      setState(() {
        selectedVariant = examples.keys.first;
      });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm.name} Code Examples'),
      ),
      body: examples.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Variant',
                      border: OutlineInputBorder(),
                    ),
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
                      ? const Center(child: Text('Select a variant'))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedVariant!,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: () => _copyToClipboard(examples[selectedVariant]!),
                                      tooltip: 'Copy code',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: SelectableText(
                                    examples[selectedVariant] ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}