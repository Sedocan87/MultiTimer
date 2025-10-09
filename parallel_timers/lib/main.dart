import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parallel_timers/models/category_model.dart';
import 'package:parallel_timers/models/color_adapter.dart';
import 'package:parallel_timers/models/duration_adapter.dart';
import 'package:parallel_timers/models/icon_data_adapter.dart';
import 'package:parallel_timers/models/template_model.dart';
import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/screens/main_screen.dart';

Future<void> _initializeHiveBoxes() async {
  // Open templates box with recovery and data validation
  try {
    var box = await Hive.openBox<TimerTemplate>('templates');

    // Validate existing templates and remove corrupted ones
    List<String> keysToDelete = [];
    for (var key in box.keys) {
      try {
        var template = box.get(key);
        if (template == null) {
          keysToDelete.add(key.toString());
        }
      } catch (e) {
        keysToDelete.add(key.toString());
        debugPrint('Found corrupted template at key $key: $e');
      }
    }

    // Delete corrupted templates
    if (keysToDelete.isNotEmpty) {
      debugPrint('Removing ${keysToDelete.length} corrupted templates');
      await Future.forEach(keysToDelete, (key) async => await box.delete(key));
    }

    debugPrint(
      'Templates box opened successfully with ${box.length} valid items',
    );
  } catch (e) {
    debugPrint('Error opening templates box: $e');
    // If box is corrupted, delete and recreate
    await Hive.deleteBoxFromDisk('templates');
    await Hive.openBox<TimerTemplate>('templates');
    debugPrint('Templates box recreated successfully');
  }

  // Open other boxes with error handling
  try {
    await Hive.openBox<String>('deleted_templates');
    await Hive.openBox<CategoryModel>('categories');
    debugPrint('All Hive boxes opened successfully');
  } catch (e) {
    debugPrint('Error opening additional boxes: $e');
    rethrow;
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();

    // Register all adapters
    Hive.registerAdapter(TimerHistoryAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(TimerTemplateAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(IconDataAdapter());
    Hive.registerAdapter(CategoryModelAdapter());

    // Open boxes with error handling
    await _initializeHiveBoxes();

    // Initialize Google Mobile Ads with error handling
    if (!kIsWeb) {
      try {
        await MobileAds.instance.initialize();
      } catch (e) {
        debugPrint('Failed to initialize Mobile Ads: $e');
        // Continue app initialization even if ads fail
      }
    }

    // Run app inside a try-catch to catch any initialization errors
    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    // Rethrow to show error screen instead of black screen
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallel Timers',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121B2A),
        primaryColor: const Color(0xFF121B2A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3D82F5),
          secondary: Color(0xFF3D82F5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121B2A),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
