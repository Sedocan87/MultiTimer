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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TimerHistoryAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(TimerTemplateAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(IconDataAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<TimerTemplate>('templates');
  await Hive.openBox<String>('deleted_templates');
  await Hive.openBox<CategoryModel>('categories');

  // Initialize Google Mobile Ads
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
