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
            mockQuestion: 'Given the sorted array [2, 4, 5, 7, 9, 11, 13, 15], find two numbers that add up to 16. Why start by checking the smallest and largest numbers together, instead of every possible pair?',
            values: const [2, 4, 5, 7, 9, 11, 13, 15],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 7],
                previousIndices: [],
                explanation: 'Left at index 0 (value 2), right at index 7 (value 15). Sum = 2 + 15 = 17, which is greater than target 16 — the sum is too big, so move the right pointer left to try a smaller number.',
              ),
              VisualizationStep(
                highlightIndices: [0, 6],
                previousIndices: [0, 7],
                explanation: 'Left stays at index 0 (value 2), right moves to index 6 (value 13). Sum = 2 + 13 = 15, which is less than target 16 — the sum is too small, so move the left pointer right to try a bigger number.',
              ),
              VisualizationStep(
                highlightIndices: [1, 6],
                previousIndices: [0, 6],
                explanation: 'Left moves to index 1 (value 4), right stays at index 6 (value 13). Sum = 4 + 13 = 17, too big again — move the right pointer left.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5],
                previousIndices: [1, 6],
                explanation: 'Left stays at index 1 (value 4), right moves to index 5 (value 11). Sum = 4 + 11 = 15, too small — move the left pointer right.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5],
                previousIndices: [1, 5],
                explanation: 'Left moves to index 2 (value 5), right stays at index 5 (value 11). Sum = 5 + 11 = 16 — that matches the target! Two Sum found: 5 + 11 = 16.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Fast-Slow Two Pointers',
            description: 'This pattern uses two pointers moving at different speeds from the same direction.',
            mockQuestion: 'Given the chain of nodes [3, 7, 2, 9, 4, 15, 6, 11], you want to know if it loops back on itself somewhere. Why would one pointer moving twice as fast as the other eventually catch up if there\'s a loop?',
            values: const [3, 7, 2, 9, 4, 15, 6, 11],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Initialize both slow and fast pointers at index 0 (value 3) — same starting point. Each step, slow moves 1 node forward and fast moves 2, so if the list loops back on itself, fast will eventually lap around and meet slow again.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [0],
                explanation: 'Slow moves 1 step to index 1 (value 7). Fast moves 2 steps to index 2 (value 2). They land on different nodes, so no cycle detected yet — keep going.',
              ),
              VisualizationStep(
                highlightIndices: [2, 4],
                previousIndices: [1, 2],
                explanation: 'Slow moves to index 2 (value 2). Fast moves to index 4 (value 4). Still different nodes — continue.',
              ),
              VisualizationStep(
                highlightIndices: [3, 6],
                previousIndices: [2, 4],
                explanation: 'Slow moves to index 3 (value 9). Fast moves to index 6 (value 6). Still no match — continue.',
              ),
              VisualizationStep(
                highlightIndices: [4, 7],
                previousIndices: [3, 6],
                explanation: 'Slow moves to index 4 (value 4). Fast moves to index 7 (value 11) — the last node. Fast reached the end instead of looping back to meet slow, so this list has no cycle.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Same Direction Two Pointers',
            description: 'This pattern uses two pointers moving in the same direction but at different positions.',
            mockQuestion: 'Given the array [4, 0, 3, 0, 5, 0, 8, 2], move all the zeros to the end without losing the order of the other numbers. Why do both pointers move forward instead of toward each other?',
            values: const [4, 0, 3, 0, 5, 0, 8, 2],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Write pointer at index 0. Read pointer also at index 0, value 4 (nonzero) — a nonzero value belongs at the write position, so it stays here and both pointers advance.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Write pointer waits at index 1. Read pointer moves to index 1, value 0 — zeros are skipped, so only the read pointer advances; write stays put until it finds the next nonzero value.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [1],
                explanation: 'Write pointer still at index 1. Read pointer moves to index 2, value 3 (nonzero) — this value belongs at the write position (index 1), so it would move there and both pointers advance.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3],
                previousIndices: [1, 2],
                explanation: 'Write pointer advances to index 2. Read pointer moves to index 3, value 0 — skip it, write stays at index 2.',
              ),
              VisualizationStep(
                highlightIndices: [2, 4],
                previousIndices: [2, 3],
                explanation: 'Write pointer still at index 2. Read pointer moves to index 4, value 5 (nonzero) — belongs at the write position, both pointers advance.',
              ),
              VisualizationStep(
                highlightIndices: [3, 5],
                previousIndices: [2, 4],
                explanation: 'Write pointer advances to index 3. Read pointer moves to index 5, value 0 — skip it, write stays at index 3.',
              ),
              VisualizationStep(
                highlightIndices: [3, 6],
                previousIndices: [3, 5],
                explanation: 'Write pointer still at index 3. Read pointer moves to index 6, value 8 (nonzero) — belongs at the write position, both pointers advance.',
              ),
              VisualizationStep(
                highlightIndices: [4, 7],
                previousIndices: [3, 6],
                explanation: 'Write pointer advances to index 4. Read pointer reaches index 7, value 2 (nonzero) — belongs at the write position. Read pointer has reached the end: every nonzero value now sits before index 5, with all zeros pushed after it.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Three Pointers',
            description: 'This pattern uses three pointers to solve more complex problems like 3Sum.',
            mockQuestion: 'Given the sorted array [-4, -1, -1, 0, 1, 2, 3, 4], find three numbers that add up to zero. Why is one pointer not enough, and why do we need three moving together?',
            values: const [-4, -1, -1, 0, 1, 2, 3, 4],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 1, 7],
                previousIndices: [],
                explanation: 'Fix the first number at index 0 (value -4). Left at index 1 (-1), right at index 7 (4). Sum = -4 + -1 + 4 = -1, which is less than 0 — too small, move the left pointer right for a bigger number.',
              ),
              VisualizationStep(
                highlightIndices: [0, 2, 7],
                previousIndices: [0, 1, 7],
                explanation: 'Left moves to index 2 (value -1). Sum = -4 + -1 + 4 = -1, still less than 0 — move the left pointer right again.',
              ),
              VisualizationStep(
                highlightIndices: [0, 3, 7],
                previousIndices: [0, 2, 7],
                explanation: 'Left moves to index 3 (value 0). Sum = -4 + 0 + 4 = 0 — found a triplet: -4 + 0 + 4 = 0! To find more, move both pointers inward and keep searching.',
              ),
              VisualizationStep(
                highlightIndices: [0, 4, 6],
                previousIndices: [0, 3, 7],
                explanation: 'Left moves to index 4 (value 1), right moves to index 6 (value 3). Sum = -4 + 1 + 3 = 0 — another triplet found: -4 + 1 + 3 = 0!',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Partition Array',
            description: 'This pattern uses multiple pointers to partition an array based on certain conditions.',
            mockQuestion: 'Given [2, 0, 1, 2, 0, 1, 2, 0] where 0 = red, 1 = white, 2 = blue, classify every value into its color group in a single left-to-right scan. Why does knowing just the current value tell you exactly where it belongs?',
            values: const [2, 0, 1, 2, 0, 1, 2, 0],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Mid pointer at index 0, value 2 (blue). 2 is the highest color value, so it belongs in the group at the end — mark it and move on.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Mid pointer at index 1, value 0 (red). 0 is the lowest color value, so it belongs in the group at the front.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'Mid pointer at index 2, value 1 (white). 1 is the middle color value, so it already belongs right where it is.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2],
                explanation: 'Mid pointer at index 3, value 2 (blue) — belongs at the end, same as index 0.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [3],
                explanation: 'Mid pointer at index 4, value 0 (red) — belongs at the front.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [4],
                explanation: 'Mid pointer at index 5, value 1 (white) — already in the right group.',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [5],
                explanation: 'Mid pointer at index 6, value 2 (blue) — belongs at the end.',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [6],
                explanation: 'Mid pointer at index 7, value 0 (red) — belongs at the front. Scan complete: 3 reds, 2 whites, 3 blues classified in one pass.',
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
            mockQuestion: 'Given the array [2, 5, 1, 8, 3, 9, 4, 7], find the largest sum of any 3 consecutive numbers. Why not add up every possible group of 3 from scratch each time?',
            values: const [2, 5, 1, 8, 3, 9, 4, 7],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [],
                explanation: 'Window covers indices 0-2: values 2, 5, 1. Sum = 2 + 5 + 1 = 8. This is the largest sum seen so far.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2, 3],
                previousIndices: [0, 1, 2],
                explanation: 'Slide right: drop index 0 (value 2), add index 3 (value 8). New sum = 5 + 1 + 8 = 14, bigger than before — update the best sum.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3, 4],
                previousIndices: [1, 2, 3],
                explanation: 'Drop index 1 (value 5), add index 4 (value 3). New sum = 1 + 8 + 3 = 12, smaller than our best of 14 — keep the previous best.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4, 5],
                previousIndices: [2, 3, 4],
                explanation: 'Drop index 2 (value 1), add index 5 (value 9). New sum = 8 + 3 + 9 = 20 — a new best!',
              ),
              VisualizationStep(
                highlightIndices: [4, 5, 6],
                previousIndices: [3, 4, 5],
                explanation: 'Drop index 3 (value 8), add index 6 (value 4). New sum = 3 + 9 + 4 = 16, smaller than our best of 20.',
              ),
              VisualizationStep(
                highlightIndices: [5, 6, 7],
                previousIndices: [4, 5, 6],
                explanation: 'Drop index 4 (value 3), add index 7 (value 7). New sum = 9 + 4 + 7 = 20, ties our best. Window reaches the end of the array — the largest 3-element sum is 20.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Variable Size Window',
            description: 'This pattern adjusts the window size based on certain conditions.',
            mockQuestion: 'Given the array [2, 1, 5, 1, 3, 2, 7, 1], find the smallest group of neighboring numbers that add up to at least 8. Why grow the group only when needed, and shrink it once it works?',
            values: const [2, 1, 5, 1, 3, 2, 7, 1],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Add index 0 (value 2). Sum = 2, still below target 8 — expand the window further.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [0],
                explanation: 'Add index 1 (value 1). Sum = 3, still below 8 — keep expanding.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [0, 1],
                explanation: 'Add index 2 (value 5). Sum = 8 — that meets the target! Current window size = 3. This is our best so far.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [0, 1, 2],
                explanation: 'The sum already meets the target, so try shrinking from the left to find a smaller window. Remove index 0 (value 2). New sum = 6, which drops below target — stop shrinking. Window size 3 stays our best.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2, 3],
                previousIndices: [1, 2],
                explanation: 'Add index 3 (value 1). Sum = 7, below target — expand again.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2, 3, 4],
                previousIndices: [1, 2, 3],
                explanation: 'Add index 4 (value 3). Sum = 10 — meets the target! Current window size = 4, not better than our best of 3 yet — try shrinking.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3, 4],
                previousIndices: [1, 2, 3, 4],
                explanation: 'Remove index 1 (value 1). New sum = 9, still meets target. Window size = 3, ties our best.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4],
                previousIndices: [2, 3, 4],
                explanation: 'Remove index 2 (value 5). New sum = 4, drops below target — stop shrinking.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4, 5],
                previousIndices: [3, 4],
                explanation: 'Add index 5 (value 2). Sum = 6, below target — expand.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4, 5, 6],
                previousIndices: [3, 4, 5],
                explanation: 'Add index 6 (value 7). Sum = 13 — meets target! Window size = 4.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5, 6],
                previousIndices: [3, 4, 5, 6],
                explanation: 'Remove index 3 (value 1). New sum = 12, still meets target. Window size = 3, ties best.',
              ),
              VisualizationStep(
                highlightIndices: [5, 6],
                previousIndices: [4, 5, 6],
                explanation: 'Remove index 4 (value 3). New sum = 9, still meets target. Window size = 2 — a new best, smaller than 3!',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [5, 6],
                explanation: 'Remove index 5 (value 2). New sum = 7, drops below target — stop shrinking.',
              ),
              VisualizationStep(
                highlightIndices: [6, 7],
                previousIndices: [6],
                explanation: 'Add index 7 (value 1). Sum = 8 — meets target! Window size = 2, ties our best.',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [6, 7],
                explanation: 'Remove index 6 (value 7). New sum = 1, drops below target — stop. We\'ve reached the end of the array. Smallest window found: size 2 (indices 5-6, values 2 + 7 = 9).',
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
            mockQuestion: 'You\'re stacking plates on a table, one on top of the other. When you need to take one off, why can you only take the top plate first?',
            values: const [10, 20, 30, 40, 50, 60, 70, 80],
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
                explanation: 'Push element 80 onto the stack. Element 80 is now at the top (index 7). Stack is full.',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [0, 1, 2, 3, 4, 5],
                explanation: 'Pop element from stack. Element 80 is removed, 70 is now at the top (index 6).',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2, 3, 4],
                explanation: 'Pop element from stack. Element 70 is removed, 60 is now at the top (index 5).',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 2, 3],
                explanation: 'Pop element from stack. Element 60 is removed, 50 is now at the top (index 4).',
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
            mockQuestion: 'You\'re standing in a line for a ticket counter. Why does the person who joined the line first get served first, no matter who joins after them?',
            values: const [10, 20, 30, 40, 50, 60, 70, 80],
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
                explanation: 'Enqueue 80: Queue now contains 8 elements. Array: [10, 20, 30, 40, 50, 60, 70, 80]',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [1, 2, 3, 4, 5, 6, 7],
                explanation: 'Peek: View the front element (10) without removing it. Array: [10, 20, 30, 40, 50, 60, 70, 80]',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1, 2, 3, 4, 5, 6],
                explanation: 'Dequeue: Remove front element (10). Element 20 is now at the front. Array: [20, 30, 40, 50, 60, 70, 80]',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1, 2, 3, 4, 5],
                explanation: 'Dequeue: Remove front element (20). Element 30 is now at the front. Array: [30, 40, 50, 60, 70, 80]',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1, 2, 3, 4],
                explanation: 'Dequeue: Remove front element (30). Element 40 is now at the front. Array: [40, 50, 60, 70, 80]',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [1, 2, 3, 4],
                explanation: 'Queue operations complete. Front element is 40, rear element is 80. Array: [40, 50, 60, 70, 80]',
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
            mockQuestion: 'You want to find the 5th song in a playlist where each song only knows which song comes next. Why do you have to start at the first song and count one by one?',
            values: const [10, 20, 30, 40, 50, 60, 70, 80, 25],
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
                highlightIndices: [2, 8],
                previousIndices: [0, 1, 3, 4, 5, 6, 7],
                explanation: 'Insert new node with value 25 between nodes 20 and 30. Update pointers accordingly.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8],
                previousIndices: [],
                explanation: 'Traverse the complete linked list from head to tail. Each node points to the next.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2, 3, 4, 6, 7, 8],
                removedIndices: [5],
                explanation: 'Delete node with value 60 (index 5). Mark it as removed — the previous node (50) will be rewired to skip over it.',
              ),
              VisualizationStep(
                highlightIndices: [4, 6],
                previousIndices: [],
                removedIndices: [5],
                explanation: 'Node 50 (index 4) now points directly to node 70 (index 6), skipping the removed node entirely. Node 60 is gone from the chain — deletion complete.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'doubly_linked_list',
        name: 'Doubly Linked List',
        category: 'Data Structures & Algorithm',
        description: 'A doubly linked list is like a singly linked list, but each node also stores a pointer '
            'to the previous node, not just the next one. This makes backward traversal possible and lets '
            'you delete a node in O(1) time once you have a reference to it, since its neighbors are already known.',
        steps: [
          'Each node stores a value, a next pointer, and a prev pointer',
          'Forward traversal follows next pointers, just like a singly linked list',
          'Backward traversal follows prev pointers — not possible in a singly linked list without extra work',
          'Deletion is O(1) given a node reference, since both neighbors are already known',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Backward Traversal',
            description: 'Walk the list from tail to head using each node\'s prev pointer.',
            mockQuestion: 'You just listened to song 5 in a playlist and want to go back to song 4, then song 3. Why can a doubly linked list do this instantly, while a singly linked list would have to restart from the beginning?',
            values: const [15, 25, 35, 45, 55],
            steps: [
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [],
                explanation: 'Start at the tail: index 4 (value 55). In a singly linked list this would already be a problem — you can only reach the tail by walking all the way from the head.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [4],
                explanation: 'Follow node 55\'s prev pointer back to index 3 (value 45). A singly linked list has no prev pointer, so it could not make this move directly.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [3],
                explanation: 'Follow node 45\'s prev pointer back to index 2 (value 35).',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [2],
                explanation: 'Follow node 35\'s prev pointer back to index 1 (value 25).',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [1],
                explanation: 'Follow node 25\'s prev pointer back to index 0 (value 15) — the head. Backward traversal complete, in the same O(n) time forward traversal would take.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'O(1) Deletion',
            description: 'Delete a node directly using its prev and next pointers, without scanning the list.',
            mockQuestion: 'You have a direct reference to the node holding value 35 and want to remove it. Why don\'t you need to search the list to find what comes before it?',
            values: const [15, 25, 35, 45, 55],
            steps: [
              VisualizationStep(
                highlightIndices: [1, 2, 3],
                previousIndices: [],
                explanation: 'Node 35 (index 2) already stores pointers to both neighbors: prev points to node 25 (index 1), next points to node 45 (index 3). No scanning needed to find them — unlike a singly linked list, which would have to walk from the head to find the predecessor.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1, 2, 3],
                removedIndices: [2],
                explanation: 'Delete node 35 (index 2) — mark it removed.',
              ),
              VisualizationStep(
                highlightIndices: [1, 3],
                previousIndices: [],
                removedIndices: [2],
                explanation: 'Rewire directly: node 25\'s next now points to node 45, and node 45\'s prev now points to node 25. Done in O(1) — no traversal required.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'circular_linked_list',
        name: 'Circular Linked List',
        category: 'Data Structures & Algorithm',
        description: 'A circular linked list is a singly (or doubly) linked list where the last node points '
            'back to the head instead of to null. This lets traversal continue indefinitely, which is ideal '
            'for anything that repeats in a cycle, like round-robin scheduling or a looping playlist.',
        steps: [
          'Each node points to the next, like a singly linked list',
          'The last node points back to the head instead of null',
          'Traversal can continue indefinitely by looping back to the start',
          'Useful for round-robin scheduling and repeating sequences',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Round-Robin Traversal',
            description: 'Cycle through a fixed set of nodes repeatedly, wrapping back to the head at the end.',
            mockQuestion: 'Four players take turns in a game, and after player 4 it\'s player 1\'s turn again. Why does a circular linked list model this more naturally than a regular (null-terminated) linked list?',
            values: const [1, 2, 3, 4],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Turn 1: player 1 (index 0) goes.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Turn 2: follow next to player 2 (index 1).',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'Turn 3: follow next to player 3 (index 2).',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2],
                explanation: 'Turn 4: follow next to player 4 (index 3) — the last node in the list.',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [3],
                explanation: 'Turn 5: player 4\'s next pointer doesn\'t point to null — it wraps back to player 1 (index 0). A regular linked list would have stopped here; this one keeps going.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Turn 6: player 2 again, continuing the same loop.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'Turn 7: player 3 again.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2],
                explanation: 'Turn 8: player 4 again. The cycle will keep repeating for as long as the game continues — that\'s the whole point of a circular list.',
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
            mockQuestion: 'You\'re looking for a name in a sorted phone book. Why do you open to the middle page instead of starting from page one?',
            values: const [5, 12, 18, 23, 35, 42, 56, 67],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 7],
                previousIndices: [],
                explanation: 'Initialize: left = 0, right = 7. Searching for target value 35 in sorted array [5, 12, 18, 23, 35, 42, 56, 67].',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 7],
                explanation: 'Calculate middle: mid = (0 + 7) / 2 = 3. Compare target 35 with array[3] = 23. Target > 23, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [4, 7],
                previousIndices: [0, 3],
                explanation: 'Update search range: left = 4, right = 7. Eliminated left half of array.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [4, 7],
                explanation: 'Calculate middle: mid = (4 + 7) / 2 = 5. Compare target 35 with array[5] = 42. Target < 42, search left half.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [5, 7],
                explanation: 'Update search range: left = 4, right = 4. Compare target 35 with array[4] = 35. Found match!',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Target found at index 4. Binary search completed successfully in 3 comparisons.',
              ),
              VisualizationStep(
                highlightIndices: [0, 7],
                previousIndices: [],
                explanation: 'New search: Looking for target value 56. Reset: left = 0, right = 7.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 7],
                explanation: 'Calculate middle: mid = (0 + 7) / 2 = 3. Compare target 56 with array[3] = 23. Target > 23, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [4, 7],
                previousIndices: [0, 3],
                explanation: 'Update search range: left = 4, right = 7. Eliminated left half of array.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [4, 7],
                explanation: 'Calculate middle: mid = (4 + 7) / 2 = 5. Compare target 56 with array[5] = 42. Target > 42, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [6, 7],
                previousIndices: [4, 5],
                explanation: 'Update search range: left = 6, right = 7. Eliminated left portion of array.',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [6, 7],
                explanation: 'Calculate middle: mid = (6 + 7) / 2 = 6. Compare target 56 with array[6] = 56. Found match!',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Target found at index 6. Binary search completed in 4 comparisons.',
              ),
              VisualizationStep(
                highlightIndices: [0, 7],
                previousIndices: [],
                explanation: 'New search: Looking for target value 12. Reset: left = 0, right = 7.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 7],
                explanation: 'Calculate middle: mid = (0 + 7) / 2 = 3. Compare target 12 with array[3] = 23. Target < 23, search left half.',
              ),
              VisualizationStep(
                highlightIndices: [0, 2],
                previousIndices: [3, 7],
                explanation: 'Update search range: left = 0, right = 2. Eliminated right half of array.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0, 2],
                explanation: 'Calculate middle: mid = (0 + 2) / 2 = 1. Compare target 12 with array[1] = 12. Found match!',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Target found at index 1. Binary search completed in 3 comparisons.',
              ),
              VisualizationStep(
                highlightIndices: [0, 7],
                previousIndices: [],
                explanation: 'New search: Looking for target value 100 (not in array). Reset: left = 0, right = 7.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 7],
                explanation: 'Calculate middle: mid = (0 + 7) / 2 = 3. Compare target 100 with array[3] = 23. Target > 23, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [4, 7],
                previousIndices: [0, 3],
                explanation: 'Update search range: left = 4, right = 7.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [4, 7],
                explanation: 'Calculate middle: mid = (4 + 7) / 2 = 5. Compare target 100 with array[5] = 42. Target > 42, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [6, 7],
                previousIndices: [4, 5],
                explanation: 'Update search range: left = 6, right = 7.',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [7],
                explanation: 'Calculate middle: mid = (6 + 7) / 2 = 6. Compare target 100 with array[6] = 56. Target > 56, search right half.',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [6],
                explanation: 'Update search range: left = 7, right = 7. Only one element left.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [],
                explanation: 'Compare target 100 with array[7] = 67. Target > 67. Left > right, target not found. Return -1.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'trees',
        name: 'Trees',
        category: 'Data Structures & Algorithm',
        description: 'A tree is a hierarchical data structure consisting of nodes connected by edges. '
            'Each tree has a root node, and every node has zero or more child nodes. '
            'Trees are used for organizing data hierarchically, enabling efficient searching, insertion, and deletion operations.',
        steps: [
          'Start with the root node at the top level',
          'Each node can have multiple children (left, right, or more)',
          'Leaf nodes are nodes with no children',
          'Traverse the tree using different methods (in-order, pre-order, post-order)',
          'Perform operations like insertion, deletion, and searching'
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Depth-First Search (DFS)',
            description: 'Explore tree nodes by going as deep as possible before backtracking.',
            mockQuestion: 'You\'re exploring a maze and want to go as deep down one path as possible before trying another. Why fully explore one branch before moving to the next?',
            values: const [50, 30, 70, 20, 40, 60, 80],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start DFS at root (50). Visit and mark as explored.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Go deep: visit left child (30). Continue exploring depth-first.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [1, 0],
                explanation: 'Go deeper: visit left child (20). Keep going deep.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [1, 0],
                explanation: 'Node 20 has no left child. Backtrack and try right subtree.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [3, 1, 0],
                explanation: 'Visit right child of 30: node 40. Continue DFS.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [3, 1, 0],
                explanation: 'Node 40 has no children. Backtrack to explore right subtree of root.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [4, 3, 1, 0],
                explanation: 'Visit right child of root: node 70. Continue DFS.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [2, 4, 3, 1, 0],
                explanation: 'Visit left child of 70: node 60. Continue DFS.',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [5, 2, 4, 3, 1, 0],
                explanation: 'Visit right child of 70: node 80. DFS exploration complete!',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Breadth-First Search (BFS)',
            description: 'Explore tree level by level using a queue data structure.',
            mockQuestion: 'You want to find the shortest number of hops between two people in a friend network. Why check all of someone\'s direct friends before checking friends-of-friends?',
            values: const [50, 30, 70, 20, 40, 60, 80],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start BFS at root (50). Add root to queue: [50]',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Dequeue root (50). Add its children to queue: [30, 70]',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Dequeue 30. Add its children to queue: [70, 20, 40]',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1, 0],
                explanation: 'Dequeue 70. Add its children to queue: [20, 40, 60, 80]',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2, 1, 0],
                explanation: 'Dequeue 20. No children to add. Queue: [40, 60, 80]',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [3, 2, 1, 0],
                explanation: 'Dequeue 40. No children to add. Queue: [60, 80]',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [4, 3, 2, 1, 0],
                explanation: 'Dequeue 60. No children to add. Queue: [80]',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [5, 4, 3, 2, 1, 0],
                explanation: 'Dequeue 80. No children to add. Queue empty. BFS complete!',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Binary Tree Insertion',
            description: 'Insert a new node into a binary tree maintaining structure.',
            mockQuestion: 'You\'re filing a new folder into an already-sorted set of folders. Why compare it to the current folder and go left or right instead of checking every folder?',
            values: const [50, 30, 70, 20, 40, 60, 80],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start at root (50). We want to insert value 35.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Compare 35 < 50, go to left child (30).',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [1, 0],
                explanation: 'Compare 35 > 30, go to right child (40).',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [1, 0],
                explanation: 'Compare 35 < 40, try to go left but no left child exists. This empty spot is where 35 belongs.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [1, 0],
                explanation: 'Insert 35 as the new left child of node 40. Insertion complete!',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'sorting',
        name: 'Sorting',
        category: 'Data Structures & Algorithm',
        description: 'Bubble Sort repeatedly steps through the array, comparing each pair of neighboring '
            'elements and swapping them if they\'re in the wrong order. Each full pass "bubbles" the largest '
            'remaining value up to its correct position at the end.',
        steps: [
          'Compare each pair of neighboring elements, left to right',
          'Swap them if the left one is bigger than the right one',
          'After each full pass, the largest unsorted value ends up in its final position',
          'Repeat with one fewer element each pass, until a full pass makes no swaps',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Bubble Sort',
            description: 'Sort an array by repeatedly comparing and swapping adjacent out-of-order pairs.',
            mockQuestion: 'You have the numbers [5, 2, 8, 1, 4] and want them sorted smallest to largest. Why does comparing and swapping just neighboring pairs, repeated enough times, eventually sort the whole list?',
            values: const [5, 2, 8, 1, 4],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [],
                valuesOverride: [2, 5, 8, 1, 4],
                explanation: 'Compare index 0 (5) and index 1 (2). 5 > 2, so they\'re out of order — swap them.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [0, 1],
                valuesOverride: [2, 5, 8, 1, 4],
                explanation: 'Compare index 1 (5) and index 2 (8). 5 < 8, already in order — no swap needed.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3],
                previousIndices: [1, 2],
                valuesOverride: [2, 5, 1, 8, 4],
                explanation: 'Compare index 2 (8) and index 3 (1). 8 > 1, out of order — swap them.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4],
                previousIndices: [2, 3],
                valuesOverride: [2, 5, 1, 4, 8],
                explanation: 'Compare index 3 (8) and index 4 (4). 8 > 4, out of order — swap them. Pass 1 complete: the largest value (8) has bubbled up to its final position at index 4.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [3, 4],
                valuesOverride: [2, 5, 1, 4, 8],
                explanation: 'Pass 2. Compare index 0 (2) and index 1 (5). Already in order — no swap.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [0, 1],
                valuesOverride: [2, 1, 5, 4, 8],
                explanation: 'Compare index 1 (5) and index 2 (1). 5 > 1, out of order — swap them.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3],
                previousIndices: [1, 2],
                valuesOverride: [2, 1, 4, 5, 8],
                explanation: 'Compare index 2 (5) and index 3 (4). 5 > 4, out of order — swap them. Pass 2 complete: 5 is now settled at index 3.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [2, 3],
                valuesOverride: [1, 2, 4, 5, 8],
                explanation: 'Pass 3. Compare index 0 (2) and index 1 (1). 2 > 1, out of order — swap them.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [0, 1],
                valuesOverride: [1, 2, 4, 5, 8],
                explanation: 'Compare index 1 (2) and index 2 (4). Already in order — no swap. Pass 3 complete: 4 is now settled at index 2.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [1, 2],
                valuesOverride: [1, 2, 4, 5, 8],
                explanation: 'Pass 4. Compare index 0 (1) and index 1 (2). Already in order — no swap. No swaps happened this entire pass, which means the array is fully sorted: [1, 2, 4, 5, 8].',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Quick Sort',
            description: 'Sort an array by picking a pivot, partitioning everything smaller to its left and bigger to its right, then recursively sorting each side.',
            mockQuestion: 'You have the numbers [8, 3, 5, 1, 9, 2] and want them sorted. Quick Sort picks a pivot and partitions the array around it. Why does knowing "everything smaller is left of the pivot, everything bigger is right" let you sort each side independently afterward?',
            values: const [8, 3, 5, 1, 9, 2],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 5],
                previousIndices: [],
                valuesOverride: [8, 3, 5, 1, 9, 2],
                explanation: 'Pivot = index 5 (value 2). Compare index 0 (8) with the pivot — 8 > 2, leave it on the right side.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5],
                previousIndices: [0, 5],
                valuesOverride: [8, 3, 5, 1, 9, 2],
                explanation: 'Compare index 1 (3) with the pivot (2) — 3 > 2, leave it on the right side.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5],
                previousIndices: [1, 5],
                valuesOverride: [8, 3, 5, 1, 9, 2],
                explanation: 'Compare index 2 (5) with the pivot (2) — 5 > 2, leave it on the right side.',
              ),
              VisualizationStep(
                highlightIndices: [0, 3],
                previousIndices: [2, 5],
                valuesOverride: [1, 3, 5, 8, 9, 2],
                explanation: 'Compare index 3 (1) with the pivot (2) — 1 ≤ 2, so it belongs on the left. Swap it into the boundary position at index 0.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [0, 3],
                valuesOverride: [1, 3, 5, 8, 9, 2],
                explanation: 'Compare index 4 (9) with the pivot (2) — 9 > 2, leave it on the right side.',
              ),
              VisualizationStep(
                highlightIndices: [1, 5],
                previousIndices: [4, 5],
                valuesOverride: [1, 2, 5, 8, 9, 3],
                explanation: 'Every element checked. Place the pivot in its final position: swap index 1 and index 5. Pivot (2) now sits at index 1 — everything before it is smaller, everything after is bigger. First partition complete.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5],
                previousIndices: [1, 5],
                valuesOverride: [1, 2, 5, 8, 9, 3],
                explanation: 'Now partition the right side (indices 2-5). Pivot = index 5 (value 3). Compare index 2 (5) with the pivot — 5 > 3, leave it.',
              ),
              VisualizationStep(
                highlightIndices: [3, 5],
                previousIndices: [2, 5],
                valuesOverride: [1, 2, 5, 8, 9, 3],
                explanation: 'Compare index 3 (8) with the pivot (3) — 8 > 3, leave it.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [3, 5],
                valuesOverride: [1, 2, 5, 8, 9, 3],
                explanation: 'Compare index 4 (9) with the pivot (3) — 9 > 3, leave it.',
              ),
              VisualizationStep(
                highlightIndices: [2, 5],
                previousIndices: [4, 5],
                valuesOverride: [1, 2, 3, 8, 9, 5],
                explanation: 'No values were smaller than the pivot, so place it right at the start of this range: swap index 2 and index 5. Pivot (3) now sits at index 2.',
              ),
              VisualizationStep(
                highlightIndices: [3, 5],
                previousIndices: [2, 5],
                valuesOverride: [1, 2, 3, 8, 9, 5],
                explanation: 'Partition indices 3-5. Pivot = index 5 (value 5). Compare index 3 (8) with the pivot — 8 > 5, leave it.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [3, 5],
                valuesOverride: [1, 2, 3, 8, 9, 5],
                explanation: 'Compare index 4 (9) with the pivot (5) — 9 > 5, leave it.',
              ),
              VisualizationStep(
                highlightIndices: [3, 5],
                previousIndices: [4, 5],
                valuesOverride: [1, 2, 3, 5, 9, 8],
                explanation: 'No smaller values found, so place the pivot at the start of this range: swap index 3 and index 5. Pivot (5) now sits at index 3.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [3, 5],
                valuesOverride: [1, 2, 3, 5, 9, 8],
                explanation: 'Partition indices 4-5. Pivot = index 5 (value 8). Compare index 4 (9) with the pivot — 9 > 8, leave it.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [4, 5],
                valuesOverride: [1, 2, 3, 5, 8, 9],
                explanation: 'No smaller values found, so place the pivot at the start: swap index 4 and index 5. Pivot (8) now sits at index 4. Every element is in its final sorted position: [1, 2, 3, 5, 8, 9].',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'heap',
        name: 'Heap',
        category: 'Data Structures & Algorithm',
        description: 'A heap is a tree-shaped structure (usually stored as an array) where every parent is '
            'smaller than its children (min-heap) or larger than its children (max-heap). This guarantees the '
            'smallest (or largest) value is always at the root, making it ideal for priority queues.',
        steps: [
          'Store the tree as an array: a node at index i has children at 2i+1 and 2i+2',
          'To build a heap, sift each non-leaf node down: swap it with its smaller child if it violates the heap property',
          'Keep sifting the node down until it has no children left to compare, or the property holds',
          'The result is a valid heap, with the minimum (or maximum) always at index 0',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Build a Min-Heap',
            description: 'Turn an unsorted array into a valid min-heap by sifting each non-leaf node down.',
            mockQuestion: 'You have the unsorted numbers [5, 3, 8, 1, 9, 2] and want the smallest value always quickly accessible at the front. Why does checking each node against just its children — not the whole array — fix the ordering?',
            values: const [5, 3, 8, 1, 9, 2],
            steps: [
              VisualizationStep(
                highlightIndices: [2, 5],
                previousIndices: [],
                valuesOverride: [5, 3, 2, 1, 9, 8],
                explanation: 'Start from the last non-leaf node: index 2 (value 8). Its only child is index 5 (value 2). Since 2 < 8, swap them to satisfy the min-heap property.',
              ),
              VisualizationStep(
                highlightIndices: [1, 3, 4],
                previousIndices: [2, 5],
                valuesOverride: [5, 1, 2, 3, 9, 8],
                explanation: 'Move to index 1 (value 3). Its children are index 3 (value 1) and index 4 (value 9) — the smaller child is 1. Since 1 < 3, swap them.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [1, 3, 4],
                valuesOverride: [1, 5, 2, 3, 9, 8],
                explanation: 'Move to index 0 (value 5), the root. Its children are index 1 (value 1) and index 2 (value 2) — the smaller child is 1. Since 1 < 5, swap them. The value that moved down (5) might still be out of place below, so keep sifting.',
              ),
              VisualizationStep(
                highlightIndices: [1, 3, 4],
                previousIndices: [0, 1, 2],
                valuesOverride: [1, 3, 2, 5, 9, 8],
                explanation: 'Value 5 is now at index 1. Its children are index 3 (value 3) and index 4 (value 9) — the smaller child is 3. Since 3 < 5, swap them again.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [1, 3, 4],
                valuesOverride: [1, 3, 2, 5, 9, 8],
                explanation: 'Value 5 is now at index 3, a leaf with no children — sifting stops here. Heapify complete: [1, 3, 2, 5, 9, 8] is a valid min-heap, with the smallest value (1) at the root.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'greedy',
        name: 'Greedy',
        category: 'Data Structures & Algorithm',
        description: 'A greedy algorithm builds a solution piece by piece, always choosing the option that '
            'looks best right now, and never reconsidering that choice later. This is fast, but only gives the '
            'correct (globally optimal) answer for problems that have the "greedy choice property."',
        steps: [
          'Sort or order the choices by whatever criterion the problem needs (e.g. earliest finish time)',
          'Go through the choices in that order',
          'At each choice, take it if it doesn\'t conflict with what\'s already been chosen',
          'Never go back and reconsider — the locally best choice is assumed to be part of the best overall answer',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Activity Selection',
            description: 'Pick the maximum number of non-overlapping activities by always greedily choosing the one that finishes earliest.',
            mockQuestion: 'You want to schedule the most activities possible without any overlapping: A(1-3), B(2-5), C(4-7), D(6-9), E(8-10), F(9-11). Why does always picking whichever available activity finishes earliest guarantee the maximum count?',
            values: const [3, 5, 7, 9, 10, 11],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Consider Activity A (starts at 1, ends at 3). It has the earliest finish time, so always select it first. Selected so far: A.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Consider Activity B (starts at 2, ends at 5). It starts at 2, before A ends at 3 — they overlap, so skip B.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'Consider Activity C (starts at 4, ends at 7). It starts at 4, after A ends at 3 — no overlap, so select it. Selected so far: A, C.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2],
                explanation: 'Consider Activity D (starts at 6, ends at 9). It starts at 6, before C ends at 7 — overlap, so skip D.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [3],
                explanation: 'Consider Activity E (starts at 8, ends at 10). It starts at 8, after C ends at 7 — no overlap, so select it. Selected so far: A, C, E.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [4],
                explanation: 'Consider Activity F (starts at 9, ends at 11). It starts at 9, before E ends at 10 — overlap, so skip F. All activities checked: the greedy choices selected the maximum possible set — A, C, E (3 activities).',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'backtracking',
        name: 'Backtracking',
        category: 'Data Structures & Algorithm',
        description: 'Backtracking explores a decision tree of choices, one at a time. Whenever a full decision '
            'is reached, it\'s recorded; then the most recent choice is undone ("backtracked") so the alternative '
            'can be tried. This systematically covers every possible combination exactly once.',
        steps: [
          'At each item, try one choice (e.g. "include it") and recurse into the next item',
          'When every item has been decided, record the result',
          'Undo ("backtrack") the most recent choice and try the alternative instead',
          'Repeat until every combination of choices has been explored',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Generate All Subsets',
            description: 'List every possible subset of a small set by including or excluding each item, one at a time, and backtracking to try the alternative.',
            mockQuestion: 'You want to list every possible subset of {1, 2, 3} — from the empty set to the full set. Why does trying "include this item," then backtracking to try "exclude it instead," one item at a time, cover every possibility exactly once?',
            values: const [1, 2, 3],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [],
                explanation: 'Decide: include 1, include 2, include 3. Every item has been decided — record subset {1, 2, 3}.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [0, 1, 2],
                explanation: 'Backtrack: undo the last decision (including 3) and exclude it instead. Record subset {1, 2}.',
              ),
              VisualizationStep(
                highlightIndices: [0, 2],
                previousIndices: [0, 1],
                explanation: 'Backtrack further: undo including 2, exclude it instead — then include 3 again. Record subset {1, 3}.',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [0, 2],
                explanation: 'Backtrack: undo including 3, exclude it too. Record subset {1}.',
              ),
              VisualizationStep(
                highlightIndices: [1, 2],
                previousIndices: [0],
                explanation: 'Backtrack all the way to the first item: undo including 1, exclude it instead. Then include 2, include 3. Record subset {2, 3}.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [1, 2],
                explanation: 'Backtrack: undo including 3, exclude it instead. Record subset {2}.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'Backtrack: undo including 2, exclude it. Then include 3. Record subset {3}.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [2],
                explanation: 'Backtrack: undo including 3, exclude it too. Every item is now excluded — record the empty subset {}. All 2³ = 8 subsets have been found, each exactly once.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'graph',
        name: 'Graph',
        category: 'Data Structures & Algorithm',
        description: 'A graph is a set of nodes connected by edges — more general than a tree, since any node '
            'can connect to any number of others and cycles are allowed. Breadth-First Search (BFS) explores a '
            'graph level by level using a queue, which guarantees finding the shortest path in an unweighted graph.',
        steps: [
          'Add the starting node to a queue and mark it visited',
          'Dequeue a node and process it',
          'Add each of its unvisited neighbors to the queue, marking them visited',
          'Repeat until the queue is empty — every reachable node has been visited, in order of distance',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Breadth-First Search (BFS)',
            description: 'Visit every node reachable from a starting node, level by level, using a queue.',
            mockQuestion: 'Six friends are connected: 0 knows 1 and 3; 1 knows 0, 2, 4; 2 knows 1, 5; 3 knows 0, 4; 4 knows 1, 3, 5; 5 knows 2, 4. Starting from friend 0, why does visiting all direct friends before any friends-of-friends guarantee you find everyone using the fewest "hops"?',
            values: const [1, 2, 3, 4, 5, 6],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start BFS at node 0. Add its neighbors — node 1 and node 3 — to the queue. Queue: [1, 3].',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Dequeue node 1. Its neighbors are 0 (already visited), 2, and 4 — add 2 and 4 to the queue. Queue: [3, 2, 4].',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1],
                explanation: 'Dequeue node 3. Its neighbors are 0 (visited) and 4 (already queued) — nothing new to add. Queue: [2, 4].',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1, 3],
                explanation: 'Dequeue node 2. Its neighbors are 1 (visited) and 5 — add 5 to the queue. Queue: [4, 5].',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 3, 2],
                explanation: 'Dequeue node 4. Its neighbors are 1, 3, and 5 — all already visited or queued. Queue: [5].',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 3, 2, 4],
                explanation: 'Dequeue node 5. Its neighbors are 2 and 4 — both already visited. Queue is empty. BFS complete — every node reachable from node 0 has been visited, in order: 0, 1, 3, 2, 4, 5.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Depth-First Search (DFS)',
            description: 'Explore a graph by going as deep as possible along each branch before backtracking.',
            mockQuestion: 'Explore the same 6-person network starting from person 0, but this time go as deep as possible down one relationship before backtracking to try another. Why does this reach everyone, just in a very different order than BFS?',
            values: const [1, 2, 3, 4, 5, 6],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start DFS at node 0. Go as deep as possible: visit its first unvisited neighbor, node 1.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Visit node 1 (neighbor of 0). Keep going deeper into its first unvisited neighbor, node 2.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                explanation: 'Visit node 2 (neighbor of 1; node 0 already visited). Keep going deeper: node 5.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 2],
                explanation: 'Visit node 5 (neighbor of 2; node 1 already visited). Keep going deeper: node 4.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 2, 5],
                explanation: 'Visit node 4 (neighbor of 5; node 2 already visited). Keep going deeper: node 3.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1, 2, 5, 4],
                explanation: 'Visit node 3 (neighbor of 4; nodes 1 and 5 already visited). Node 3\'s only other neighbor (0) is visited too — dead end, backtrack. Every node has now been visited: 0, 1, 2, 5, 4, 3.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Topological Sort',
            description: 'Order the nodes of a directed graph so every edge points forward — used for scheduling tasks with prerequisites.',
            mockQuestion: 'You have 6 courses with prerequisites: 0 must come before 1 and 3; 1 must come before 2 and 4; 3 must come before 4; 4 must come before 5; 2 must come before 5. In what order can you take them all? Why must a course with unfinished prerequisites always wait?',
            values: const [1, 2, 3, 4, 5, 6],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Node 0 has no prerequisites (in-degree 0) — process it first. This clears one prerequisite each for nodes 1 and 3.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Node 1\'s only prerequisite (0) is done — process it. This clears one prerequisite each for nodes 2 and 4.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1],
                explanation: 'Node 3\'s only prerequisite (0) is done — process it. This clears node 4\'s other prerequisite.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1, 3],
                explanation: 'Node 2\'s only prerequisite (1) is done — process it. This clears one of node 5\'s two prerequisites.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [0, 1, 3, 2],
                explanation: 'Node 4\'s prerequisites (1 and 3) are both done — process it. This clears node 5\'s other prerequisite.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [0, 1, 3, 2, 4],
                explanation: 'Node 5\'s prerequisites (2 and 4) are both done — process it. Valid order found: 0, 1, 3, 2, 4, 5.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'hashing',
        name: 'Hashing',
        category: 'Data Structures & Algorithm',
        description: 'A hash map (or hash set) gives near-instant O(1) average lookup, insert, and existence '
            'checks. This turns many problems that would otherwise need a nested loop — checking every pair, '
            'or scanning the whole collection for each element — into a single pass.',
        steps: [
          'Walk through the data once, left to right',
          'For each element, check the hash map/set for what you need (e.g. a complement, or "have I seen this before")',
          'If it\'s not there, record the current element in the map/set and keep going',
          'If it is there, you\'ve found your answer — no nested loop required',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Two Sum (Hash Map)',
            description: 'Find two numbers that add up to a target in a single pass, using a hash map to remember what you\'ve seen.',
            mockQuestion: 'Given [2, 11, 15, 3, 6, 7], find two numbers that add up to 9. Why can a hash map find the answer in one pass instead of checking every pair?',
            values: const [2, 11, 15, 3, 6, 7],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Look at index 0 (value 2). We need 9 − 2 = 7. The map is empty, so 7 isn\'t there. Add 2 → index 0 to the map.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Look at index 1 (value 11). We need 9 − 11 = −2. Not in the map. Add 11 → index 1.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                explanation: 'Look at index 2 (value 15). We need 9 − 15 = −6. Not in the map. Add 15 → index 2.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1, 2],
                explanation: 'Look at index 3 (value 3). We need 9 − 3 = 6. Not in the map yet. Add 3 → index 3.',
              ),
              VisualizationStep(
                highlightIndices: [3, 4],
                previousIndices: [0, 1, 2, 3],
                explanation: 'Look at index 4 (value 6). We need 9 − 6 = 3. The map already has 3 → index 3! Found the pair: index 3 (3) and index 4 (6) sum to 9 — in one pass, no nested loop.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Detect Duplicates (Hash Set)',
            description: 'Check whether any value repeats in a single pass, using a hash set to remember what you\'ve seen.',
            mockQuestion: 'Given [4, 7, 2, 9, 7, 1], determine if any value appears more than once. Why can a hash set answer this in one pass instead of comparing every pair?',
            values: const [4, 7, 2, 9, 7, 1],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Look at index 0 (value 4). Not in the set yet. Add it.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Look at index 1 (value 7). Not in the set yet. Add it.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                explanation: 'Look at index 2 (value 2). Not in the set yet. Add it.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [0, 1, 2],
                explanation: 'Look at index 3 (value 9). Not in the set yet. Add it.',
              ),
              VisualizationStep(
                highlightIndices: [1, 4],
                previousIndices: [0, 1, 2, 3],
                explanation: 'Look at index 4 (value 7). 7 is already in the set (seen at index 1)! Duplicate found — stop here, no need to scan the rest.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'dynamic_programming',
        name: 'Dynamic Programming',
        category: 'Data Structures & Algorithm',
        description: 'Dynamic programming solves a problem by breaking it into overlapping subproblems, '
            'solving each subproblem only once, and storing ("memoizing") the answer for reuse. This avoids '
            'the exponential blowup of recomputing the same subproblem again and again.',
        steps: [
          'Define what dp[i] means (the answer to the subproblem at position i)',
          'Find the base case(s) — the smallest subproblems you can answer directly',
          'Find the recurrence: how dp[i] is built from smaller, already-solved subproblems',
          'Fill the table in order, reusing previous answers instead of recomputing them',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Climbing Stairs (1D DP)',
            description: 'Count the number of distinct ways to climb n stairs, taking 1 or 2 steps at a time, by building up from smaller cases.',
            mockQuestion: 'You\'re climbing a staircase with 7 steps, and can climb 1 or 2 steps at a time. How many distinct ways can you reach the top? Why does storing the answer for each smaller step count save you from recomputing the same subproblem over and over?',
            values: const [0, 0, 0, 0, 0, 0, 0, 0],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                valuesOverride: [1, 0, 0, 0, 0, 0, 0, 0],
                explanation: 'Base case: dp[0] = 1 — there\'s exactly one way to stand at the ground (do nothing).',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                valuesOverride: [1, 1, 0, 0, 0, 0, 0, 0],
                explanation: 'Base case: dp[1] = 1 — only one way to reach step 1 (a single 1-step climb).',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                valuesOverride: [1, 1, 2, 0, 0, 0, 0, 0],
                explanation: 'dp[2] = dp[1] + dp[0] = 1 + 1 = 2. Your last move to reach step 2 was either a 1-step from step 1, or a 2-step from step 0.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [1, 2],
                valuesOverride: [1, 1, 2, 3, 0, 0, 0, 0],
                explanation: 'dp[3] = dp[2] + dp[1] = 2 + 1 = 3.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [2, 3],
                valuesOverride: [1, 1, 2, 3, 5, 0, 0, 0],
                explanation: 'dp[4] = dp[3] + dp[2] = 3 + 2 = 5.',
              ),
              VisualizationStep(
                highlightIndices: [5],
                previousIndices: [3, 4],
                valuesOverride: [1, 1, 2, 3, 5, 8, 0, 0],
                explanation: 'dp[5] = dp[4] + dp[3] = 5 + 3 = 8.',
              ),
              VisualizationStep(
                highlightIndices: [6],
                previousIndices: [4, 5],
                valuesOverride: [1, 1, 2, 3, 5, 8, 13, 0],
                explanation: 'dp[6] = dp[5] + dp[4] = 8 + 5 = 13.',
              ),
              VisualizationStep(
                highlightIndices: [7],
                previousIndices: [5, 6],
                valuesOverride: [1, 1, 2, 3, 5, 8, 13, 21],
                explanation: 'dp[7] = dp[6] + dp[5] = 13 + 8 = 21. There are 21 distinct ways to climb 7 stairs — computed by reusing smaller answers instead of recomputing them from scratch.',
              ),
            ],
          ),
          AlgorithmVisualization(
            type: 'simulation',
            title: 'House Robber (1D DP)',
            description: 'Maximize the total money robbed from a row of houses, without ever robbing two adjacent houses.',
            mockQuestion: 'You\'re a robber casing a street of 5 houses holding [2, 7, 9, 3, 1] in cash. You can\'t rob two adjacent houses (the alarm links them). What\'s the most you can steal? Why does each house only need to look back at the previous two answers?',
            values: const [2, 0, 0, 0, 0],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                valuesOverride: [2, 0, 0, 0, 0],
                explanation: 'Base case: dp[0] = 2. With only house 0 (worth 2) available, the best you can do is rob it.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                valuesOverride: [2, 7, 0, 0, 0],
                explanation: 'dp[1] = max(house 0, house 1) = max(2, 7) = 7. With houses 0-1 available, robbing just house 1 beats robbing just house 0.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [0, 1],
                valuesOverride: [2, 7, 11, 0, 0],
                explanation: 'dp[2] = max(dp[1], dp[0] + house 2) = max(7, 2 + 9) = 11. Either skip house 2 (keep dp[1]=7), or rob it plus whatever was best two houses back (dp[0]=2).',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [1, 2],
                valuesOverride: [2, 7, 11, 11, 0],
                explanation: 'dp[3] = max(dp[2], dp[1] + house 3) = max(11, 7 + 3) = 11. Robbing house 3 wouldn\'t beat skipping it.',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [2, 3],
                valuesOverride: [2, 7, 11, 11, 12],
                explanation: 'dp[4] = max(dp[3], dp[2] + house 4) = max(11, 11 + 1) = 12. Best total: rob houses 0, 2, and 4 for 2 + 9 + 1 = 12.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'union_find',
        name: 'Union-Find',
        category: 'Data Structures & Algorithm',
        description: 'Union-Find (Disjoint Set) tracks a collection of items grouped into non-overlapping sets, '
            'answering "are these two connected?" and "merge these two groups" in nearly constant time each — '
            'ideal for detecting cycles and building connectivity incrementally.',
        steps: [
          'Start with every item as its own group: parent[i] = i',
          'find(x): follow parent pointers until you reach a node that is its own parent — that\'s the group\'s root',
          'union(a, b): find the root of each; if they differ, merge by pointing one root at the other',
          'If find(a) already equals find(b), they\'re already connected — union would create a cycle',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Union-Find (Disjoint Set)',
            description: 'Process a list of connections, merging groups and detecting when a connection would create a cycle.',
            mockQuestion: 'You\'re given connections (0,1), (2,3), (0,2), (4,5), (1,3) to add one at a time, and want to know which ones create a redundant cycle. Why does checking "do these two already share a root?" answer that instantly?',
            values: const [0, 1, 2, 3, 4, 5],
            steps: [
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [],
                explanation: 'union(0, 1): root of 0 is 0, root of 1 is 1 — different groups. Merge them: parent[0] = 1.',
              ),
              VisualizationStep(
                highlightIndices: [2, 3],
                previousIndices: [0, 1],
                explanation: 'union(2, 3): root of 2 is 2, root of 3 is 3 — different groups. Merge them: parent[2] = 3.',
              ),
              VisualizationStep(
                highlightIndices: [0, 2],
                previousIndices: [2, 3],
                explanation: 'union(0, 2): root of 0 is 1 (via parent[0]=1), root of 2 is 3 (via parent[2]=3) — still different groups. Merge them: parent[1] = 3.',
              ),
              VisualizationStep(
                highlightIndices: [4, 5],
                previousIndices: [0, 2],
                explanation: 'union(4, 5): root of 4 is 4, root of 5 is 5 — different groups. Merge them: parent[4] = 5.',
              ),
              VisualizationStep(
                highlightIndices: [1, 3],
                previousIndices: [4, 5],
                explanation: 'union(1, 3): root of 1 is 3, root of 3 is 3 — they already share the same root! Adding this connection would just create a cycle, so skip it. Final groups: {0, 1, 2, 3} and {4, 5}.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'intervals',
        name: 'Intervals',
        category: 'Data Structures & Algorithm',
        description: 'Interval problems deal with ranges like [start, end]. Sorting the intervals by start time '
            'first turns most interval problems — merging overlaps, inserting a new range, finding free time — '
            'into a single left-to-right pass.',
        steps: [
          'Sort the intervals by start time',
          'Keep a "current merged interval," beginning with the first one',
          'For each next interval, check if its start is within the current merged interval\'s end',
          'If it overlaps, extend the merge; if not, close it off and start a new one',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Merge Intervals',
            description: 'Merge all overlapping intervals in a sorted list into the minimum number of non-overlapping ranges.',
            mockQuestion: 'Given intervals [1,3], [2,6], [8,10], [15,18] sorted by start time, merge all overlapping ones. Why does sorting by start time first make a single left-to-right pass enough?',
            values: const [1, 2, 8, 15],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Start with the first interval [1, 3]. This becomes our first merged interval.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'Next interval [2, 6]. Its start (2) is ≤ the end of our last merged interval (3) — they overlap. Merge them into [1, 6].',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'Next interval [8, 10]. Its start (8) is greater than the end of our last merged interval (6) — no overlap. Start a new merged interval: [8, 10].',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2],
                explanation: 'Next interval [15, 18]. Its start (15) is greater than the end of our last merged interval (10) — no overlap. Start a new merged interval: [15, 18]. Final result: [1, 6], [8, 10], [15, 18].',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'trie',
        name: 'Trie',
        category: 'Data Structures & Algorithm',
        description: 'A trie (prefix tree) stores words letter by letter along shared paths, so words with a '
            'common prefix share the same nodes. This makes inserting, searching, and prefix-matching take time '
            'proportional to the word\'s length — not the number of words stored.',
        steps: [
          'To insert a word, walk it letter by letter, creating a child node for each letter that doesn\'t exist yet',
          'Mark the final letter\'s node as "end of word"',
          'To search, walk the word letter by letter, following existing child nodes',
          'If a needed letter\'s node doesn\'t exist, the word isn\'t in the trie — stop immediately',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Insert and Search a Word',
            description: 'Insert "CAT" into a trie letter by letter, then search for "CAT" and "CAB" to see a hit and a miss.',
            mockQuestion: 'You\'re building autocomplete and insert the word "CAT" into a trie (block 1 → letter C, block 2 → A, block 3 → T). Why can searching for "CAT" — or realizing "CAB" isn\'t stored — take exactly as many steps as the word\'s length, not the number of words stored?',
            values: const [1, 2, 3],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Insert "CAT": create a node for \'C\' (depth 0).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [0],
                explanation: 'Create a node for \'A\' as a child of \'C\' (depth 1).',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [0, 1],
                explanation: 'Create a node for \'T\' as a child of \'A\' (depth 2) and mark it end-of-word. "CAT" is now stored.',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Search "CAT": follow \'C\' from the root — it exists.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [0],
                explanation: 'Follow \'A\' from \'C\' — it exists.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1, 2],
                previousIndices: [0, 1],
                explanation: 'Follow \'T\' from \'A\' — it exists and is marked end-of-word. "CAT" found in exactly 3 steps, the length of the word.',
              ),
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'Search "CAB": follow \'C\' from the root — it exists.',
              ),
              VisualizationStep(
                highlightIndices: [0, 1],
                previousIndices: [0],
                explanation: 'Follow \'A\' from \'C\' — it exists.',
              ),
              VisualizationStep(
                highlightIndices: [],
                previousIndices: [0, 1],
                explanation: 'Follow \'B\' from \'A\' — no such child exists. Search fails: "CAB" is not in the trie, even though "CA" is a valid prefix of something stored.',
              ),
            ],
          ),
        ],
      ),
      Algorithm(
        id: 'bit_manipulation',
        name: 'Bit Manipulation',
        category: 'Data Structures & Algorithm',
        description: 'Bitwise operations (AND, OR, XOR, shifts) work directly on a number\'s binary '
            'representation. XOR in particular has a useful property: a number XORed with itself is 0, and '
            'XOR is commutative and associative — order doesn\'t matter, which makes it perfect for pairing things off.',
        steps: [
          'Start a running result at 0',
          'XOR the running result with each element, one at a time',
          'Every value that appears in a pair cancels itself out (x XOR x = 0)',
          'Whatever is left at the end is the one value that didn\'t have a pair',
        ],
        visualizations: [
          AlgorithmVisualization(
            type: 'simulation',
            title: 'Find the Single Number (XOR)',
            description: 'Find the one number that appears once while every other number appears exactly twice, using O(1) space and one pass.',
            mockQuestion: 'Given [4, 1, 2, 1, 2], every number appears twice except one. Find it in O(1) extra space and a single pass. Why does XOR-ing every element together leave only the unique number?',
            values: const [4, 1, 2, 1, 2],
            steps: [
              VisualizationStep(
                highlightIndices: [0],
                previousIndices: [],
                explanation: 'result = 0 XOR 4 = 4.',
              ),
              VisualizationStep(
                highlightIndices: [1],
                previousIndices: [0],
                explanation: 'result = 4 XOR 1 = 5.',
              ),
              VisualizationStep(
                highlightIndices: [2],
                previousIndices: [1],
                explanation: 'result = 5 XOR 2 = 7.',
              ),
              VisualizationStep(
                highlightIndices: [3],
                previousIndices: [2],
                explanation: 'result = 7 XOR 1 = 6. Notice XOR-ing 1 a second time undid its earlier effect (1 XOR 1 = 0).',
              ),
              VisualizationStep(
                highlightIndices: [4],
                previousIndices: [3],
                explanation: 'result = 6 XOR 2 = 4. The second 2 also canceled itself out. Every paired value has now canceled to 0, leaving only 4 — the single number, found in one pass with no extra memory.',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}