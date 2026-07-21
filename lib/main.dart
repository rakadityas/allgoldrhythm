import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/progress_store.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progressStore = await ProgressStore.create();
  runApp(MyApp(progressStore: progressStore));
}

class MyApp extends StatelessWidget {
  final ProgressStore progressStore;

  const MyApp({super.key, required this.progressStore});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProgressStore>.value(
      value: progressStore,
      child: MaterialApp(
        title: 'AllGoldRhythm',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
