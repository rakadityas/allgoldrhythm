import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/algorithm.dart';

class AlgorithmSimulation extends StatefulWidget {
  final Algorithm algorithm;

  const AlgorithmSimulation({super.key, required this.algorithm});

  @override
  State<AlgorithmSimulation> createState() => _AlgorithmSimulationState();
}

class _AlgorithmSimulationState extends State<AlgorithmSimulation> {
  int _currentVisualizationIndex = 0;
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  final int _arraySize = 10;

  void _nextStep() {
    setState(() {
      if (_currentStepIndex < widget.algorithm.visualizations[_currentVisualizationIndex].steps.length - 1) {
        _currentStepIndex++;
      } else {
        _isPlaying = false;
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStepIndex > 0) {
        _currentStepIndex--;
      }
    });
  }

  void _resetSimulation() {
    setState(() {
      _currentStepIndex = 0;
      _isPlaying = false;
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playAnimation();
      }
    });
  }

  void _playAnimation() async {
    if (!_isPlaying) return;
    
    if (_currentStepIndex < widget.algorithm.visualizations[_currentVisualizationIndex].steps.length - 1) {
      await Future.delayed(const Duration(seconds: 3));
      if (_isPlaying) {
        _nextStep();
        _playAnimation();
      }
    } else {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _changeVisualization(int index) {
    setState(() {
      _currentVisualizationIndex = index;
      _currentStepIndex = 0;
      _isPlaying = false;
    });
  }

  Widget _buildTreeVisualization(VisualizationStep currentStep) {
    // Tree node values for 3-level binary tree (7 nodes total)
    final treeValues = [50, 30, 70, 20, 40, 60, 80];
    
    return Container(
      height: 250,
      child: Stack(
        children: [
          CustomPaint(
            painter: TreePainter(
              highlightedIndices: currentStep.highlightIndices,
              previousIndices: currentStep.previousIndices,
              treeValues: treeValues,
            ),
            size: Size.infinite,
          ),
          // Interactive overlay for tap detection
          ...List.generate(treeValues.length, (index) {
            final position = _getNodePosition(index, 250, 400);
            return Positioned(
              left: position.dx - 20,
              top: position.dy - 20,
              child: GestureDetector(
                onTap: () {
                  // Handle node tap - could trigger step navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped node ${treeValues[index]} at index $index'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Offset _getNodePosition(int index, double height, double width) {
    // Calculate position for 3-level binary tree
    final levels = [
      [0], // Root: 50 (index 0)
      [1, 2], // Level 1: 30, 70 (indices 1, 2)
      [3, 4, 5, 6], // Level 2: 20, 40, 60, 80 (indices 3, 4, 5, 6)
    ];
    
    for (int level = 0; level < levels.length; level++) {
      if (levels[level].contains(index)) {
        final positionInLevel = levels[level].indexOf(index);
        final nodesInLevel = levels[level].length;
        final y = 40.0 + level * 70.0;
        final x = width / (nodesInLevel + 1) * (positionInLevel + 1);
        return Offset(x, y);
      }
    }
    return Offset(width / 2, height / 2);
  }

  @override
  Widget build(BuildContext context) {
    final visualizations = widget.algorithm.visualizations;
    final currentVisualization = visualizations[_currentVisualizationIndex];
    final currentStep = currentVisualization.steps[_currentStepIndex];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visualization selector
            if (visualizations.length > 1)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: visualizations.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(visualizations[index].title),
                        selected: _currentVisualizationIndex == index,
                        onSelected: (selected) {
                          if (selected) {
                            _changeVisualization(index);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            
            // Visualization title and description
            Text(
              currentVisualization.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currentVisualization.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Visualization (Array or Tree)
            widget.algorithm.name == 'Trees' 
                ? _buildTreeVisualization(currentStep)
                : SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_arraySize, (index) {
                        final isHighlighted = currentStep.highlightIndices.contains(index);
                        return Container(
                          width: 30,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isHighlighted ? Colors.amber : Colors.grey[200],
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
            const SizedBox(height: 16),
            
            // Step explanation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentStep.explanation,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _currentStepIndex > 0 ? _previousStep : null,
                ),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _currentStepIndex < currentVisualization.steps.length - 1 ? _nextStep : null,
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _resetSimulation,
                ),
              ],
            ),
            
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  currentVisualization.steps.length,
                  (index) => Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentStepIndex ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final List<int> highlightedIndices;
  final List<int>? previousIndices;
  final List<int> treeValues;

  TreePainter({
    required this.highlightedIndices,
    this.previousIndices,
    required this.treeValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Tree structure mapping for 3-level binary tree (index -> [left_child_index, right_child_index])
    final treeStructure = {
      0: [1, 2],   // 50 -> 30, 70
      1: [3, 4],   // 30 -> 20, 40
      2: [5, 6],   // 70 -> 60, 80
      3: [null, null], // 20 (leaf)
      4: [null, null], // 40 (leaf)
      5: [null, null], // 60 (leaf)
      6: [null, null], // 80 (leaf)
    };

    // Draw connections first
    paint.color = Colors.grey[600]!;
    treeStructure.forEach((parentIndex, children) {
      final parentPos = _getNodePosition(parentIndex, size.height, size.width);
      
      for (int i = 0; i < children.length; i++) {
        final childIndex = children[i];
        if (childIndex != null) {
          final childPos = _getNodePosition(childIndex, size.height, size.width);
          canvas.drawLine(parentPos, childPos, paint);
        }
      }
    });

    // Draw nodes
    for (int i = 0; i < treeValues.length; i++) {
      final position = _getNodePosition(i, size.height, size.width);
      
      // Determine node color based on highlight status
      Color nodeColor;
      if (highlightedIndices.contains(i)) {
        nodeColor = Colors.red[300]!;
      } else if (previousIndices?.contains(i) ?? false) {
        nodeColor = Colors.green[300]!;
      } else {
        nodeColor = Colors.blue[100]!;
      }
      
      // Draw node circle
      fillPaint.color = nodeColor;
      canvas.drawCircle(position, 20, fillPaint);
      
      // Draw node border
      paint.color = Colors.black;
      canvas.drawCircle(position, 20, paint);
      
      // Draw node value text
      textPainter.text = TextSpan(
        text: treeValues[i].toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      
      final textOffset = Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  Offset _getNodePosition(int index, double height, double width) {
    // Tree level mapping for 3-level binary tree
    final levels = [
      [0], // Root: 50 (index 0)
      [1, 2], // Level 1: 30, 70 (indices 1, 2)
      [3, 4, 5, 6], // Level 2: 20, 40, 60, 80 (indices 3, 4, 5, 6)
    ];
    
    for (int level = 0; level < levels.length; level++) {
      if (levels[level].contains(index)) {
        final positionInLevel = levels[level].indexOf(index);
        final nodesInLevel = levels[level].length;
        final y = 40.0 + level * 70.0;
        final x = width / (nodesInLevel + 1) * (positionInLevel + 1);
        return Offset(x, y);
      }
    }
    return Offset(width / 2, height / 2);
  }

  @override
  bool shouldRepaint(TreePainter oldDelegate) {
    return oldDelegate.highlightedIndices != highlightedIndices ||
           oldDelegate.previousIndices != previousIndices;
  }
}