# AllGoldRhythm

A comprehensive Data Structures and Algorithms (DSA) visualization app built with Flutter. This app provides interactive learning experiences for algorithm concepts through visual simulations, step-by-step explanations, and code examples.

## 🚀 Tech Stack

### Frontend Framework
- **Flutter 3.8.1+** - Cross-platform UI toolkit
- **Dart** - Programming language
- **Material Design 3** - UI design system

### Dependencies
- **provider: ^6.1.1** - State management
- **flutter_svg: ^2.0.9** - SVG rendering support
- **shared_preferences: ^2.2.2** - Local data persistence
- **animated_text_kit: ^4.2.2** - Text animations
- **cupertino_icons: ^1.0.8** - iOS-style icons

### Development Tools
- **flutter_test** - Testing framework
- **flutter_lints** - Code quality and style enforcement

## 📁 Directory Structure

```
allgoldrythm/
├── android/                 # Android-specific configuration
├── ios/                     # iOS-specific configuration
├── web/                     # Web-specific configuration
├── linux/                   # Linux-specific configuration
├── macos/                   # macOS-specific configuration
├── windows/                 # Windows-specific configuration
├── assets/
│   └── images/             # Image assets
├── lib/
│   ├── data/               # Data layer
│   │   ├── algorithm_data.dart           # Algorithm definitions and visualizations
│   │   └── algorithm_python_examples.dart # Python code examples
│   ├── models/             # Data models
│   │   └── algorithm.dart  # Algorithm, AlgorithmVisualization, VisualizationStep models
│   ├── screens/            # UI screens
│   │   ├── home_screen.dart              # Main navigation screen
│   │   ├── algorithm_detail_screen.dart  # Algorithm details and visualizations
│   │   └── code_examples_screen.dart     # Code examples display
│   ├── widgets/            # Reusable UI components
│   │   ├── algorithm_definition.dart     # Algorithm definition display
│   │   ├── algorithm_review.dart         # Interactive review component
│   │   └── algorithm_simulation.dart     # Visual simulation component
│   ├── utils/              # Utility functions
│   └── main.dart           # App entry point
├── test/                   # Unit and widget tests
├── pubspec.yaml           # Dependencies and project configuration
└── README.md              # Project documentation
```

## 🛠️ Build and Run Instructions

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK
- Platform-specific development tools:
  - **Chrome**: For web development
  - **Android Studio/Xcode**: For mobile development
  - **Visual Studio**: For Windows development

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd allgoldrythm
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation:**
   ```bash
   flutter doctor
   ```

### Running the App

#### Chrome (Web)
```bash
flutter run -d chrome
```

#### Android
```bash
# Connect Android device or start emulator
flutter run -d android
```

#### iOS
```bash
# Connect iOS device or start simulator (macOS only)
flutter run -d ios
```

#### Desktop Platforms
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

### Building for Production

#### Web
```bash
flutter build web
```

#### Android APK
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## 📚 Adding New Content

### Adding a New Algorithm Section

To add a new algorithm (e.g., DSA -> Two Pointers or DSA -> Sliding Window):

1. **Open `lib/data/algorithm_data.dart`**

2. **Add a new Algorithm object to the list:**
   ```dart
   Algorithm(
     id: 'sliding_window',
     name: 'Sliding Window',
     category: 'DSA',
     description: 'Sliding Window technique description...',
     steps: [
       'Step 1: Initialize window boundaries',
       'Step 2: Expand or contract window',
       'Step 3: Process current window',
       'Step 4: Continue until end condition'
     ],
     visualizations: [
       // Add visualizations here
     ],
   ),
   ```

### Adding a New Simulation

To add a new simulation (e.g., 'Left-Right Two Pointers'):

1. **Add AlgorithmVisualization to the visualizations list:**
   ```dart
   AlgorithmVisualization(
     type: 'simulation',
     title: 'Left-Right Two Pointers',
     description: 'Visual demonstration of left-right pointer movement',
     steps: [
       VisualizationStep(
         highlightIndices: [0, 9],
         previousIndices: [],
         explanation: 'Initialize pointers at start and end',
       ),
       VisualizationStep(
         highlightIndices: [1, 8],
         previousIndices: [0, 9],
         explanation: 'Move pointers toward center',
       ),
       // Add more steps...
     ],
   ),
   ```

2. **VisualizationStep Properties:**
   - `highlightIndices`: Array indices to highlight (current positions)
   - `previousIndices`: Previous positions for comparison
   - `explanation`: Step-by-step explanation text

### Adding a New Interactive Review

To add interactive review for 'Left-Right Two Pointers':

1. **Add AlgorithmVisualization with type 'interactive':**
   ```dart
   AlgorithmVisualization(
     type: 'interactive',
     title: 'Left-Right Two Pointers Practice',
     description: 'Interactive practice for pointer movements',
     steps: [
       VisualizationStep(
         highlightIndices: [0, 9],
         previousIndices: [],
         explanation: 'Click to move the left pointer right or right pointer left',
       ),
       // Add interactive steps...
     ],
   ),
   ```

2. **The interactive functionality is handled by `algorithm_review.dart` widget**

### Adding Python Code Examples

To add Python code examples for 'Left-Right Two Pointers':

1. **Open `lib/data/algorithm_python_examples.dart`**

2. **Add or update the examples map:**
   ```dart
   static Map<String, String> getTwoPointersExamples() {
     return {
       'Left-Right Two Pointers': '''
   # Two Sum Problem - Left-Right Two Pointers
   def two_sum(nums, target):
       left, right = 0, len(nums) - 1
       
       while left < right:
           current_sum = nums[left] + nums[right]
           
           if current_sum == target:
               return [left, right]
           elif current_sum < target:
               left += 1  # Move left pointer right
           else:
               right -= 1  # Move right pointer left
       
       return []  # No solution found
   
   # Example usage
   nums = [1, 3, 4, 5, 7, 11]
   target = 9
   result = two_sum(nums, target)
   print(f"Indices: {result}")  # Output: [1, 4]
   ''',
       // Add more examples...
     };
   }
   ```

3. **Code Example Guidelines:**
   - Include clear comments explaining each step
   - Provide example usage with expected output
   - Follow Python best practices
   - Keep examples concise but comprehensive

## ⚙️ Important Configurations

### App Configuration
- **App Name**: AllGoldRhythm
- **Package Name**: allgoldrhythm
- **Version**: 1.0.0+1
- **Minimum SDK**: Flutter 3.8.1+

### Theme Configuration
```dart
// lib/main.dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
  useMaterial3: true,
  fontFamily: 'Roboto',
)
```

### Animation Settings
- **Simulation Speed**: 3 seconds per step (configurable in `algorithm_simulation.dart`)
- **Highlight Colors**: Amber for active elements
- **Text Animations**: Powered by `animated_text_kit`

### Platform-Specific Configurations

#### Web (`web/index.html`)
- Base href configuration for deployment
- Meta tags for responsive design
- Service worker for PWA capabilities

#### Android (`android/app/build.gradle.kts`)
- Minimum SDK version
- Target SDK version
- App permissions

#### iOS (`ios/Runner/Info.plist`)
- Bundle identifier
- App permissions
- Deployment target

### Development Configuration
- **Debug Banner**: Disabled in production
- **Hot Reload**: Enabled for development
- **Linting**: Configured via `analysis_options.yaml`

## 🎯 Key Features

- **Visual Simulations**: Step-by-step algorithm visualizations
- **Interactive Learning**: Hands-on practice with algorithm concepts
- **Code Examples**: Python implementations with explanations
- **Cross-Platform**: Runs on web, mobile, and desktop
- **Responsive Design**: Adapts to different screen sizes
- **Offline Support**: Core functionality works without internet

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the coding standards defined in `analysis_options.yaml`
4. Add tests for new features
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Happy Learning! 🚀**
