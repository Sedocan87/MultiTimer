class NotificationService {
  Future<void> init() async {}

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    List<int>? vibrationPattern,
  }) async {}
}