import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parallel_timers/main.dart';
import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/services/notification_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// A mock notification service to use in tests
class MockNotificationService implements NotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    List<int>? vibrationPattern,
  }) async {}
}

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
    await Hive.initFlutter('test');
    Hive.registerAdapter(TimerHistoryAdapter());
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('HomeScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the new header is displayed.
    expect(find.text('Active Timers'), findsOneWidget);

    // Verify that the "add" icon button is displayed in the header.
    expect(find.widgetWithIcon(IconButton, Icons.add), findsOneWidget);

    // Verify that the bottom navigation bar is displayed.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify that the "Timers" and "Templates" labels are present.
    expect(find.text('Timers'), findsOneWidget);
    expect(find.text('Templates'), findsOneWidget);
  });
}