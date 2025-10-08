import 'dart:async';
import 'dart:isolate';

class TimerService {
  Isolate? _isolate;
  SendPort? _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  final StreamController<Map<String, dynamic>> _controller = StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _controller.stream;

  Future<void> start() async {
    if (_isolate != null) return;

    _isolate = await Isolate.spawn(_isolateEntryPoint, _receivePort.sendPort);
    _receivePort.listen(_handleMessage);
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
    } else if (message is Map<String, dynamic>) {
      _controller.add(message);
    }
  }

  void addTimer(Map<String, dynamic> timerData) {
    _sendPort?.send({'command': 'add', 'timer': timerData});
  }

  void pauseTimer(String timerId) {
    _sendPort?.send({'command': 'pause', 'id': timerId});
  }

  void removeTimer(String timerId) {
    _sendPort?.send({'command': 'remove', 'id': timerId});
  }

  void dispose() {
    _sendPort?.send({'command': 'dispose'});
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _controller.close();
  }
}

void _isolateEntryPoint(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  final _activeTimers = <String, int>{}; // Map<timerId, remainingSeconds>
  Timer? _ticker;

  void startTicker() {
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
          sendPort.send({'id': id, 'remainingTime': newRemainingTime});
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

  receivePort.listen((message) {
    final command = message['command'];
    switch (command) {
      case 'add':
        final timerData = message['timer'] as Map<String, dynamic>;
        final id = timerData['id'] as String;
        final remainingTime = timerData['remainingTime'] as int;
        _activeTimers[id] = remainingTime;
        startTicker();
        break;
      case 'pause':
      case 'remove':
        final id = message['id'] as String;
        _activeTimers.remove(id);
        break;
      case 'dispose':
        for (var timer in _activeTimers.values) {
          _ticker?.cancel();
        }
        _activeTimers.clear();
        receivePort.close();
        break;
    }
  });
}