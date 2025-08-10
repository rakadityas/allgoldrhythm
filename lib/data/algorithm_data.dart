import '../models/algorithm.dart';

class AlgorithmData {
  static List<Algorithm> getAlgorithms() {
    return [
      Algorithm(
        id: 'two_pointers',
        name: 'Two Pointers',
        category: 'Data Structures & Algorithm',
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
        category: 'Data Structures & Algorithm',
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
      Algorithm(
        id: 'stack',
        name: 'Stack',
        category: 'Data Structures & Algorithm',
        description: 'A stack is a linear data structure that follows the Last In First Out (LIFO) principle. '
            'Elements are added and removed from the same end, called the top of the stack. '
            'Common operations include push (add), pop (remove), peek/top (view top element), and isEmpty.',
        steps: [
          'Initialize an empty stack',
          'Push elements onto the stack (elements go to the top)',
          'Pop elements from the stack (removes from the top)',
          'Peek at the top element without removing it',
          'Check if stack is empty before popping'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Basic Stack Operations',
            description: 'This simulation shows how elements are pushed and popped from a stack following LIFO principle.',
            steps: [
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Initialize an empty stack. The stack is currently empty.',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Push element 10 onto the stack. Element 10 is now at the top (index 0).',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Push element 20 onto the stack. Element 20 is now at the top (index 1), 10 is below.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                explanation: 'Push element 30 onto the stack. Element 30 is now at the top (index 2).',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1, 2],
                explanation: 'Push element 40 onto the stack. Element 40 is now at the top (index 3).',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 2, 3],
                explanation: 'Push element 50 onto the stack. Element 50 is now at the top (index 4).',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2, 3, 4],
                explanation: 'Push element 60 onto the stack. Element 60 is now at the top (index 5).',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [0, 1, 2, 3, 4, 5],
                explanation: 'Push element 70 onto the stack. Element 70 is now at the top (index 6).',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [0, 1, 2, 3, 4, 5, 6],
                explanation: 'Push element 80 onto the stack. Element 80 is now at the top (index 7).',
              ),
              VisualizationStep(
                highlightIndices: [8],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7],
                explanation: 'Push element 90 onto the stack. Element 90 is now at the top (index 8).',
              ),
              VisualizationStep(
                highlightIndices: [9],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8],
                explanation: 'Push element 100 onto the stack. Element 100 is now at the top (index 9). Stack is full.',
              ),
              VisualizationStep(
                highlightIndices: [8],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7],
                explanation: 'Pop element from stack. Element 100 is removed, 90 is now at the top (index 8).',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [0, 1, 2, 3, 4, 5, 6],
                explanation: 'Pop element from stack. Element 90 is removed, 80 is now at the top (index 7).',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [0, 1, 2, 3, 4, 5],
                explanation: 'Pop element from stack. Element 80 is removed, 70 is now at the top (index 6).',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Stack Operations Quiz',
            description: 'Test your understanding of stack operations and LIFO principle.',
            steps: [
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 1: What does LIFO stand for in the context of stacks?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Last In First Out - the last element added is the first one to be removed.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 2: Which operation adds an element to the top of the stack?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Push operation adds an element to the top of the stack.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 3: What happens when you try to pop from an empty stack?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: This causes a stack underflow error. Always check if stack is empty before popping.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'linked_list',
        name: 'Linked List',
        category: 'Data Structures & Algorithm',
        description: 'A linked list is a linear data structure where elements are stored in nodes, '
            'and each node contains data and a reference (or link) to the next node. '
            'Unlike arrays, linked lists do not store elements in contiguous memory locations.',
        steps: [
          'Create nodes with data and next pointer',
          'Link nodes together by setting next pointers',
          'Maintain a head pointer to the first node',
          'Traverse the list by following next pointers',
          'Insert or delete nodes by updating pointers'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Linked List Traversal and Insertion',
            description: 'This simulation shows how to traverse a linked list and insert new nodes.',
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start with head node containing value 10. Head points to the first node (index 0).',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Add second node with value 20. First node now points to second node (index 1).',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                explanation: 'Add third node with value 30. Second node now points to third node (index 2).',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1, 2],
                explanation: 'Add fourth node with value 40. Third node now points to fourth node (index 3).',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 2, 3],
                explanation: 'Add fifth node with value 50. Fourth node now points to fifth node (index 4).',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2, 3, 4],
                explanation: 'Add sixth node with value 60. Fifth node now points to sixth node (index 5).',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [0, 1, 2, 3, 4, 5],
                explanation: 'Add seventh node with value 70. Sixth node now points to seventh node (index 6).',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [0, 1, 2, 3, 4, 5, 6],
                explanation: 'Add eighth node with value 80. Seventh node now points to eighth node (index 7).',
              ),
              VisualizationStep(
                highlightIndices: [8],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7],
                explanation: 'Add ninth node with value 90. Eighth node now points to ninth node (index 8).',
              ),
              VisualizationStep(
                highlightIndices: [9],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8],
                explanation: 'Add tenth node with value 100. Ninth node now points to tenth node (index 9).',
              ),
              VisualizationStep(
                highlightIndices: [2, 10],
                previousIndices: [0, 1, 3, 4, 5, 6, 7, 8, 9],
                explanation: 'Insert new node with value 25 between nodes 20 and 30. Update pointers accordingly.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                previousIndices: [],
                explanation: 'Traverse the complete linked list from head to tail. Each node points to the next.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2, 3, 4, 6, 7, 8, 9, 10],
                explanation: 'Delete node with value 60. Update previous node to point to next node, skipping deleted node.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Linked List Concepts Quiz',
            description: 'Test your understanding of linked list structure and operations.',
            steps: [
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 1: What is the main advantage of linked lists over arrays?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Dynamic size - linked lists can grow or shrink during runtime without declaring fixed size.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 2: What does each node in a linked list contain?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Each node contains data and a pointer/reference to the next node in the sequence.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 3: How do you access the middle element of a linked list?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: You must traverse from the head node, following next pointers until you reach the desired position.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'binary_search',
        name: 'Binary Search',
        category: 'Data Structures & Algorithm',
        description: 'Binary search is an efficient algorithm for finding a target value in a sorted array. '
            'It works by repeatedly dividing the search interval in half, comparing the target with the middle element, '
            'and eliminating half of the remaining elements. Time complexity: O(log n), Space complexity: O(1).',
        steps: [
          'Initialize left pointer to 0 and right pointer to array length - 1',
          'Calculate middle index as (left + right) / 2',
          'Compare target with middle element',
          'If target equals middle element, return the index',
          'If target is less than middle, search left half (right = mid - 1)',
          'If target is greater than middle, search right half (left = mid + 1)',
          'Repeat until target is found or left > right'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Binary Search for Target Value',
            description: 'This simulation shows how binary search efficiently finds a target value in a sorted array by dividing the search space in half.',
            steps: [
              VisualizationStep(
                highlightIndices: [0, 9],
                previousIndices: [],
                explanation: 'Initialize: left = 0, right = 9. Searching for target value 35 in sorted array [5, 12, 18, 23, 35, 42, 56, 67, 78, 89].',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 9],
                explanation: 'Calculate middle: mid = (0 + 9) / 2 = 4. Compare target 35 with array[4] = 35. Found match!',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Target found at index 4. Binary search completed successfully in 1 comparison.',
              ),
              VisualizationStep(
                highlightIndices: [0, 9],
                previousIndices: [],
                explanation: 'New search: Looking for target value 67. Reset: left = 0, right = 9.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 9],
                explanation: 'Calculate middle: mid = (0 + 9) / 2 = 4. Compare target 67 with array[4] = 35. Target > 35, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [5, 9],
                previousIndices: [0, 4],
                explanation: 'Update search range: left = 5, right = 9. Eliminated left half of array.',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [5, 9],
                explanation: 'Calculate middle: mid = (5 + 9) / 2 = 7. Compare target 67 with array[7] = 67. Found match!',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Target found at index 7. Binary search completed in 2 comparisons.',
              ),
              VisualizationStep(
                highlightIndices: [0, 9],
                previousIndices: [],
                explanation: 'New search: Looking for target value 12. Reset: left = 0, right = 9.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 9],
                explanation: 'Calculate middle: mid = (0 + 9) / 2 = 4. Compare target 12 with array[4] = 35. Target < 35, search left half.',
              ),
              VisualizationStep(
                highlightIndices: [0, 3],
                previousIndices: [4, 9],
                explanation: 'Update search range: left = 0, right = 3. Eliminated right half of array.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0, 3],
                explanation: 'Calculate middle: mid = (0 + 3) / 2 = 1. Compare target 12 with array[1] = 12. Found match!',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Target found at index 1. Binary search completed in 2 comparisons.',
              ),
              VisualizationStep(
                highlightIndices: [0, 9],
                previousIndices: [],
                explanation: 'New search: Looking for target value 100 (not in array). Reset: left = 0, right = 9.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 9],
                explanation: 'Calculate middle: mid = (0 + 9) / 2 = 4. Compare target 100 with array[4] = 35. Target > 35, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [5, 9],
                previousIndices: [0, 4],
                explanation: 'Update search range: left = 5, right = 9.',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [5, 9],
                explanation: 'Calculate middle: mid = (5 + 9) / 2 = 7. Compare target 100 with array[7] = 67. Target > 67, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [8, 9],
                previousIndices: [5, 7],
                explanation: 'Update search range: left = 8, right = 9.',
              ),
              VisualizationStep(
                highlightIndices: [8],
                previousIndices: [9],
                explanation: 'Calculate middle: mid = (8 + 9) / 2 = 8. Compare target 100 with array[8] = 78. Target > 78, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [9],
                previousIndices: [8],
                explanation: 'Update search range: left = 9, right = 9. Only one element left.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Compare target 100 with array[9] = 89. Target > 89. Left > right, target not found. Return -1.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'interactive_review',
            title: 'Binary Search Concepts Quiz',
            description: 'Test your understanding of binary search algorithm and its properties.',
            steps: [
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 1: What is the prerequisite for using binary search?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: The array must be sorted in ascending or descending order.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 2: What is the time complexity of binary search?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: O(log n) - we eliminate half the search space in each iteration.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 3: How do you calculate the middle index in binary search?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: middle = (left + right) / 2, where left and right are the current search boundaries.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 4: When do you update the left pointer in binary search?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: When the target is greater than the middle element, set left = mid + 1.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'queue',
        name: 'Queue',
        category: 'Data Structures & Algorithm',
        description: 'A linear data structure that follows the First In First Out (FIFO) principle.',
        steps: [
          'Initialize an empty queue',
          'Enqueue (add) elements to the rear of the queue',
          'Dequeue (remove) elements from the front of the queue',
          'Check if the queue is empty before dequeuing',
          'Peek at the front element without removing it',
          'Get the size of the queue',
          'Process elements in FIFO order'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Queue Basic Operations',
            description: 'Demonstration of basic queue operations: enqueue, dequeue, and peek',
            steps: [
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Starting with an empty queue. Queue follows FIFO (First In First Out) principle. Array: []',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Enqueue 10: Add element to the rear of the queue. Array: [10]',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Enqueue 20: Add element to the rear of the queue. Array: [10, 20]',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                explanation: 'Enqueue 30: Add element to the rear of the queue. Array: [10, 20, 30]',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1, 2],
                explanation: 'Enqueue 40: Add element to the rear of the queue. Array: [10, 20, 30, 40]',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 2, 3],
                explanation: 'Enqueue 50: Add element to the rear of the queue. Array: [10, 20, 30, 40, 50]',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2, 3, 4],
                explanation: 'Enqueue 60: Add element to the rear of the queue. Array: [10, 20, 30, 40, 50, 60]',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [0, 1, 2, 3, 4, 5],
                explanation: 'Enqueue 70: Add element to the rear of the queue. Array: [10, 20, 30, 40, 50, 60, 70]',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [0, 1, 2, 3, 4, 5, 6],
                explanation: 'Enqueue 80: Add element to the rear of the queue. Array: [10, 20, 30, 40, 50, 60, 70, 80]',
              ),
              VisualizationStep(
                highlightIndices: [8],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7],
                explanation: 'Enqueue 90: Add element to the rear of the queue. Array: [10, 20, 30, 40, 50, 60, 70, 80, 90]',
              ),
              VisualizationStep(
                highlightIndices: [9],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8],
                explanation: 'Enqueue 100: Queue now contains 10 elements. Array: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                explanation: 'Peek: View the front element (10) without removing it. Array: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8],
                explanation: 'Dequeue: Remove front element (10). Element 20 is now at the front. Array: [20, 30, 40, 50, 60, 70, 80, 90, 100]',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1, 2, 3, 4, 5, 6, 7],
                explanation: 'Dequeue: Remove front element (20). Element 30 is now at the front. Array: [30, 40, 50, 60, 70, 80, 90, 100]',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1, 2, 3, 4, 5, 6],
                explanation: 'Dequeue: Remove front element (30). Element 40 is now at the front. Array: [40, 50, 60, 70, 80, 90, 100]',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [1, 2, 3, 4, 5, 6],
                explanation: 'Queue operations complete. Front element is 40, rear element is 100. Array: [40, 50, 60, 70, 80, 90, 100]',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'interactive',
            title: 'Queue Concepts Quiz',
            description: 'Interactive review of queue data structure concepts',
            steps: [
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 1: What does FIFO stand for in queue data structure?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: FIFO stands for First In First Out - the first element added is the first to be removed.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 2: What is the time complexity of enqueue and dequeue operations?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Both enqueue and dequeue operations have O(1) time complexity.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 3: Where are elements added in a queue?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Elements are added at the rear (back/tail) of the queue.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Question 4: Where are elements removed from in a queue?',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Answer: Elements are removed from the front (head) of the queue.',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}