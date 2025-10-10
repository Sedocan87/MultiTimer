import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'mocks/mock_notification_service.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    final directory = await Directory.systemTemp.createTemp();
    return directory.path;
  }
}

Future<void> _loadMaterialIconFont() async {
  final fontLoader = FontLoader('MaterialIcons');
  fontLoader.addFont(rootBundle.load('assets/fonts/MaterialIcons-Regular.otf'));
  await fontLoader.load();
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    notificationService = MockNotificationService();
    await _loadMaterialIconFont();
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

  testWidgets('Take screenshot', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('goldens/main_screen.png'),
    );
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('goldens/templates_screen.png'),
    );
  });
}