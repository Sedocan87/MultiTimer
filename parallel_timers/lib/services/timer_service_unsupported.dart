import 'dart:async';

class TimerService {
  Stream<Map<String, dynamic>> get messages => const Stream.empty();

  Future<void> start() async {}

  void addTimer(Map<String, dynamic> timerData) {}

  void pauseTimer(String timerId) {}

  void removeTimer(String timerId) {}

  void dispose() {}
}
