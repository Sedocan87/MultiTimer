import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  // This provider is overridden in main.dart, so this implementation is never used.
  throw UnimplementedError();
});