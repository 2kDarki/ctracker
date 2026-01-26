import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/change_record.dart';
import 'stores/change_record_store.dart';
import 'screens/home_screen.dart';
import 'screens/add_record_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ChangeRecordAdapter());

  final store = await ChangeRecordStore.create();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('darkMode') ?? false;
  ThemeModeNotifier.instance.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(
    ChangeNotifierProvider<ChangeRecordStore>.value(
      value: store,
      child: const ChangeTrackerApp(),
    ),
  );
}

/// Global notifier for dynamic theme switching
class ThemeModeNotifier {
  ThemeModeNotifier._();
  static final instance = ValueNotifier<ThemeMode>(ThemeMode.light);
}

class ChangeTrackerApp extends StatelessWidget {
  const ChangeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeModeNotifier.instance,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'cTracker',
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 13, 185, 7),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
              outline: Color(0xFFE2E8F0),
              error: Color(0xFFDC2626),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 13, 185, 7),
              onPrimary: Color(0xFF020617),
              surface: Color(0xFF020617),
              onSurface: Color(0xFFE5E7EB),
              outline: Color(0xFF1E293B),
              error: Color(0xFFF87171),
            ),
            scaffoldBackgroundColor: const Color(0xFF020617),
          ),
          home: const HomeScreen(),
          routes: {
            '/add': (_) => const AddRecordScreen(),
            '/settings': (_) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
