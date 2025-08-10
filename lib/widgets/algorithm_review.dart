import 'package:flutter/material.dart';
import '../models/algorithm.dart';

class AlgorithmReview extends StatefulWidget {
  final Algorithm algorithm;

  const AlgorithmReview({super.key, required this.algorithm});

  @override
  State<AlgorithmReview> createState() => _AlgorithmReviewState();
}

class _AlgorithmReviewState extends State<AlgorithmReview> {
  final int _arraySize = 10;
  List<int> _selectedIndices = [];
  String _patternIdentified = '';

  void _toggleIndex(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
      _identifyPattern();
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedIndices = [];
      _patternIdentified = '';
    });
  }

  void _identifyPattern() {
    // Sort indices to analyze the pattern
    _selectedIndices.sort();
    
    if (_selectedIndices.isEmpty) {
      _patternIdentified = '';
      return;
    }

    if (widget.algorithm.id == 'two_pointers') {
      // Identify Two Pointers patterns
      if (_selectedIndices.length == 2) {
        if (_selectedIndices[0] == 0 && _selectedIndices[1] == _arraySize - 1) {
          _patternIdentified = 'Left-Right Two Pointers Pattern';
        } else if (_selectedIndices[0] == 0 && _selectedIndices[1] == 1) {
          _patternIdentified = 'Fast-Slow Two Pointers Pattern';
        } else if (_selectedIndices[0] == 0 && _selectedIndices[1] == 2 || 
                  _selectedIndices[0] == 1 && _selectedIndices[1] == 3 ||
                  _selectedIndices[0] == 2 && _selectedIndices[1] == 5) {
          _patternIdentified = 'Same Direction Two Pointers Pattern';
        } else {
          _patternIdentified = 'Custom Two Pointers Pattern';
        }
      } else if (_selectedIndices.length == 3) {
        if (_selectedIndices.contains(0) && _selectedIndices.contains(5) && _selectedIndices.contains(9)) {
          _patternIdentified = 'Three Pointers Pattern';
        } else if (_selectedIndices.contains(0) && _selectedIndices.contains(4) && _selectedIndices.contains(8)) {
          _patternIdentified = 'Partition Array Pattern';
        } else {
          _patternIdentified = 'Custom Three Pointers Pattern';
        }
      } else if (_selectedIndices.length > 3) {
        _patternIdentified = 'Multiple Pointers Pattern';
      } else {
        _patternIdentified = 'Single Pointer (Not a Two Pointers Pattern)';
      }
    } else if (widget.algorithm.id == 'sliding_window') {
      // Identify Sliding Window patterns
      if (_selectedIndices.length >= 2) {
        bool isConsecutive = true;
        for (int i = 1; i < _selectedIndices.length; i++) {
          if (_selectedIndices[i] != _selectedIndices[i - 1] + 1) {
            isConsecutive = false;
            break;
          }
        }
        
        if (isConsecutive) {
          if (_selectedIndices.length == 3) {
            _patternIdentified = 'Fixed Size Sliding Window Pattern (Size 3)';
          } else {
            _patternIdentified = 'Variable Size Sliding Window Pattern';
          }
        } else {
          _patternIdentified = 'Non-consecutive Selection (Not a Sliding Window)';
        }
      } else {
        _patternIdentified = 'Incomplete Window (Select more elements)';
      }
    } else if (widget.algorithm.id == 'binary_search') {
      // Identify Binary Search patterns
      if (_selectedIndices.length == 1) {
        int selectedIndex = _selectedIndices.first;
        int arrayLength = 10; // Assuming 10 elements as per simulation
        int middle = arrayLength ~/ 2;
        
        if (selectedIndex == middle) {
          _patternIdentified = 'Middle Element Selection (Binary Search Start)';
        } else if (selectedIndex < middle) {
          _patternIdentified = 'Left Half Selection (Search Left)';
        } else {
          _patternIdentified = 'Right Half Selection (Search Right)';
        }
      } else if (_selectedIndices.length == 2) {
        _selectedIndices.sort();
        int left = _selectedIndices[0];
        int right = _selectedIndices[1];
        int middle = (left + right) ~/ 2;
        
        _patternIdentified = 'Binary Search Range: Left=$left, Right=$right, Middle=$middle';
      } else if (_selectedIndices.length > 2) {
        _patternIdentified = 'Binary Search Sequence (Multiple Steps)';
      } else {
        _patternIdentified = 'Select elements to demonstrate binary search';
      }
    } else if (widget.algorithm.id == 'stack') {
      // Identify Stack patterns
      if (_selectedIndices.length == 1) {
        _patternIdentified = 'Single Element (Stack Top)';
      } else if (_selectedIndices.length > 1) {
        // Check if selection follows LIFO pattern
        bool isLIFO = true;
        for (int i = 1; i < _selectedIndices.length; i++) {
          if (_selectedIndices[i] < _selectedIndices[i-1]) {
            isLIFO = false;
            break;
          }
        }
        
        if (isLIFO) {
          _patternIdentified = 'LIFO Pattern (Last In First Out)';
        } else {
          _patternIdentified = 'Non-LIFO Pattern (Not Stack Behavior)';
        }
      }
    } else if (widget.algorithm.id == 'linked_list') {
      // Identify Linked List patterns
      if (_selectedIndices.length == 1) {
        _patternIdentified = 'Single Node Selection';
      } else if (_selectedIndices.length > 1) {
        // Check if selection follows sequential pattern
        bool isSequential = true;
        _selectedIndices.sort();
        for (int i = 1; i < _selectedIndices.length; i++) {
          if (_selectedIndices[i] != _selectedIndices[i-1] + 1) {
            isSequential = false;
            break;
          }
        }
        
        if (isSequential) {
          _patternIdentified = 'Sequential Traversal (Linked List Pattern)';
        } else {
          _patternIdentified = 'Non-sequential Access (Random Access Pattern)';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Your Understanding',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click on the array elements to create a pattern. The system will identify which algorithm pattern you are demonstrating.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Interactive array
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_arraySize, (index) {
                  final isSelected = _selectedIndices.contains(index);
                  return GestureDetector(
                    onTap: () => _toggleIndex(index),
                    child: Container(
                      width: 30,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.grey[200],
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            
            // Pattern identification result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _patternIdentified.isEmpty ? 'Select elements to identify a pattern' : _patternIdentified,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _patternIdentified.isEmpty ? FontWeight.normal : FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            
            // Reset button
            Center(
              child: ElevatedButton.icon(
                onPressed: _resetSelection,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}