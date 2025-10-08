import 'dart:async';

class TimerService {
  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();
  final _activeTimers = <String, int>{};
  Timer? _ticker;

  Stream<Map<String, dynamic>> get messages => _controller.stream;

  Future<void> start() async {
    // No-op for web
  }

  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      _controller.add(message);
    }
  }

  void addTimer(Map<String, dynamic> timerData) {
    final id = timerData['id'] as String;
    final remainingTime = timerData['remainingTime'] as int;
    _activeTimers[id] = remainingTime;
    _startTicker();
  }

  void pauseTimer(String timerId) {
    _activeTimers.remove(timerId);
  }

  void removeTimer(String timerId) {
    _activeTimers.remove(timerId);
  }

  void dispose() {
    _ticker?.cancel();
    _controller.close();
  }

  void _startTicker() {
    if (_ticker != null && _ticker!.isActive) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_activeTimers.isEmpty) {
        _ticker?.cancel();
        _ticker = null;
        return;
      }

      final List<String> completedTimers = [];
      _activeTimers.forEach((id, remainingTime) {
        final newRemainingTime = remainingTime - 1;
        if (newRemainingTime >= 0) {
          _activeTimers[id] = newRemainingTime;
          _controller.add({'id': id, 'remainingTime': newRemainingTime});
        }
        if (newRemainingTime <= 0) {
          completedTimers.add(id);
        }
      });

      for (var id in completedTimers) {
        _activeTimers.remove(id);
      }
    });
  }
}
