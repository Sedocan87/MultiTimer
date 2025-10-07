import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:parallel_timers/providers/notification_provider.dart';
import 'package:parallel_timers/screens/home_screen.dart';
import 'package:parallel_timers/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  // Create and initialize the notification service
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const MyApp(),
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
      home: const HomeScreen(),
    );
  }
}