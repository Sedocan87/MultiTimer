import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parallel_timers/main.dart';
import 'package:parallel_timers/services/notification_service.dart';


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

void main() {
  testWidgets('HomeScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: const MyApp(),
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