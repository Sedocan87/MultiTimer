import 'package:parallel_timers/services/notification_service.dart';

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

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}
}