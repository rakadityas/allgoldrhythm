# AllGoldRhythm

With the rise of AI (Artificial Intelligence), the need for understanding and implementing algorithms has never been greater. As the matter of fact, this overall code base was built by and AI, scary right? But don't worry, we have got you covered.

AllGoldRhythm will help you learn and visualize algorithms in a fun and interactive way. It is a comprehensive interview-prep app covering two tracks:

- **Data Structures & Algorithms** — 20 core patterns (two pointers, sliding window, trees, graphs, dynamic programming, and more) with interactive step-by-step simulations, a tap-to-validate review mode, and a 15-question quiz per topic.
- **System Design** — a hellointerview-style curriculum: fundamentals/theory concepts (networking, caching, databases, scaling, consistency, search, notifications, geospatial indexing, and more) each illustrated with a pre-drawn architecture diagram, plus practice problems where you sketch the architecture yourself on a drag-and-drop design canvas and check it against a reference solution.

Inspired by @yangshun [Tech Interview Handbook](https://github.com/yangshun/tech-interview-handbook), Navdeep Singh's [NeetCode](https://neetcode.io/), and [hellointerview](https://www.hellointerview.com/).

DEMO HERE: [Chrome build](https://drive.google.com/file/d/1Ko2AnSJWDN1GCw5uRlI9Zw-jWQplYZKK/view?usp=drive_link)

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
│   │   ├── algorithm_data.dart            # DSA algorithm definitions and visualizations (20 topics)
│   │   ├── algorithm_python_examples.dart # Python code examples per algorithm
│   │   ├── quiz_data.dart                 # 15-question quiz bank per algorithm
│   │   ├── fundamentals_data.dart         # System Design theory concepts, grouped by category
│   │   └── system_design_data.dart        # System Design practice problems (case studies)
│   ├── models/             # Data models
│   │   ├── algorithm.dart            # Algorithm, AlgorithmVisualization, VisualizationStep
│   │   ├── quiz_question.dart        # QuizQuestion model
│   │   ├── fundamental_concept.dart  # FundamentalConcept (theory topic + optional diagram)
│   │   └── system_design.dart        # ComponentType, PlacedComponent, Connection, ReferenceArchitecture, SystemDesignProblem
│   ├── screens/            # UI screens
│   │   ├── home_screen.dart                 # Two-track hub (DSA / System Design) + drawer navigation
│   │   ├── algorithm_list_screen.dart       # DSA: searchable, categorized algorithm list
│   │   ├── algorithm_detail_screen.dart     # DSA: Simulation / Review / Quiz tabs for one algorithm
│   │   ├── code_examples_screen.dart        # Python code examples display
│   │   ├── fundamentals_list_screen.dart    # System Design: categorized theory concept list
│   │   ├── fundamental_detail_screen.dart   # System Design: theory summary + diagram + key points
│   │   ├── system_design_list_screen.dart   # System Design: Fundamentals / Practice Problems tabs
│   │   └── system_design_detail_screen.dart # System Design: Requirements / Design Canvas tabs for one problem
│   ├── widgets/            # Reusable UI components
│   │   ├── algorithm_definition.dart # Algorithm definition display
│   │   ├── algorithm_review.dart     # Interactive tap-to-validate review component
│   │   ├── algorithm_simulation.dart # Visual step-by-step simulation component
│   │   ├── algorithm_quiz.dart       # Multiple-choice quiz component with scoring
│   │   ├── design_canvas.dart        # Drag-and-drop system design canvas (place/connect/check/undo)
│   │   └── architecture_diagram.dart # Static, pre-drawn diagram (fundamentals) using the same visual language as the canvas
│   ├── theme/
│   │   └── app_theme.dart  # Material 3 theme, design tokens (AppSpacing/AppRadius), light/dark, semantic colors
│   ├── utils/              # Utility functions
│   │   ├── pointer_labels.dart # Pointer/cursor labels (L/R, Slow/Fast, Mid, ...) shared by Simulation and Review
│   │   └── graph_layout.dart   # Shared fixed graph layout used by graph visualizations
│   └── main.dart           # App entry point
├── test/                   # Unit and widget tests
├── pubspec.yaml           # Dependencies and project configuration
└── README.md              # Project documentation
```

## 🔧 Build Instructions

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK
- Android Studio (for Android builds)
- Chrome browser (for web builds)
- Git

### Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd allgoldrhythm
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Verify Flutter installation:
   ```bash
   flutter doctor
   ```

### Building for Android

#### Debug Build
```bash
# Build and install on connected device
flutter run

# Or build APK only
flutter build apk --debug
```

#### Release Build
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Install release APK on connected device
flutter install
```

**Output locations:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

#### Android Requirements
- Android SDK 21+ (Android 5.0)
- Enable Developer Options and USB Debugging on your device
- Or use Android Emulator

### Building for Web (Chrome)

#### Development Server
```bash
# Run development server
flutter run -d chrome

# Or specify port
flutter run -d chrome --web-port 8080
```

#### Production Build
```bash
# Build for web
flutter build web

# Build with specific base href (for subdirectory deployment)
flutter build web --base-href "/allgoldrhythm/"
```

**Output location:**
- Web build: `build/web/`

#### Web Deployment
1. **Local Testing:**
   ```bash
   # Serve the built web app locally
   cd build/web
   python -m http.server 8000
   # Or use any static file server
   ```

2. **Deploy to GitHub Pages:**
   - Copy contents of `build/web/` to your GitHub Pages repository
   - Ensure `index.html` is in the root directory

3. **Deploy to Firebase Hosting:**
   ```bash
   firebase init hosting
   firebase deploy
   ```

4. **Deploy to Netlify:**
   - Drag and drop the `build/web/` folder to Netlify
   - Or connect your repository for automatic deployments

#### Web Requirements
- Modern web browser (Chrome, Firefox, Safari, Edge)
- JavaScript enabled
- Internet connection for initial load

### Platform-Specific Notes

#### Android
- Custom app icon configured via `flutter_launcher_icons` in `pubspec.yaml`, with both `adaptive_icon_background` and `adaptive_icon_foreground` set (not just a flat `image_path`) — Android 8+ launchers auto-wrap a flat legacy icon in a padded adaptive-icon frame, which looks visibly shrunk on the home screen if only `image_path` is set
- Icon source: `icon/screenshot.jpg`
- Regenerate after any icon change with `dart run flutter_launcher_icons`
- Supports Android 5.0+ (API level 21+)

#### Web
- Progressive Web App (PWA) ready
- Responsive design for desktop and mobile browsers
- Offline capability through service worker

### Troubleshooting

#### Common Issues
1. **"flutter command not found"**
   - Ensure Flutter is added to your PATH
   - Run `flutter doctor` to verify installation

2. **Android build fails**
   - Check Android SDK installation
   - Verify ANDROID_HOME environment variable
   - Run `flutter doctor --android-licenses`

3. **Web build issues**
   - Clear browser cache
   - Try incognito/private browsing mode
   - Check browser console for errors

4. **Dependencies issues**
   ```bash
   flutter clean
   flutter pub get
   ```

## 📚 Adding New Content

### Adding a New Algorithm Section

To add a new algorithm (e.g., Data Structures & Algorithm -> Two Pointers or Data Structures & Algorithm -> Sliding Window):

1. **Open `lib/data/algorithm_data.dart`**

2. **Add a new Algorithm object to the list:**
   ```dart
   Algorithm(
     id: 'sliding_window',
     name: 'Sliding Window',
     category: 'Data Structures & Algorithm',
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

1. **Add AlgorithmVisualization to the visualizations list.** `mockQuestion` and `values` are required — they're what make the Review tab's step-through concrete instead of abstract index-highlighting:
   ```dart
   AlgorithmVisualization(
     type: 'simulation',
     title: 'Left-Right Two Pointers',
     description: 'Visual demonstration of left-right pointer movement',
     mockQuestion: 'Given [2, 7, 11, 15, 20, 26], find two numbers that sum to 26.',
     values: [2, 7, 11, 15, 20, 26],
     steps: [
       VisualizationStep(
         highlightIndices: [0, 5],
         previousIndices: [],
         explanation: 'Initialize pointers at start and end',
       ),
       VisualizationStep(
         highlightIndices: [1, 4],
         previousIndices: [0, 5],
         explanation: 'Move pointers toward center',
       ),
       // Add more steps...
     ],
   ),
   ```
   Every arithmetic trace (the actual sequence of indices/values across steps) must be verified against a hand-written reference implementation before being committed — hand-authored "canned" step sequences have turned out to be mathematically impossible in the past. `test/widget_test.dart` also has a smoke test that automatically loops over every algorithm and steps through its visualizations, which catches structural mistakes (out-of-bounds indices, empty `highlightIndices` on the first step) for free.

2. **VisualizationStep properties:**
   - `highlightIndices`: array indices to highlight (current positions)
   - `previousIndices`: previous positions for comparison
   - `explanation`: step-by-step explanation text
   - `removedIndices` (optional): indices to render as struck-through/removed, e.g. a deleted linked-list node
   - `valuesOverride` (optional): overrides the base `values` for this step, for algorithms that physically rearrange data in place (sorting swaps, heap sift)

3. **Add a pointer/cursor label case.** `lib/utils/pointer_labels.dart` maps an algorithm id + step to labels like L/R, Slow/Fast, Mid, Top — add a `case` for the new algorithm id so Simulation and Review show consistent labels.

4. **Add a 15-question quiz bank entry** in `lib/data/quiz_data.dart` (see below) and an icon mapping in `lib/screens/algorithm_list_screen.dart`'s `_icons` map.

### Adding a New Interactive Review

Review needs no new data of its own — `lib/widgets/algorithm_review.dart` steps through the same `AlgorithmVisualization.steps` used by Simulation and validates taps against `highlightIndices`, so anything added in "Adding a New Simulation" above automatically gets a working Review tab.

### Adding a Quiz Question Bank

To add the 15-question quiz for a new algorithm (e.g. `sliding_window`):

1. **Open `lib/data/quiz_data.dart`**
2. **Add a `static const` list of `QuizQuestion`s** (see the existing `_twoPointers` list for the format: `question`, `options`, `correctIndex`, `explanation`) and register it in the `_bank` map keyed by the algorithm's `id`.

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

### Adding a New Fundamentals Concept (System Design theory)

To add a new theory topic (e.g. a new networking or consistency concept):

1. **Open `lib/data/fundamentals_data.dart`.**
2. **Add a `FundamentalConcept`** to an existing category list (e.g. `_networking`, `_databases`) or create a new `static const` list for a new category, and add it to `getConcepts()`.
   ```dart
   FundamentalConcept(
     id: 'my_new_concept',
     category: 'Networking',
     title: 'My New Concept',
     summary: 'A short paragraph explaining the idea and why it matters...',
     keyPoints: [
       'A punchy, concrete takeaway',
       'Another one, ideally with an interview-framing angle',
     ],
     // Optional: a pre-drawn diagram using the same components as the design canvas.
     diagram: ReferenceArchitecture(
       components: [ComponentType.client, ComponentType.apiServer],
       connections: [(ComponentType.client, ComponentType.apiServer)],
     ),
     diagramCaption: 'One sentence describing what the diagram shows.',
   ),
   ```
3. **Diagrams are optional** — plenty of existing concepts (CAP Theorem, ACID vs BASE, SQL vs NoSQL) are text-only. Only add one when there's a clear component/connection flow to illustrate; `ArchitectureDiagram` positions components by first index of each `ComponentType`, so a diagram can't use the same type twice.
4. Fundamentals concepts don't need quiz questions or a Simulation/Review — they're theory-only, rendered by `fundamental_detail_screen.dart`.

### Adding a New System Design Practice Problem

To add a new case study (e.g. "Design a Chat App"):

1. **Open `lib/data/system_design_data.dart`.**
2. **Add a `SystemDesignProblem`** with `id`, `title`, `difficulty`, `prompt`, `functionalRequirements`, `nonFunctionalRequirements`, `capacityEstimation`, `apiDesign`, `highLevelDesign`, and a `reference` `ReferenceArchitecture` (the component types and type-to-type connections the Design Canvas's "Check Design" validates against — checked structurally, not by exact position, so there's no single "correct" layout to guess).
3. **New component types** (beyond the existing `ComponentType` enum in `lib/models/system_design.dart`: Client, Load Balancer, API Server, Database, Cache, CDN, Message Queue, Object Storage, ID Generator) require adding a new enum value with a label and icon — keep the palette small and generic rather than one-off per problem.

## ⚙️ Important Configurations

### App Configuration
- **App Name**: AllGoldRhythm
- **Package Name**: allgoldrhythm
- **Version**: 1.0.0+1
- **Minimum SDK**: Flutter 3.8.1+

### Theme Configuration
Theming lives in `lib/theme/app_theme.dart`, not inline in `main.dart`: `AppTheme.light()` / `AppTheme.dark()` build a Material 3 `ThemeData` from a shared amber seed color, wired via `MaterialApp(theme:, darkTheme:, themeMode: ThemeMode.system)` in `lib/main.dart` so the app follows the device's light/dark setting automatically. Spacing and corner-radius values are centralized as design tokens (`AppSpacing.xs/sm/md/lg/xl`, `AppRadius.sm/md/lg`) rather than repeated as raw numbers across widgets, and an `AppSemanticColors` theme extension (`context.appColors`) covers values that don't map onto a standard `ColorScheme` role, like a fixed code-block background and a success color for correct-answer feedback.

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

- **Visual Simulations**: Step-by-step algorithm visualizations with real data values and pointer/cursor labels (L/R, Slow/Fast, Mid, ...)
- **Interactive Learning**: Tap-to-validate Review mode that steps through the same trace as Simulation, plus a 15-question quiz per algorithm
- **System Design Fundamentals**: Theory concepts across networking, APIs, load balancing, caching, databases, scaling, consistency, async processing, rate limiting, storage, security, search, notifications, and geospatial indexing — each with an optional pre-drawn architecture diagram
- **Drag-and-Drop Design Canvas**: Sketch a system architecture yourself (place components, connect them, pan/zoom) and check it against a reference solution for full interview-style practice problems
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
