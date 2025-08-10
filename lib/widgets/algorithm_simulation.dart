import 'package:flutter/material.dart';
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
            
            // Array visualization
            SizedBox(
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