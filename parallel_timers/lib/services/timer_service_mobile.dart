import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:parallel_timers/services/notification_service.dart';

class TimerService {
  Isolate? _isolate;
  SendPort? _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

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
    debugPrint('TimerService: Adding timer: $timerData');
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

  final activeTimers = <String, Map<String, dynamic>>{}; // Map<timerId, {name: string, remainingTime: int}>
  Timer? ticker;

  void startTicker() {
    if (ticker != null && ticker!.isActive) return;
    ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (activeTimers.isEmpty) {
        ticker?.cancel();
        ticker = null;
        return;
      }

      final List<String> completedTimers = [];
      activeTimers.forEach((id, timerData) {
        final remainingTime = timerData['remainingTime'] as int;
        final newRemainingTime = remainingTime - 1;
        if (newRemainingTime >= 0) {
          timerData['remainingTime'] = newRemainingTime;
          sendPort.send({'id': id, 'remainingTime': newRemainingTime});
        }
        if (newRemainingTime <= 0) {
          completedTimers.add(id);
          sendPort.send({'id': id, 'completed': true, 'name': timerData['name']});
        }
      });

      for (var id in completedTimers) {
        activeTimers.remove(id);
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
        activeTimers[id] = {
          'name': timerData['name'],
          'remainingTime': remainingTime,
        };
        startTicker();
        break;
      case 'pause':
        // For now, pause is treated the same as remove.
        // This can be changed later to support resume.
        final id = message['id'] as String;
        activeTimers.remove(id);
        break;
      case 'remove':
        final id = message['id'] as String;
        activeTimers.remove(id);
        break;
      case 'dispose':
        ticker?.cancel();
        activeTimers.clear();
        receivePort.close();
        break;
    }
  });
}