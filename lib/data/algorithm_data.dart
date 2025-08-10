import '../models/algorithm.dart';

class AlgorithmData {
  static List<Algorithm> getAlgorithms() {
    return [
      Algorithm(
        id: 'two_pointers',
        name: 'Two Pointers',
        category: 'DSA',
        description: 'Two pointers is a technique where two pointers iterate through a data structure. '
            'It is often used to search for pairs in a sorted array or linked list, '
            'with O(n) time complexity and O(1) space complexity.',
        steps: [
          'Initialize two pointers (usually at the beginning, end, or both at the beginning)',
          'Move the pointers based on specific conditions',
          'Process elements at the pointer positions',
          'Continue until pointers meet or other termination condition'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Left-Right Two Pointers',
            description: 'This pattern uses two pointers starting from opposite ends of an array, moving toward each other.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 9],
                previousIndices: [],
                explanation: 'Initialize left pointer at index 0 and right pointer at the last index (index 9).',
              ),
              VisualizationStep(
                highlightIndices: [1, 9],
                previousIndices: [],
                explanation: 'Move left pointer right from index 0 to index 1. Notice that left pointer moved from position 1 to position 2.',
              ),
              VisualizationStep(
                highlightIndices: [1, 8],
                previousIndices: [],
                explanation: 'Move right pointer left from index 9 to index 8. Notice that right pointer moved from position 10 to position 9.',
              ),
              VisualizationStep(
                highlightIndices: [2, 8],
                previousIndices: [],
                explanation: 'Move left pointer right from index 1 to index 2. Notice that left pointer moved from position 2 to position 3.',
              ),
              VisualizationStep(
                highlightIndices: [2, 7],
                previousIndices: [],
                explanation: 'Move right pointer left from index 8 to index 7. Notice that right pointer moved from position 9 to position 8.',
              ),
              VisualizationStep(
                highlightIndices: [3, 7],
                previousIndices: [],
                explanation: 'Move left pointer right from index 2 to index 3. Notice that left pointer moved from position 3 to position 4.',
              ),
              VisualizationStep(
                highlightIndices: [3, 6],
                previousIndices: [],
                explanation: 'Move right pointer left from index 7 to index 6. Notice that right pointer moved from position 8 to position 7.',
              ),
              VisualizationStep(
                highlightIndices: [4, 6],
                previousIndices: [],
                explanation: 'Move left pointer right from index 3 to index 4. Notice that left pointer moved from position 4 to position 5.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [],
                explanation: 'Move right pointer left from index 6 to index 5. Notice that right pointer moved from position 7 to position 6.',
              ),
              VisualizationStep(
                highlightIndices: [5, 5],
                previousIndices: [],
                explanation: 'Move left pointer right from index 4 to index 5. Now both pointers meet at index 5 (position 6). Algorithm terminates.',
              ),
              VisualizationStep(
                highlightIndices: [5, 9],
                previousIndices: [],
                explanation: 'Fast pointer has reached the end of the array at index 9 (position 10). Algorithm terminates with slow pointer at index 5 (position 6).',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Fast-Slow Two Pointers',
            description: 'This pattern uses two pointers moving at different speeds from the same direction.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 0],
                previousIndices: [],
                explanation: 'Initialize both slow and fast pointers at index 0 (position 1).',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [],
                explanation: 'Move slow pointer from index 0 to index 1 (position 1 to 2) and fast pointer from index 0 to index 2 (position 1 to 3).',
              ),
              VisualizationStep(
                highlightIndices: [2, 4],
                previousIndices: [],
                explanation: 'Move slow pointer from index 1 to index 2 (position 2 to 3) and fast pointer from index 2 to index 4 (position 3 to 5).',
              ),
              VisualizationStep(
                highlightIndices: [3, 6],
                previousIndices: [],
                explanation: 'Move slow pointer from index 2 to index 3 (position 3 to 4) and fast pointer from index 4 to index 6 (position 5 to 7).',
              ),
              VisualizationStep(
                highlightIndices: [4, 8],
                previousIndices: [],
                explanation: 'Move slow pointer from index 3 to index 4 (position 4 to 5) and fast pointer from index 6 to index 8 (position 7 to 9).',
              ),
              VisualizationStep(
                highlightIndices: [5, 9],
                previousIndices: [],
                explanation: 'Move slow pointer from index 4 to index 5 (position 5 to 6) and fast pointer from index 8 to index 9 (position 9 to 10).',
              ),
              VisualizationStep(
                highlightIndices: [5, 9],
                previousIndices: [],
                explanation: 'Fast pointer has reached the end of the array at index 9 (position 10). Algorithm terminates with slow pointer at index 5 (position 6).',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Same Direction Two Pointers',
            description: 'This pattern uses two pointers moving in the same direction but at different positions.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 2],
                previousIndices: [],
                explanation: 'Initialize first pointer at index 0 (position 1) and second pointer at index 2 (position 3).',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [],
                explanation: 'Move first pointer from index 0 to index 1 (position 1 to 2). Second pointer remains at index 2 (position 3).',
              ),
              VisualizationStep(
                highlightIndices: [1, 3],
                previousIndices: [],
                explanation: 'Move second pointer from index 2 to index 3 (position 3 to 4). First pointer remains at index 1 (position 2).',
              ),
              VisualizationStep(
                highlightIndices: [2, 3],
                previousIndices: [],
                explanation: 'Move first pointer from index 1 to index 2 (position 2 to 3). Second pointer remains at index 3 (position 4).',
              ),
              VisualizationStep(
                highlightIndices: [2, 4],
                previousIndices: [],
                explanation: 'Move second pointer from index 3 to index 4 (position 4 to 5). First pointer remains at index 2 (position 3).',
              ),
              VisualizationStep(
                highlightIndices: [3, 4],
                previousIndices: [],
                explanation: 'Move first pointer from index 2 to index 3 (position 3 to 4). Second pointer remains at index 4 (position 5).',
              ),
              VisualizationStep(
                highlightIndices: [3, 5],
                previousIndices: [],
                explanation: 'Move second pointer from index 4 to index 5 (position 5 to 6). First pointer remains at index 3 (position 4).',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [],
                explanation: 'Move first pointer from index 3 to index 4 (position 4 to 5). Second pointer remains at index 5 (position 6).',
              ),
              VisualizationStep(
                highlightIndices: [4, 6],
                previousIndices: [],
                explanation: 'Move second pointer from index 5 to index 6 (position 6 to 7). First pointer remains at index 4 (position 5).',
              ),
              VisualizationStep(
                highlightIndices: [5, 6],
                previousIndices: [],
                explanation: 'Move first pointer from index 4 to index 5 (position 5 to 6). Second pointer remains at index 6 (position 7).',
              ),
              VisualizationStep(
                highlightIndices: [5, 7],
                previousIndices: [],
                explanation: 'Move second pointer from index 6 to index 7 (position 7 to 8). First pointer remains at index 5 (position 6).',
              ),
              VisualizationStep(
                highlightIndices: [5, 8],
                previousIndices: [],
                explanation: 'Move second pointer from index 7 to index 8 (position 8 to 9). First pointer remains at index 5 (position 6).',
              ),
              VisualizationStep(
                highlightIndices: [5, 9],
                previousIndices: [],
                explanation: 'Move second pointer from index 8 to index 9 (position 9 to 10). First pointer remains at index 5 (position 6). Algorithm terminates as second pointer reaches the end.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Three Pointers',
            description: 'This pattern uses three pointers to solve more complex problems like 3Sum.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 5, 9],
                previousIndices: [],
                explanation: 'Initialize three pointers: first pointer at index 0 (position 1), second pointer at index 5 (position 6), and third pointer at index 9 (position 10).',
              ),
              VisualizationStep(
                highlightIndices: [0, 4, 9],
                previousIndices: [],
                explanation: 'Move second pointer from index 5 to index 4 (position 6 to 5). First and third pointers remain at indices 0 and 9.',
              ),
              VisualizationStep(
                highlightIndices: [0, 4, 8],
                previousIndices: [],
                explanation: 'Move third pointer from index 9 to index 8 (position 10 to 9). First and second pointers remain at indices 0 and 4.',
              ),
              VisualizationStep(
                highlightIndices: [0, 3, 8],
                previousIndices: [],
                explanation: 'Move second pointer from index 4 to index 3 (position 5 to 4). First and third pointers remain at indices 0 and 8.',
              ),
              VisualizationStep(
                highlightIndices: [0, 3, 7],
                previousIndices: [],
                explanation: 'Move third pointer from index 8 to index 7 (position 9 to 8). First and second pointers remain at indices 0 and 3.',
              ),
              VisualizationStep(
                highlightIndices: [1, 3, 7],
                previousIndices: [],
                explanation: 'Move first pointer from index 0 to index 1 (position 1 to 2). Second and third pointers remain at indices 3 and 7.',
              ),
              VisualizationStep(
                highlightIndices: [1, 4, 7],
                previousIndices: [],
                explanation: 'Move second pointer from index 3 to index 4 (position 4 to 5). First and third pointers remain at indices 1 and 7.',
              ),
              VisualizationStep(
                highlightIndices: [1, 4, 6],
                previousIndices: [],
                explanation: 'Move third pointer from index 7 to index 6 (position 8 to 7). First and second pointers remain at indices 1 and 4.',
              ),
              VisualizationStep(
                highlightIndices: [2, 4, 6],
                previousIndices: [],
                explanation: 'Move first pointer from index 1 to index 2 (position 2 to 3). Second and third pointers remain at indices 4 and 6.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5, 6],
                previousIndices: [],
                explanation: 'Move second pointer from index 4 to index 5 (position 5 to 6). First and third pointers remain at indices 2 and 6.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5, 8],
                previousIndices: [],
                explanation: 'Move third pointer from index 6 to index 8 (position 7 to 9). First and second pointers remain at indices 2 and 5. Algorithm terminates.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Partition Array',
            description: 'This pattern uses multiple pointers to partition an array based on certain conditions.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 4, 9],
                previousIndices: [],
                explanation: 'Initialize pointers: low at index 0 (position 1), mid at index 4 (position 5), high at index 9 (position 10).',
              ),
              VisualizationStep(
                highlightIndices: [0, 4, 8],
                previousIndices: [],
                explanation: 'Move high pointer from index 9 to index 8 (position 10 to 9). Low and mid pointers remain at indices 0 and 4.',
              ),
              VisualizationStep(
                highlightIndices: [1, 4, 8],
                previousIndices: [],
                explanation: 'Move low pointer from index 0 to index 1 (position 1 to 2). Mid and high pointers remain at indices 4 and 8.',
              ),
              VisualizationStep(
                highlightIndices: [1, 4, 7],
                previousIndices: [],
                explanation: 'Move high pointer from index 8 to index 7 (position 9 to 8). Low and mid pointers remain at indices 1 and 4.',
              ),
              VisualizationStep(
                highlightIndices: [2, 4, 7],
                previousIndices: [],
                explanation: 'Move low pointer from index 1 to index 2 (position 2 to 3). Mid and high pointers remain at indices 4 and 7.',
              ),
              VisualizationStep(
                highlightIndices: [2, 4, 6],
                previousIndices: [],
                explanation: 'Move high pointer from index 7 to index 6 (position 8 to 7). Low and mid pointers remain at indices 2 and 4.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5, 6],
                previousIndices: [],
                explanation: 'Move mid pointer from index 4 to index 5 (position 5 to 6). Low and high pointers remain at indices 2 and 6.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5, 6],
                previousIndices: [],
                explanation: 'Move low pointer from index 2 to index 1 (position 3 to 2). Mid and high pointers remain at indices 5 and 6.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5, 7],
                previousIndices: [],
                explanation: 'Move high pointer from index 6 to index 7 (position 7 to 8). Low and mid pointers remain at indices 1 and 5.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5, 8],
                previousIndices: [],
                explanation: 'Move high pointer from index 7 to index 8 (position 8 to 9). Low and mid pointers remain at indices 1 and 5.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5, 9],
                previousIndices: [],
                explanation: 'Move high pointer from index 8 to index 9 (position 9 to 10). Low and mid pointers remain at indices 1 and 5. Algorithm terminates.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'sliding_window',
        name: 'Sliding Window',
        category: 'DSA',
        description: 'Sliding Window is a computational technique that aims to reduce the use of nested loops '
            'and replace it with a single loop, thereby reducing the time complexity.',
        steps: [
          'Define a window with start and end pointers',
          'Expand/contract the window by moving the pointers',
          'Calculate the answer based on elements in the current window',
          'Continue until the end pointer reaches the end of the array'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Fixed Size Window',
            description: 'This pattern maintains a fixed-size window that slides through the array.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [],
                explanation: 'Initialize window of size 3 starting from indices 0, 1, and 2.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2, 3],
                previousIndices: [0, 1, 2],
                explanation: 'Slide the window by removing index 0 and adding index 3.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3, 4],
                previousIndices: [1, 2, 3],
                explanation: 'Continue sliding the window by removing index 1 and adding index 4.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4, 5],
                previousIndices: [2, 3, 4],
                explanation: 'Slide the window by removing index 2 and adding index 5.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5, 6],
                previousIndices: [3, 4, 5],
                explanation: 'Continue sliding the window by removing index 3 and adding index 6.',
              ),
              VisualizationStep(
                highlightIndices: [5, 6, 7],
                previousIndices: [4, 5, 6],
                explanation: 'Slide the window by removing index 4 and adding index 7.',
              ),
              VisualizationStep(
                highlightIndices: [6, 7, 8],
                previousIndices: [5, 6, 7],
                explanation: 'Continue sliding until the window reaches the end of the array.',
              ),
              VisualizationStep(
                highlightIndices: [7, 8, 9],
                previousIndices: [6, 7, 8],
                explanation: 'Final window position at the end of the array.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Variable Size Window',
            description: 'This pattern adjusts the window size based on certain conditions.',
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start with a window of size 1 at index 0 (position 1).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [],
                explanation: 'Expand the window by adding index 1 (position 2).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [],
                explanation: 'Continue expanding the window by adding index 2 (position 3).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2, 3],
                previousIndices: [],
                explanation: 'Expand the window further by adding index 3 (position 4).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2, 3, 4],
                previousIndices: [],
                explanation: 'Expand the window by adding index 4 (position 5).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2, 3, 4, 5],
                previousIndices: [],
                explanation: 'Expand the window by adding index 5 (position 6).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2, 3, 4, 5, 6],
                previousIndices: [],
                explanation: 'Expand the window by adding index 6 (position 7).',
              ),
              VisualizationStep(
                highlightIndices: [1, 2, 3, 4, 5, 6],
                previousIndices: [],
                explanation: 'Contract the window by removing index 0 (position 1).',
              ),
              VisualizationStep(
                highlightIndices: [2, 3, 4, 5, 6],
                previousIndices: [],
                explanation: 'Contract the window by removing index 1 (position 2).',
              ),
              VisualizationStep(
                highlightIndices: [3, 4, 5, 6, 7],
                previousIndices: [],
                explanation: 'Slide the window by removing index 2 (position 3) and adding index 7 (position 8).',
              ),
              VisualizationStep(
                highlightIndices: [4, 5, 6, 7, 8],
                previousIndices: [],
                explanation: 'Slide the window by removing index 3 (position 4) and adding index 8 (position 9).',
              ),
              VisualizationStep(
                highlightIndices: [5, 6, 7, 8, 9],
                previousIndices: [],
                explanation: 'Slide the window by removing index 4 (position 5) and adding index 9 (position 10). Algorithm terminates.',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}