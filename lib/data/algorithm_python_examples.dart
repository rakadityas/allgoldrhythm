import '../models/algorithm.dart';

class AlgorithmPythonExamples {
  static Map<String, String> getTwoPointersExamples() {
    return {
      'Left-Right Two Pointers': '''
# Two Sum (Left-Right Two Pointers)
# Find two numbers in a sorted array that add up to a target
def two_sum(nums, target):
    left, right = 0, len(nums) - 1
    
    while left < right:
        current_sum = nums[left] + nums[right]
        
        if current_sum == target:
            return [left, right]  # Return indices of the two numbers
        elif current_sum < target:
            left += 1  # Move left pointer to increase sum
        else:
            right -= 1  # Move right pointer to decrease sum
    
    return []  # No solution found

# Example usage
nums = [1, 3, 4, 5, 7, 11]
target = 9
print(two_sum(nums, target))  # Output: [1, 4] (3 + 7 = 9)
''',

      'Fast-Slow Two Pointers': '''
# Detect Cycle in Linked List (Fast-Slow Two Pointers)
# Floyd's Cycle-Finding Algorithm
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def has_cycle(head):
    if not head or not head.next:
        return False
    
    # Initialize slow and fast pointers
    slow = head
    fast = head
    
    # Move slow by 1 step and fast by 2 steps
    while fast and fast.next:
        slow = slow.next       # Move slow pointer by 1
        fast = fast.next.next  # Move fast pointer by 2
        
        # If there's a cycle, the pointers will meet
        if slow == fast:
            return True
    
    # If fast reaches the end, there's no cycle
    return False

# Example usage
# Create a linked list with a cycle: 1->2->3->4->2 (cycles back to 2)
node1 = ListNode(1)
node2 = ListNode(2)
node3 = ListNode(3)
node4 = ListNode(4)
node1.next = node2
node2.next = node3
node3.next = node4
node4.next = node2  # Creates a cycle

print(has_cycle(node1))  # Output: True
''',

      'Same Direction Two Pointers': '''
# Remove Duplicates from Sorted Array (Same Direction Two Pointers)
def remove_duplicates(nums):
    if not nums:
        return 0
    
    # Initialize the pointer for the position to place the next unique element
    unique_pos = 1
    
    # Iterate through the array starting from the second element
    for i in range(1, len(nums)):
        # If the current element is different from the previous one
        if nums[i] != nums[i-1]:
            # Place it at the position marked by unique_pos
            nums[unique_pos] = nums[i]
            unique_pos += 1
    
    return unique_pos  # Return the length of the array with duplicates removed

# Example usage
nums = [1, 1, 2, 2, 3, 4, 4, 5]
k = remove_duplicates(nums)
print(nums[:k])  # Output: [1, 2, 3, 4, 5]
''',

      'Three Pointers': '''
# 3Sum (Three Pointers)
# Find all unique triplets in the array that give the sum of zero
def three_sum(nums):
    result = []
    nums.sort()  # Sort the array first
    
    for i in range(len(nums) - 2):
        # Skip duplicate values for i
        if i > 0 and nums[i] == nums[i-1]:
            continue
        
        # Use two pointers technique for the remaining array
        left = i + 1
        right = len(nums) - 1
        
        while left < right:
            total = nums[i] + nums[left] + nums[right]
            
            if total < 0:
                left += 1
            elif total > 0:
                right -= 1
            else:  # total == 0, we found a triplet
                result.append([nums[i], nums[left], nums[right]])
                
                # Skip duplicates
                while left < right and nums[left] == nums[left+1]:
                    left += 1
                while left < right and nums[right] == nums[right-1]:
                    right -= 1
                
                # Move both pointers
                left += 1
                right -= 1
    
    return result

# Example usage
nums = [-1, 0, 1, 2, -1, -4]
print(three_sum(nums))  # Output: [[-1, -1, 2], [-1, 0, 1]]
''',

      'Partition Array': '''
# Dutch National Flag Problem (Partition Array)
# Sort an array of 0s, 1s, and 2s
def sort_colors(nums):
    # Initialize three pointers
    low = 0        # for 0s
    mid = 0        # current element
    high = len(nums) - 1  # for 2s
    
    while mid <= high:
        if nums[mid] == 0:
            # Swap with the low pointer and move both pointers
            nums[low], nums[mid] = nums[mid], nums[low]
            low += 1
            mid += 1
        elif nums[mid] == 1:
            # Just move the middle pointer
            mid += 1
        else:  # nums[mid] == 2
            # Swap with the high pointer and move only high pointer
            nums[mid], nums[high] = nums[high], nums[mid]
            high -= 1
    
    return nums

# Example usage
nums = [2, 0, 1, 1, 0, 2, 1, 0]
print(sort_colors(nums))  # Output: [0, 0, 0, 1, 1, 1, 2, 2]
''',
    };
  }

  static Map<String, String> getSlidingWindowExamples() {
    return {
      'Fixed Size Window': '''
# Maximum Sum Subarray of Size K (Fixed Size Window)
def max_sum_subarray(arr, k):
    n = len(arr)
    if n < k:
        return -1
    
    # Compute sum of first window of size k
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    # Slide the window from left to right
    for i in range(n - k):
        # Remove the leftmost element and add the rightmost element
        window_sum = window_sum - arr[i] + arr[i + k]
        max_sum = max(max_sum, window_sum)
    
    return max_sum

# Example usage
arr = [1, 4, 2, 10, 2, 3, 1, 0, 20]
k = 3
print(max_sum_subarray(arr, k))  # Output: 15 (sum of subarray [10, 2, 3])
''',

      'Variable Size Window': '''
# Smallest Subarray with Sum >= Target (Variable Size Window)
def smallest_subarray_with_sum(arr, target):
    n = len(arr)
    window_sum = 0
    min_length = float('inf')
    window_start = 0
    
    for window_end in range(n):
        # Add the next element to the window
        window_sum += arr[window_end]
        
        # Shrink the window as small as possible while maintaining the sum >= target
        while window_sum >= target:
            # Update the minimum length
            min_length = min(min_length, window_end - window_start + 1)
            
            # Remove the leftmost element
            window_sum -= arr[window_start]
            window_start += 1
    
    return min_length if min_length != float('inf') else 0

# Example usage
arr = [2, 1, 5, 2, 3, 2]
target = 7
print(smallest_subarray_with_sum(arr, target))  # Output: 2 (subarray [5, 2])
''',

      'Sliding Window with Distinct Elements': '''
# Longest Substring Without Repeating Characters
def length_of_longest_substring(s):
    char_index_map = {}  # Map to store the current index of a character
    max_length = 0
    window_start = 0
    
    for window_end in range(len(s)):
        # If the character is already in the window, update window_start
        if s[window_end] in char_index_map:
            # Move window_start to the right of the last occurrence of the character
            window_start = max(window_start, char_index_map[s[window_end]] + 1)
        
        # Update the index of the current character
        char_index_map[s[window_end]] = window_end
        
        # Update the maximum length
        max_length = max(max_length, window_end - window_start + 1)
    
    return max_length

# Example usage
s = "abcabcbb"
print(length_of_longest_substring(s))  # Output: 3 (substring "abc")
''',

      'Sliding Window with Count': '''
# Find All Anagrams in a String
def find_anagrams(s, p):
    if len(s) < len(p):
        return []
    
    p_count = {}  # Frequency counter for pattern
    s_count = {}  # Frequency counter for current window
    
    # Initialize frequency counters
    for char in p:
        p_count[char] = p_count.get(char, 0) + 1
    
    result = []
    window_start = 0
    
    for window_end in range(len(s)):
        # Add the current character to s_count
        s_count[s[window_end]] = s_count.get(s[window_end], 0) + 1
        
        # If the window size is equal to pattern length
        if window_end >= len(p) - 1:
            # Check if the current window is an anagram
            if s_count == p_count:
                result.append(window_start)
            
            # Remove the leftmost character from the window
            s_count[s[window_start]] -= 1
            if s_count[s[window_start]] == 0:
                del s_count[s[window_start]]
            
            window_start += 1
    
    return result

# Example usage
s = "cbaebabacd"
p = "abc"
print(find_anagrams(s, p))  # Output: [0, 6] (anagrams start at indices 0 and 6)
''',

      'Sliding Window with Two Pointers': '''
# Longest Substring with At Most K Distinct Characters
def longest_substring_with_k_distinct(s, k):
    if not s or k == 0:
        return 0
    
    char_frequency = {}
    max_length = 0
    window_start = 0
    
    for window_end in range(len(s)):
        # Add the current character to the frequency map
        right_char = s[window_end]
        char_frequency[right_char] = char_frequency.get(right_char, 0) + 1
        
        # Shrink the window if we have more than k distinct characters
        while len(char_frequency) > k:
            left_char = s[window_start]
            char_frequency[left_char] -= 1
            if char_frequency[left_char] == 0:
                del char_frequency[left_char]
            window_start += 1
        
        # Update the maximum length
        max_length = max(max_length, window_end - window_start + 1)
    
    return max_length

# Example usage
s = "eceba"
k = 2
print(longest_substring_with_k_distinct(s, k))  # Output: 3 (substring "ece")
''',
    };
  }

  static Map<String, String> getStackExamples() {
    return {
      'Basic Stack Operations': '''
# Stack Implementation using List
# Demonstrates push, pop, peek, and isEmpty operations
class Stack:
    def __init__(self):
        self.items = []
    
    def push(self, item):
        """Add an item to the top of the stack"""
        self.items.append(item)
        print(f"Pushed {item} onto stack")
    
    def pop(self):
        """Remove and return the top item from the stack"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        item = self.items.pop()
        print(f"Popped {item} from stack")
        return item
    
    def peek(self):
        """Return the top item without removing it"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self.items[-1]
    
    def is_empty(self):
        """Check if the stack is empty"""
        return len(self.items) == 0
    
    def size(self):
        """Return the number of items in the stack"""
        return len(self.items)

# Example usage
stack = Stack()

# Push elements
for i in [10, 20, 30, 40, 50]:
    stack.push(i)

print(f"Top element: {stack.peek()}")
print(f"Stack size: {stack.size()}")

# Pop elements
while not stack.is_empty():
    stack.pop()
''',

      'Balanced Parentheses': '''
# Check if parentheses are balanced using stack
# This is a classic stack application problem
def is_balanced(expression):
    """Check if parentheses in expression are balanced"""
    stack = []
    opening = "({["
    closing = ")}]"
    pairs = {")": "(", "}": "{", "]": "["}
    
    for char in expression:
        if char in opening:
            stack.append(char)
        elif char in closing:
            if not stack or stack[-1] != pairs[char]:
                return False
            stack.pop()
    
    return len(stack) == 0

# Example usage
expressions = [
    "()",           # True
    "()[]{}",       # True
    "(])",          # False
    "([{}])",       # True
    "(((",          # False
]

for expr in expressions:
    result = is_balanced(expr)
    print(f"'{expr}' is balanced: {result}")
''',
    };
  }

  static Map<String, String> getLinkedListExamples() {
    return {
      'Basic Linked List Operations': '''
# Singly Linked List Implementation
# Demonstrates node creation, insertion, deletion, and traversal
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, val):
        """Add a new node at the end of the list"""
        new_node = ListNode(val)
        if not self.head:
            self.head = new_node
            return
        
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
    
    def prepend(self, val):
        """Add a new node at the beginning of the list"""
        new_node = ListNode(val)
        new_node.next = self.head
        self.head = new_node
    
    def delete(self, val):
        """Delete the first occurrence of val"""
        if not self.head:
            return
        
        if self.head.val == val:
            self.head = self.head.next
            return
        
        current = self.head
        while current.next and current.next.val != val:
            current = current.next
        
        if current.next:
            current.next = current.next.next
    
    def display(self):
        """Print all elements in the list"""
        elements = []
        current = self.head
        while current:
            elements.append(str(current.val))
            current = current.next
        return " -> ".join(elements) + " -> None"
    
    def find(self, val):
        """Search for a value in the list"""
        current = self.head
        position = 0
        while current:
            if current.val == val:
                return position
            current = current.next
            position += 1
        return -1

# Example usage
ll = LinkedList()

# Add elements
for i in [10, 20, 30, 40, 50]:
    ll.append(i)

print(f"List: {ll.display()}")
print(f"Position of 30: {ll.find(30)}")

# Delete an element
ll.delete(30)
print(f"After deleting 30: {ll.display()}")

# Add at beginning
ll.prepend(5)
print(f"After prepending 5: {ll.display()}")
''',

      'Reverse Linked List': '''
# Reverse a singly linked list
# This is a fundamental linked list operation
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def reverse_linked_list(head):
    """Reverse a linked list iteratively"""
    prev = None
    current = head
    
    while current:
        next_temp = current.next  # Store next node
        current.next = prev       # Reverse the link
        prev = current           # Move prev forward
        current = next_temp      # Move current forward
    
    return prev  # prev is now the new head

def print_list(head):
    """Helper function to print the list"""
    elements = []
    current = head
    while current:
        elements.append(str(current.val))
        current = current.next
    return " -> ".join(elements) + " -> None"

# Create a sample linked list: 1 -> 2 -> 3 -> 4 -> 5
head = ListNode(1)
head.next = ListNode(2)
head.next.next = ListNode(3)
head.next.next.next = ListNode(4)
head.next.next.next.next = ListNode(5)

print(f"Original list: {print_list(head)}")

# Reverse the list
reversed_head = reverse_linked_list(head)
print(f"Reversed list: {print_list(reversed_head)}")
''',
    };
  }

  static Map<String, String> getBinarySearchExamples() {
    return {
      'Basic Binary Search': '''
# Binary Search Implementation
# Efficiently finds target value in sorted array
def binary_search(arr, target):
    """Binary search algorithm - iterative approach"""
    left, right = 0, len(arr) - 1
    
    while left <= right:
        mid = (left + right) // 2
        
        if arr[mid] == target:
            return mid  # Target found, return index
        elif arr[mid] < target:
            left = mid + 1  # Search right half
        else:
            right = mid - 1  # Search left half
    
    return -1  # Target not found

# Example usage
sorted_array = [5, 12, 18, 23, 35, 42, 56, 67, 78, 89]
targets = [35, 67, 12, 100, 5]

for target in targets:
    result = binary_search(sorted_array, target)
    if result != -1:
        print(f"Target {target} found at index {result}")
    else:
        print(f"Target {target} not found in array")

# Output:
# Target 35 found at index 4
# Target 67 found at index 7
# Target 12 found at index 1
# Target 100 not found in array
# Target 5 found at index 0
''',

      'Binary Search with Bounds': '''
# Binary Search with Left and Right Bounds
# Find first and last occurrence of target
def binary_search_left_bound(arr, target):
    """Find the leftmost (first) occurrence of target"""
    left, right = 0, len(arr)
    
    while left < right:
        mid = (left + right) // 2
        if arr[mid] < target:
            left = mid + 1
        else:
            right = mid
    
    return left if left < len(arr) and arr[left] == target else -1

def binary_search_right_bound(arr, target):
    """Find the rightmost (last) occurrence of target"""
    left, right = 0, len(arr)
    
    while left < right:
        mid = (left + right) // 2
        if arr[mid] <= target:
            left = mid + 1
        else:
            right = mid
    
    return left - 1 if left > 0 and arr[left - 1] == target else -1

# Example with duplicates
array_with_duplicates = [1, 2, 2, 2, 3, 4, 4, 5, 5, 5]
target = 2

left_bound = binary_search_left_bound(array_with_duplicates, target)
right_bound = binary_search_right_bound(array_with_duplicates, target)

print(f"Array: {array_with_duplicates}")
print(f"Target {target}:")
print(f"First occurrence at index: {left_bound}")
print(f"Last occurrence at index: {right_bound}")
print(f"Total occurrences: {right_bound - left_bound + 1 if left_bound != -1 else 0}")
''',
    };
  }

  static Map<String, String> getQueueExamples() {
    return {
      'Queue Basic Operations': '''
# Queue Implementation using Python List
class Queue:
    def __init__(self):
        self.items = []
    
    def enqueue(self, item):
        """Add an element to the rear of the queue"""
        self.items.append(item)
        print(f"Enqueued: {item}")
    
    def dequeue(self):
        """Remove and return the front element"""
        if self.is_empty():
            return None
        item = self.items.pop(0)
        print(f"Dequeued: {item}")
        return item
    
    def peek(self):
        """Return the front element without removing it"""
        if self.is_empty():
            return None
        return self.items[0]
    
    def is_empty(self):
        """Check if the queue is empty"""
        return len(self.items) == 0
    
    def size(self):
        """Return the number of elements in the queue"""
        return len(self.items)
    
    def display(self):
        """Display the current queue"""
        print(f"Queue: {self.items}")

# Example usage
queue = Queue()

# Enqueue elements
for i in [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]:
    queue.enqueue(i)
    queue.display()

print(f"\\nFront element: {queue.peek()}")
print(f"Queue size: {queue.size()}")

# Dequeue some elements
for _ in range(3):
    queue.dequeue()
    queue.display()

print(f"\\nFinal front element: {queue.peek()}")
print(f"Final queue size: {queue.size()}")
''',

      'Efficient Queue using Deque': '''
# Efficient Queue Implementation using collections.deque
from collections import deque

class EfficientQueue:
    def __init__(self):
        self.items = deque()
    
    def enqueue(self, item):
        """Add an element to the rear of the queue - O(1)"""
        self.items.append(item)
        print(f"Enqueued: {item}")
    
    def dequeue(self):
        """Remove and return the front element - O(1)"""
        if self.is_empty():
            return None
        item = self.items.popleft()
        print(f"Dequeued: {item}")
        return item
    
    def peek(self):
        """Return the front element without removing it"""
        if self.is_empty():
            return None
        return self.items[0]
    
    def is_empty(self):
        """Check if the queue is empty"""
        return len(self.items) == 0
    
    def size(self):
        """Return the number of elements in the queue"""
        return len(self.items)
    
    def display(self):
        """Display the current queue"""
        print(f"Queue: {list(self.items)}")

# Example: Processing tasks in FIFO order
queue = EfficientQueue()

# Add tasks to queue
tasks = ["Task A", "Task B", "Task C", "Task D", "Task E", 
         "Task F", "Task G", "Task H", "Task I", "Task J"]

print("Adding tasks to queue:")
for task in tasks:
    queue.enqueue(task)

print(f"\\nTotal tasks in queue: {queue.size()}")
print(f"Next task to process: {queue.peek()}")

print("\\nProcessing tasks in FIFO order:")
while not queue.is_empty():
    current_task = queue.dequeue()
    print(f"Processing: {current_task}")
    queue.display()

print("\nAll tasks completed!")
''',
    };
  }

  static Map<String, String> getTreesExamples() {
    return {
      'Binary Tree Traversal': '''
# Binary Tree In-Order Traversal
# Traverse a binary tree in the order: Left -> Root -> Right
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def inorder_traversal(root):
    """In-order traversal: Left -> Root -> Right"""
    result = []
    
    def inorder(node):
        if node:
            inorder(node.left)   # Visit left subtree
            result.append(node.val)  # Visit root
            inorder(node.right)  # Visit right subtree
    
    inorder(root)
    return result

def preorder_traversal(root):
    """Pre-order traversal: Root -> Left -> Right"""
    result = []
    
    def preorder(node):
        if node:
            result.append(node.val)  # Visit root
            preorder(node.left)      # Visit left subtree
            preorder(node.right)     # Visit right subtree
    
    preorder(root)
    return result

def postorder_traversal(root):
    """Post-order traversal: Left -> Right -> Root"""
    result = []
    
    def postorder(node):
        if node:
            postorder(node.left)     # Visit left subtree
            postorder(node.right)    # Visit right subtree
            result.append(node.val)  # Visit root
    
    postorder(root)
    return result

# Example: Create a binary tree
#       50
#      /  \\
#     25   75
#    / \\   / \\
#   15  30 60  80
#  /  \\
# 10   20

root = TreeNode(50)
root.left = TreeNode(25)
root.right = TreeNode(75)
root.left.left = TreeNode(15)
root.left.right = TreeNode(30)
root.right.left = TreeNode(60)
root.right.right = TreeNode(80)
root.left.left.left = TreeNode(10)
root.left.left.right = TreeNode(20)

print("In-order traversal:", inorder_traversal(root))
print("Pre-order traversal:", preorder_traversal(root))
print("Post-order traversal:", postorder_traversal(root))
''',

      'Binary Search Tree Insertion': '''
# Binary Search Tree (BST) Operations
# Insert, search, and delete operations in a BST
class BSTNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class BinarySearchTree:
    def __init__(self):
        self.root = None
    
    def insert(self, val):
        """Insert a value into the BST"""
        self.root = self._insert_recursive(self.root, val)
    
    def _insert_recursive(self, node, val):
        # Base case: if node is None, create new node
        if not node:
            return BSTNode(val)
        
        # If value is less than current node, go left
        if val < node.val:
            node.left = self._insert_recursive(node.left, val)
        # If value is greater than current node, go right
        elif val > node.val:
            node.right = self._insert_recursive(node.right, val)
        # If value already exists, don't insert duplicate
        
        return node
    
    def search(self, val):
        """Search for a value in the BST"""
        return self._search_recursive(self.root, val)
    
    def _search_recursive(self, node, val):
        # Base case: node is None or value found
        if not node or node.val == val:
            return node is not None
        
        # If value is less than current node, search left
        if val < node.val:
            return self._search_recursive(node.left, val)
        # If value is greater than current node, search right
        else:
            return self._search_recursive(node.right, val)
    
    def inorder_display(self):
        """Display BST in sorted order (in-order traversal)"""
        result = []
        self._inorder_recursive(self.root, result)
        return result
    
    def _inorder_recursive(self, node, result):
        if node:
            self._inorder_recursive(node.left, result)
            result.append(node.val)
            self._inorder_recursive(node.right, result)

# Example usage
bst = BinarySearchTree()

# Insert values
values = [50, 25, 75, 15, 30, 60, 80, 10, 20, 35]
print("Inserting values:", values)
for val in values:
    bst.insert(val)
    print(f"Inserted {val}")

print("\nBST in sorted order:", bst.inorder_display())

# Search for values
search_values = [30, 45, 60, 90]
for val in search_values:
    found = bst.search(val)
    print(f"Search {val}: {'Found' if found else 'Not Found'}")
''',

      'Depth-First Search (DFS)': '''
# Depth-First Search (DFS) - Tree Traversal
# DFS explores as far as possible along each branch before backtracking
from collections import deque

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def dfs_recursive(root):
    """DFS using recursion (Pre-order traversal)"""
    if not root:
        return []
    
    result = []
    
    def dfs_helper(node):
        if node:
            result.append(node.val)  # Visit current node
            dfs_helper(node.left)    # Recursively visit left subtree
            dfs_helper(node.right)   # Recursively visit right subtree
    
    dfs_helper(root)
    return result

def dfs_iterative(root):
    """DFS using iterative approach with stack"""
    if not root:
        return []
    
    result = []
    stack = [root]  # Use stack for DFS
    
    while stack:
        node = stack.pop()  # Pop from stack (LIFO)
        result.append(node.val)
        
        # Add children to stack (right first, then left)
        # This ensures left child is processed first
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result

def dfs_all_paths(root, target):
    """Find all paths from root to target using DFS"""
    if not root:
        return []
    
    all_paths = []
    
    def dfs_path_helper(node, current_path, target_val):
        if not node:
            return
        
        # Add current node to path
        current_path.append(node.val)
        
        # If we found the target, save the path
        if node.val == target_val:
            all_paths.append(current_path.copy())
        else:
            # Continue searching in left and right subtrees
            dfs_path_helper(node.left, current_path, target_val)
            dfs_path_helper(node.right, current_path, target_val)
        
        # Backtrack: remove current node from path
        current_path.pop()
    
    dfs_path_helper(root, [], target)
    return all_paths

# Example: Create a binary tree
#       50
#      /  \\
#     30   70
#    / \\   / \\
#   20  40 60  80

root = TreeNode(50)
root.left = TreeNode(30)
root.right = TreeNode(70)
root.left.left = TreeNode(20)
root.left.right = TreeNode(40)
root.right.left = TreeNode(60)
root.right.right = TreeNode(80)

print("DFS Recursive:", dfs_recursive(root))
print("DFS Iterative:", dfs_iterative(root))
print("All paths to 40:", dfs_all_paths(root, 40))
print("All paths to 80:", dfs_all_paths(root, 80))
''',

      'Breadth-First Search (BFS)': '''
# Breadth-First Search (BFS) - Level Order Traversal
# BFS explores all nodes at the current depth before moving to the next depth
from collections import deque

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def bfs_level_order(root):
    """BFS traversal returning nodes level by level"""
    if not root:
        return []
    
    result = []
    queue = deque([root])  # Use queue for BFS (FIFO)
    
    while queue:
        node = queue.popleft()  # Dequeue from front (FIFO)
        result.append(node.val)
        
        # Add children to queue (left first, then right)
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return result

def bfs_by_levels(root):
    """BFS returning nodes grouped by levels"""
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)  # Number of nodes at current level
        current_level = []
        
        # Process all nodes at current level
        for _ in range(level_size):
            node = queue.popleft()
            current_level.append(node.val)
            
            # Add children for next level
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(current_level)
    
    return result

def bfs_find_level(root, target):
    """Find the level of a target node using BFS"""
    if not root:
        return -1
    
    queue = deque([(root, 0)])  # Store (node, level) pairs
    
    while queue:
        node, level = queue.popleft()
        
        if node.val == target:
            return level
        
        # Add children with incremented level
        if node.left:
            queue.append((node.left, level + 1))
        if node.right:
            queue.append((node.right, level + 1))
    
    return -1  # Target not found

def bfs_right_view(root):
    """Get the right view of the tree (rightmost node at each level)"""
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        
        for i in range(level_size):
            node = queue.popleft()
            
            # If this is the last node in the level, add to result
            if i == level_size - 1:
                result.append(node.val)
            
            # Add children for next level
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
    
    return result

# Example: Create a binary tree
#       50
#      /  \\
#     30   70
#    / \\   / \\
#   20  40 60  80

root = TreeNode(50)
root.left = TreeNode(30)
root.right = TreeNode(70)
root.left.left = TreeNode(20)
root.left.right = TreeNode(40)
root.right.left = TreeNode(60)
root.right.right = TreeNode(80)

print("BFS Level Order:", bfs_level_order(root))
print("BFS By Levels:", bfs_by_levels(root))
print("Level of node 40:", bfs_find_level(root, 40))
print("Level of node 80:", bfs_find_level(root, 80))
print("Right View:", bfs_right_view(root))

# Queue explanation:
# BFS uses a queue (First In, First Out - FIFO)
# 1. Start with root in queue: [50]
# 2. Dequeue 50, add its children: [30, 70]
# 3. Dequeue 30, add its children: [70, 20, 40]
# 4. Dequeue 70, add its children: [20, 40, 60, 80]
# 5. Continue until queue is empty
''',

      'Tree Height and Depth': '''
# Calculate Tree Height and Node Depth
# Height: longest path from node to leaf
# Depth: distance from root to node
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def calculate_height(root):
    """Calculate the height of a tree"""
    if not root:
        return -1  # Height of empty tree is -1
    
    # Height = 1 + max(left_height, right_height)
    left_height = calculate_height(root.left)
    right_height = calculate_height(root.right)
    
    return 1 + max(left_height, right_height)

def calculate_depth(root, target_val, current_depth=0):
    """Calculate the depth of a specific node"""
    if not root:
        return -1  # Node not found
    
    if root.val == target_val:
        return current_depth
    
    # Search in left subtree
    left_depth = calculate_depth(root.left, target_val, current_depth + 1)
    if left_depth != -1:
        return left_depth
    
    # Search in right subtree
    right_depth = calculate_depth(root.right, target_val, current_depth + 1)
    return right_depth

def is_balanced(root):
    """Check if a binary tree is height-balanced"""
    def check_balance(node):
        if not node:
            return 0, True  # height, is_balanced
        
        left_height, left_balanced = check_balance(node.left)
        right_height, right_balanced = check_balance(node.right)
        
        # Tree is balanced if:
        # 1. Left and right subtrees are balanced
        # 2. Height difference is at most 1
        current_balanced = (left_balanced and right_balanced and 
                          abs(left_height - right_height) <= 1)
        current_height = 1 + max(left_height, right_height)
        
        return current_height, current_balanced
    
    _, balanced = check_balance(root)
    return balanced

# Example: Create a tree with depth 5
#           50
#         /    \\
#        25     75
#       / \\    / \\
#      15  30  60  80
#     / \\      \\
#    10  20      65
#   /
#  5

root = TreeNode(50)
root.left = TreeNode(25)
root.right = TreeNode(75)
root.left.left = TreeNode(15)
root.left.right = TreeNode(30)
root.right.left = TreeNode(60)
root.right.right = TreeNode(80)
root.left.left.left = TreeNode(10)
root.left.left.right = TreeNode(20)
root.right.left.right = TreeNode(65)
root.left.left.left.left = TreeNode(5)

print(f"Tree height: {calculate_height(root)}")
print(f"Depth of node 65: {calculate_depth(root, 65)}")
print(f"Depth of node 5: {calculate_depth(root, 5)}")
print(f"Is tree balanced: {is_balanced(root)}")

# Test with different nodes
test_nodes = [50, 25, 15, 10, 5, 75, 80]
for node_val in test_nodes:
    depth = calculate_depth(root, node_val)
    print(f"Node {node_val} is at depth: {depth}")
''',
    };
  }
}