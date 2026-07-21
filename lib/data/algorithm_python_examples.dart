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

  static Map<String, String> getDoublyLinkedListExamples() {
    return {
      'Backward Traversal': '''
# Doubly Linked List - Backward Traversal
# Traverse the list from tail to head using the prev pointers
class DListNode:
    def __init__(self, val):
        self.val = val
        self.prev = None
        self.next = None

class DoublyLinkedList:
    def __init__(self):
        self.head = None
        self.tail = None

    def append(self, val):
        node = DListNode(val)
        if not self.head:
            self.head = self.tail = node
        else:
            node.prev = self.tail
            self.tail.next = node
            self.tail = node

    def traverse_backward(self):
        values = []
        current = self.tail
        while current:
            values.append(current.val)
            current = current.prev
        return values

# Example usage
dll = DoublyLinkedList()
for value in [10, 20, 30, 40]:
    dll.append(value)

print(dll.traverse_backward())  # Output: [40, 30, 20, 10]
''',

      'O(1) Deletion': '''
# Doubly Linked List - O(1) Deletion
# Deleting a known node takes O(1) since we can relink prev/next directly,
# unlike a singly linked list where you first need to find the predecessor
class DListNode:
    def __init__(self, val):
        self.val = val
        self.prev = None
        self.next = None

def delete_node(node):
    if node.prev:
        node.prev.next = node.next
    if node.next:
        node.next.prev = node.prev
    node.prev = node.next = None

# Example usage: build 1 <-> 2 <-> 3 <-> 4 and delete node 3 in O(1)
n1, n2, n3, n4 = DListNode(1), DListNode(2), DListNode(3), DListNode(4)
n1.next, n2.prev = n2, n1
n2.next, n3.prev = n3, n2
n3.next, n4.prev = n4, n3

delete_node(n3)  # No traversal needed, we already had the node reference

values = []
current = n1
while current:
    values.append(current.val)
    current = current.next
print(values)  # Output: [1, 2, 4]
''',
    };
  }

  static Map<String, String> getCircularLinkedListExamples() {
    return {
      'Round-Robin Traversal': '''
# Circular Linked List - Round-Robin Traversal
# The tail's next pointer wraps back to the head, so iterating n steps
# past the end just continues from the start again
class CListNode:
    def __init__(self, val):
        self.val = val
        self.next = None

def build_circular_list(values):
    head = CListNode(values[0])
    current = head
    for v in values[1:]:
        current.next = CListNode(v)
        current = current.next
    current.next = head  # wrap the tail back to the head
    return head

def round_robin(head, turns):
    result = []
    current = head
    for _ in range(turns):
        result.append(current.val)
        current = current.next
    return result

# Example usage: 3 processes sharing CPU time, walked for 7 turns
head = build_circular_list(["P1", "P2", "P3"])
print(round_robin(head, 7))  # Output: ['P1', 'P2', 'P3', 'P1', 'P2', 'P3', 'P1']
''',

      'Josephus Problem': '''
# Circular Linked List - Josephus Problem
# Repeatedly eliminate every k-th node from a circle until one remains
class CListNode:
    def __init__(self, val):
        self.val = val
        self.next = None

def josephus(values, k):
    head = CListNode(values[0])
    current = head
    for v in values[1:]:
        current.next = CListNode(v)
        current = current.next
    current.next = head  # close the circle

    current = head
    while current.next != current:
        # Walk k - 1 steps to reach the node just before the one to remove
        for _ in range(k - 1):
            current = current.next
        current.next = current.next.next  # remove the k-th node
        current = current.next

    return current.val

# Example usage: 7 people in a circle, every 3rd person is eliminated
print(josephus([1, 2, 3, 4, 5, 6, 7], 3))  # Output: 4 (last person standing)
''',
    };
  }

  static Map<String, String> getSortingExamples() {
    return {
      'Bubble Sort': '''
# Bubble Sort
# Repeatedly swap adjacent elements that are out of order
def bubble_sort(nums):
    n = len(nums)
    for i in range(n):
        swapped = False
        # After each pass, the largest remaining element bubbles to the end
        for j in range(n - i - 1):
            if nums[j] > nums[j + 1]:
                nums[j], nums[j + 1] = nums[j + 1], nums[j]
                swapped = True
        if not swapped:
            break  # already sorted, stop early
    return nums

# Example usage
print(bubble_sort([5, 2, 9, 1, 5, 6]))  # Output: [1, 2, 5, 5, 6, 9]
''',

      'Quick Sort': '''
# Quick Sort
# Pick a pivot, partition the array around it, then recursively sort both sides
def quick_sort(nums):
    if len(nums) <= 1:
        return nums

    pivot = nums[len(nums) // 2]
    left = [x for x in nums if x < pivot]
    middle = [x for x in nums if x == pivot]
    right = [x for x in nums if x > pivot]

    return quick_sort(left) + middle + quick_sort(right)

# Example usage
print(quick_sort([5, 2, 9, 1, 5, 6]))  # Output: [1, 2, 5, 5, 6, 9]
''',

      'Merge Sort': '''
# Merge Sort
# Split the array in half, recursively sort each half, then merge the sorted halves
def merge_sort(nums):
    if len(nums) <= 1:
        return nums

    mid = len(nums) // 2
    left = merge_sort(nums[:mid])
    right = merge_sort(nums[mid:])
    return _merge(left, right)

def _merge(left, right):
    merged = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            merged.append(left[i])
            i += 1
        else:
            merged.append(right[j])
            j += 1
    merged.extend(left[i:])
    merged.extend(right[j:])
    return merged

# Example usage
print(merge_sort([5, 2, 9, 1, 5, 6]))  # Output: [1, 2, 5, 5, 6, 9]
''',
    };
  }

  static Map<String, String> getHeapExamples() {
    return {
      'Build a Min-Heap': '''
# Build a Min-Heap
# Uses Python's heapq, which implements a binary min-heap on a list
import heapq

def build_min_heap(nums):
    heap = nums[:]
    heapq.heapify(heap)  # O(n), rearranges the list in place into heap order
    return heap

# Example usage
nums = [9, 4, 7, 1, 3, 8]
heap = build_min_heap(nums)
print(heap[0])                 # Output: 1  (smallest is always at the root)
print(heapq.heappop(heap))     # Output: 1
print(heapq.heappop(heap))     # Output: 3
''',

      'Kth Largest Element': '''
# Kth Largest Element (Min-Heap of size k)
# Keep a min-heap of the k largest values seen so far; its root is the answer
import heapq

def find_kth_largest(nums, k):
    heap = []
    for num in nums:
        heapq.heappush(heap, num)
        if len(heap) > k:
            heapq.heappop(heap)  # discard the smallest, keeping only the top k
    return heap[0]

# Example usage
nums = [3, 2, 1, 5, 6, 4]
print(find_kth_largest(nums, 2))  # Output: 5 (2nd largest value)
''',
    };
  }

  static Map<String, String> getGreedyExamples() {
    return {
      'Activity Selection': '''
# Activity Selection
# Sort by end time, then greedily pick each activity that starts after
# the previous one ends - this always yields the maximum number of activities
def activity_selection(activities):
    activities = sorted(activities, key=lambda a: a[1])  # sort by end time
    selected = [activities[0]]
    last_end = activities[0][1]

    for start, end in activities[1:]:
        if start >= last_end:
            selected.append((start, end))
            last_end = end

    return selected

# Example usage: (start, end) pairs
activities = [(1, 4), (3, 5), (0, 6), (5, 7), (3, 9), (5, 9), (6, 10), (8, 11)]
print(activity_selection(activities))  # Output: [(1, 4), (5, 7), (8, 11)]
''',

      'Jump Game': '''
# Jump Game
# Greedily track the farthest index reachable so far; if we ever reach an
# index beyond that farthest point, the end is unreachable
def can_jump(nums):
    farthest = 0
    for i, num in enumerate(nums):
        if i > farthest:
            return False  # this index is unreachable
        farthest = max(farthest, i + num)
    return True

# Example usage
print(can_jump([2, 3, 1, 1, 4]))  # Output: True
print(can_jump([3, 2, 1, 0, 4]))  # Output: False (stuck at index 3)
''',
    };
  }

  static Map<String, String> getBacktrackingExamples() {
    return {
      'Generate All Subsets': '''
# Generate All Subsets (Power Set)
# At each element, branch into two choices: include it, or do not
def subsets(nums):
    result = []

    def backtrack(start, current):
        result.append(current[:])  # record every partial subset, not just full paths
        for i in range(start, len(nums)):
            current.append(nums[i])
            backtrack(i + 1, current)  # explore including nums[i]
            current.pop()              # undo the choice (backtrack)

    backtrack(0, [])
    return result

# Example usage
print(subsets([1, 2, 3]))
# Output: [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
''',

      'N-Queens': '''
# N-Queens
# Place queens row by row, backtracking whenever a placement conflicts
# with a previously placed queen (same column or diagonal)
def solve_n_queens(n):
    solutions = []
    columns = set()
    diagonals = set()       # row - col is constant along a downward diagonal
    anti_diagonals = set()  # row + col is constant along an upward diagonal
    placement = [-1] * n

    def backtrack(row):
        if row == n:
            solutions.append(placement[:])
            return
        for col in range(n):
            if col in columns or (row - col) in diagonals or (row + col) in anti_diagonals:
                continue
            columns.add(col)
            diagonals.add(row - col)
            anti_diagonals.add(row + col)
            placement[row] = col

            backtrack(row + 1)

            columns.remove(col)          # undo the choice (backtrack)
            diagonals.remove(row - col)
            anti_diagonals.remove(row + col)

    backtrack(0)
    return solutions

# Example usage
solutions = solve_n_queens(4)
print(len(solutions))  # Output: 2 (two distinct solutions for a 4x4 board)
print(solutions[0])    # Output: [1, 3, 0, 2] (column index of the queen in each row)
''',
    };
  }

  static Map<String, String> getGraphExamples() {
    return {
      'Breadth-First Search (BFS)': '''
# Graph - Breadth-First Search (BFS)
# Explore level by level using a queue, visiting the nearest nodes first
from collections import deque

def bfs(graph, start):
    visited = {start}
    order = []
    queue = deque([start])

    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return order

# Example usage
graph = {
    "A": ["B", "C"],
    "B": ["A", "D"],
    "C": ["A", "D"],
    "D": ["B", "C", "E"],
    "E": ["D"],
}
print(bfs(graph, "A"))  # Output: ['A', 'B', 'C', 'D', 'E']
''',

      'Depth-First Search (DFS)': '''
# Graph - Depth-First Search (DFS)
# Explore as far as possible down each branch before backtracking
def dfs(graph, start, visited=None, order=None):
    if visited is None:
        visited = set()
        order = []

    visited.add(start)
    order.append(start)

    for neighbor in graph[start]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited, order)

    return order

# Example usage
graph = {
    "A": ["B", "C"],
    "B": ["A", "D"],
    "C": ["A", "D"],
    "D": ["B", "C", "E"],
    "E": ["D"],
}
print(dfs(graph, "A"))  # Output: ['A', 'B', 'D', 'C', 'E']
''',

      'Topological Sort': '''
# Graph - Topological Sort (Kahn's Algorithm)
# Repeatedly remove nodes with no remaining incoming edges - only valid
# on a Directed Acyclic Graph (DAG)
from collections import deque

def topological_sort(graph):
    in_degree = {node: 0 for node in graph}
    for node in graph:
        for neighbor in graph[node]:
            in_degree[neighbor] += 1

    queue = deque([node for node in graph if in_degree[node] == 0])
    order = []

    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbor in graph[node]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    if len(order) != len(graph):
        raise ValueError("Graph has a cycle, no valid topological order exists")
    return order

# Example usage: course prerequisites (course -> courses that depend on it)
graph = {
    "intro": ["data_structures"],
    "data_structures": ["algorithms"],
    "algorithms": ["system_design"],
    "system_design": [],
}
print(topological_sort(graph))
# Output: ['intro', 'data_structures', 'algorithms', 'system_design']
''',
    };
  }

  static Map<String, String> getHashingExamples() {
    return {
      'Two Sum (Hash Map)': '''
# Two Sum (Hash Map)
# Store each visited number's index; for every new number, check whether
# its complement was already seen - O(n) instead of the O(n^2) brute force
def two_sum(nums, target):
    seen = {}  # value -> index
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []

# Example usage
print(two_sum([2, 7, 11, 15], 9))  # Output: [0, 1] (2 + 7 = 9)
''',

      'Detect Duplicates (Hash Set)': '''
# Detect Duplicates (Hash Set)
# A set gives O(1) average membership checks, so a single pass suffices
def contains_duplicate(nums):
    seen = set()
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False

# Example usage
print(contains_duplicate([1, 2, 3, 1]))  # Output: True
print(contains_duplicate([1, 2, 3, 4]))  # Output: False
''',
    };
  }

  static Map<String, String> getDynamicProgrammingExamples() {
    return {
      'Climbing Stairs (1D DP)': '''
# Climbing Stairs (1D DP)
# The number of ways to reach step n is the sum of the ways to reach the
# two steps before it (you arrive there via a 1-step or a 2-step move)
def climb_stairs(n):
    if n <= 2:
        return n

    prev2, prev1 = 1, 2  # ways to reach step 1 and step 2
    for _ in range(3, n + 1):
        prev2, prev1 = prev1, prev1 + prev2
    return prev1

# Example usage
print(climb_stairs(5))  # Output: 8
''',

      'House Robber (1D DP)': '''
# House Robber (1D DP)
# At each house, choose the better of: skip it (carry forward the best so
# far), or rob it (best from two houses back, plus this house's value)
def rob(nums):
    prev2, prev1 = 0, 0  # best total up to two houses ago, one house ago
    for num in nums:
        prev2, prev1 = prev1, max(prev1, prev2 + num)
    return prev1

# Example usage
print(rob([2, 7, 9, 3, 1]))  # Output: 12 (rob houses 0, 2, 4: 2+9+1)
''',
    };
  }

  static Map<String, String> getUnionFindExamples() {
    return {
      'Union-Find (Disjoint Set)': '''
# Union-Find (Disjoint Set)
# Path compression + union by rank keep find()/union() nearly O(1) amortized
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # path compression
        return self.parent[x]

    def union(self, x, y):
        root_x, root_y = self.find(x), self.find(y)
        if root_x == root_y:
            return False  # already connected

        # union by rank: attach the smaller tree under the larger one
        if self.rank[root_x] < self.rank[root_y]:
            root_x, root_y = root_y, root_x
        self.parent[root_y] = root_x
        if self.rank[root_x] == self.rank[root_y]:
            self.rank[root_x] += 1
        return True

# Example usage
uf = UnionFind(6)
uf.union(0, 1)
uf.union(1, 2)
uf.union(3, 4)
print(uf.find(0) == uf.find(2))  # Output: True (0 and 2 are connected)
print(uf.find(0) == uf.find(3))  # Output: False (different components)
''',

      'Number of Connected Components': '''
# Number of Connected Components (Union-Find)
# Start with n separate components; every successful union merges two
# components into one, so the final count is n minus the number of merges
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.count = n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x, root_y = self.find(x), self.find(y)
        if root_x != root_y:
            self.parent[root_y] = root_x
            self.count -= 1

def count_components(n, edges):
    uf = UnionFind(n)
    for a, b in edges:
        uf.union(a, b)
    return uf.count

# Example usage: 5 nodes, edges (0-1), (1-2), (3-4)
print(count_components(5, [(0, 1), (1, 2), (3, 4)]))  # Output: 2
''',
    };
  }

  static Map<String, String> getIntervalsExamples() {
    return {
      'Merge Intervals': '''
# Merge Intervals
# Sort by start time, then merge any interval that overlaps the last one kept
def merge_intervals(intervals):
    if not intervals:
        return []

    intervals = sorted(intervals, key=lambda i: i[0])
    merged = [intervals[0]]

    for start, end in intervals[1:]:
        last_start, last_end = merged[-1]
        if start <= last_end:  # overlaps the previous interval
            merged[-1] = (last_start, max(last_end, end))
        else:
            merged.append((start, end))

    return merged

# Example usage
print(merge_intervals([(1, 3), (2, 6), (8, 10), (15, 18)]))
# Output: [(1, 6), (8, 10), (15, 18)]
''',

      'Insert Interval': '''
# Insert Interval
# Add all intervals ending before the new one, merge all overlapping ones
# into the new interval, then add the rest unchanged
def insert_interval(intervals, new_interval):
    result = []
    i = 0
    n = len(intervals)

    while i < n and intervals[i][1] < new_interval[0]:
        result.append(intervals[i])
        i += 1

    while i < n and intervals[i][0] <= new_interval[1]:
        new_interval = (
            min(new_interval[0], intervals[i][0]),
            max(new_interval[1], intervals[i][1]),
        )
        i += 1
    result.append(new_interval)

    while i < n:
        result.append(intervals[i])
        i += 1

    return result

# Example usage
print(insert_interval([(1, 3), (6, 9)], (2, 5)))
# Output: [(1, 5), (6, 9)]
''',
    };
  }

  static Map<String, String> getTrieExamples() {
    return {
      'Insert and Search a Word': '''
# Trie - Insert and Search a Word
# Each node holds children keyed by character, plus a flag for word endings
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end_of_word = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for char in word:
            node = node.children.setdefault(char, TrieNode())
        node.is_end_of_word = True

    def search(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end_of_word

# Example usage
trie = Trie()
for word in ["cat", "car", "card"]:
    trie.insert(word)

print(trie.search("car"))   # Output: True
print(trie.search("ca"))    # Output: False (prefix, but not a full word)
''',

      'Prefix Matching (Autocomplete)': '''
# Trie - Prefix Matching (Autocomplete)
# Walk down the trie following the prefix, then collect every word in the subtree
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end_of_word = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for char in word:
            node = node.children.setdefault(char, TrieNode())
        node.is_end_of_word = True

    def words_with_prefix(self, prefix):
        node = self.root
        for char in prefix:
            if char not in node.children:
                return []
            node = node.children[char]

        results = []
        self._collect(node, prefix, results)
        return results

    def _collect(self, node, path, results):
        if node.is_end_of_word:
            results.append(path)
        for char, child in node.children.items():
            self._collect(child, path + char, results)

# Example usage
trie = Trie()
for word in ["cat", "car", "card", "care", "dog"]:
    trie.insert(word)

print(trie.words_with_prefix("car"))  # Output: ['car', 'card', 'care']
''',
    };
  }

  static Map<String, String> getBitManipulationExamples() {
    return {
      'Find the Single Number (XOR)': '''
# Find the Single Number (XOR)
# XOR-ing every number together cancels out all pairs (x ^ x == 0),
# leaving only the number that appears once
def single_number(nums):
    result = 0
    for num in nums:
        result ^= num
    return result

# Example usage
print(single_number([4, 1, 2, 1, 2]))  # Output: 4
''',

      'Count Set Bits': '''
# Count Set Bits (Brian Kernighan's Algorithm)
# n & (n - 1) clears the lowest set bit, so counting how many times that
# takes to reach 0 counts the set bits directly, skipping the 0 bits
def count_set_bits(n):
    count = 0
    while n:
        n &= n - 1  # clear the lowest set bit
        count += 1
    return count

# Example usage
print(count_set_bits(11))  # Output: 3 (11 is 1011 in binary)
print(count_set_bits(8))   # Output: 1 (8 is 1000 in binary)
''',
    };
  }

  static Map<String, String> getMatrixTraversalExamples() {
    return {
      'Spiral Matrix Traversal': '''
# Spiral Matrix Traversal
# Peel the matrix layer by layer: right across the top, down the right
# side, left across the bottom, up the left side, then shrink the bounds
def spiral_order(matrix):
    if not matrix:
        return []

    result = []
    top, bottom = 0, len(matrix) - 1
    left, right = 0, len(matrix[0]) - 1

    while top <= bottom and left <= right:
        for col in range(left, right + 1):
            result.append(matrix[top][col])
        top += 1

        for row in range(top, bottom + 1):
            result.append(matrix[row][right])
        right -= 1

        if top <= bottom:
            for col in range(right, left - 1, -1):
                result.append(matrix[bottom][col])
            bottom -= 1

        if left <= right:
            for row in range(bottom, top - 1, -1):
                result.append(matrix[row][left])
            left += 1

    return result

# Example usage
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
]
print(spiral_order(matrix))  # Output: [1, 2, 3, 6, 9, 8, 7, 4, 5]
''',

      'Rotate Matrix In-Place': '''
# Rotate Matrix In-Place (90 degrees clockwise)
# Transpose the matrix (swap rows/columns), then reverse each row -
# together these two O(n^2) passes rotate it without extra space
def rotate(matrix):
    n = len(matrix)

    for i in range(n):
        for j in range(i + 1, n):
            matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]  # transpose

    for row in matrix:
        row.reverse()  # mirror each row left-to-right

    return matrix

# Example usage
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
]
print(rotate(matrix))
# Output: [[7, 4, 1], [8, 5, 2], [9, 6, 3]]
''',
    };
  }

  /// Looks up the Python examples for any of the 21 algorithm ids, so
  /// callers don't need their own id-to-getter switch statement.
  static Map<String, String> examplesFor(String algorithmId) {
    switch (algorithmId) {
      case 'two_pointers':
        return getTwoPointersExamples();
      case 'sliding_window':
        return getSlidingWindowExamples();
      case 'stack':
        return getStackExamples();
      case 'queue':
        return getQueueExamples();
      case 'linked_list':
        return getLinkedListExamples();
      case 'doubly_linked_list':
        return getDoublyLinkedListExamples();
      case 'circular_linked_list':
        return getCircularLinkedListExamples();
      case 'binary_search':
        return getBinarySearchExamples();
      case 'trees':
        return getTreesExamples();
      case 'sorting':
        return getSortingExamples();
      case 'heap':
        return getHeapExamples();
      case 'greedy':
        return getGreedyExamples();
      case 'backtracking':
        return getBacktrackingExamples();
      case 'graph':
        return getGraphExamples();
      case 'hashing':
        return getHashingExamples();
      case 'dynamic_programming':
        return getDynamicProgrammingExamples();
      case 'union_find':
        return getUnionFindExamples();
      case 'intervals':
        return getIntervalsExamples();
      case 'trie':
        return getTrieExamples();
      case 'bit_manipulation':
        return getBitManipulationExamples();
      case 'matrix_traversal':
        return getMatrixTraversalExamples();
      default:
        return {};
    }
  }
}