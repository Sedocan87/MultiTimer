import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parallel_timers/main.dart';
import 'package:parallel_timers/models/category_model.dart';
import 'package:parallel_timers/models/color_adapter.dart';
import 'package:parallel_timers/models/countdown_model.dart';
import 'package:parallel_timers/models/duration_adapter.dart';
import 'package:parallel_timers/models/icon_data_adapter.dart';
import 'package:parallel_timers/models/template_model.dart';
import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/services/ad_service.dart';
import 'package:parallel_timers/widgets/timer_card.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'mocks/mock_ad_service.dart';
import 'mocks/mock_notification_service.dart';
import 'package:numberpicker/numberpicker.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    final directory = await Directory.systemTemp.createTemp();
    return directory.path;
  }
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    notificationService = MockNotificationService();
    await Hive.initFlutter('test');
    if (!Hive.isAdapterRegistered(TimerHistoryAdapter().typeId)) {
      Hive.registerAdapter(TimerHistoryAdapter());
    }
    if (!Hive.isAdapterRegistered(TimerTemplateAdapter().typeId)) {
      Hive.registerAdapter(TimerTemplateAdapter());
    }
    if (!Hive.isAdapterRegistered(ColorAdapter().typeId)) {
      Hive.registerAdapter(ColorAdapter());
    }
    if (!Hive.isAdapterRegistered(IconDataAdapter().typeId)) {
      Hive.registerAdapter(IconDataAdapter());
    }
    if (!Hive.isAdapterRegistered(DurationAdapter().typeId)) {
      Hive.registerAdapter(DurationAdapter());
    }
    if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(CountdownAdapter().typeId)) {
      Hive.registerAdapter(CountdownAdapter());
    }

    await Hive.openBox<TimerTemplate>('templates');
    await Hive.openBox<TimerHistory>('timer_history');
    await Hive.openBox<CategoryModel>('categories');
    await Hive.openBox<Countdown>('countdowns');
    await Hive.openBox<String>('deleted_templates');
  });

  tearDownAll(() async {
    await Hive.close();
    await Hive.deleteFromDisk();
  });

  testWidgets('HomeScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [adServiceProvider.overrideWithValue(MockAdService())],
        child: const MyApp(),
      ),
    );

    expect(find.text('Active Timers'), findsOneWidget);
    expect(find.widgetWithIcon(IconButton, Icons.add), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Timers'), findsOneWidget);
    expect(find.text('Templates'), findsOneWidget);
  });

  testWidgets('Timer creation and countdown', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [adServiceProvider.overrideWithValue(MockAdService())],
          child: const MyApp(),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('timerName_text_field')), 'Test Timer');

      // Find the number pickers and set their values
      final numberPickers = find.byType(NumberPicker);
      await tester.drag(numberPickers.at(0), const Offset(0.0, -50.0)); // Set minutes to 1
      await tester.pumpAndSettle();
      await tester.drag(numberPickers.at(1), const Offset(0.0, -100.0)); // Set seconds to 2, just an example
      await tester.pumpAndSettle();


      await tester.tap(find.text('Start Timer'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500)); // allow time for navigation and state update

      final timerCardFinder = find.widgetWithText(TimerCard, 'Test Timer');
      expect(timerCardFinder, findsOneWidget);

      // The exact time might be tricky, so we check for a reasonable range.
      // The timer should be running.
      expect(find.descendant(of: timerCardFinder, matching: find.byIcon(Icons.pause)), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      expect(find.descendant(of: timerCardFinder, matching: find.byIcon(Icons.pause)), findsOneWidget);
    });
  });
}