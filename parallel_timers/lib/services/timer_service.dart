import 'dart:async';
import 'dart:isolate';
import 'package:parallel_timers/models/timer_model.dart';

// --- Isolate Communication Classes ---

class _StartTimerCommand {
  final String id;
  final String name;
  final Duration remaining;

  _StartTimerCommand({
    required this.id,
    required this.name,
    required this.remaining,
  });
}

class _PauseTimerCommand {
  final String timerId;
  _PauseTimerCommand(this.timerId);
}

class _DisposeCommand {}

// --- Isolate Entry Point ---

void _timerIsolateEntrypoint(SendPort mainSendPort) async {
  final isolateReceivePort = ReceivePort();
  mainSendPort.send(isolateReceivePort.sendPort);

  final activeTimers = <String, Timer>{};
  final stopwatches = <String, Stopwatch>{};

  await for (final message in isolateReceivePort) {
    if (message is _StartTimerCommand) {
      activeTimers[message.id]?.cancel();

      final stopwatch = Stopwatch()..start();
      stopwatches[message.id] = stopwatch;

      activeTimers[message.id] =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        if (stopwatch.elapsed < message.remaining) {
          final newRemaining = message.remaining - stopwatch.elapsed;
          mainSendPort.send({'id': message.id, 'remaining': newRemaining});
        } else {
          timer.cancel();
          activeTimers.remove(message.id);
          stopwatches.remove(message.id);
          mainSendPort.send(
              {'id': message.id, 'finished': true, 'name': message.name});
        }
      });
    } else if (message is _PauseTimerCommand) {
      activeTimers[message.timerId]?.cancel();
      activeTimers.remove(message.timerId);
      stopwatches[message.timerId]?.stop();
      stopwatches.remove(message.timerId);
    } else if (message is _DisposeCommand) {
      for (final timer in activeTimers.values) {
        timer.cancel();
      }
      isolateReceivePort.close();
      break;
    }
  }
}

// --- Timer Service ---

class TimerService {
  final Function(String timerId, Duration remainingTime) onUpdate;
  final Function(String timerId, String name) onFinish;

  SendPort? _isolateSendPort;
  Isolate? _isolate;
  ReceivePort? _mainReceivePort;

  TimerService({required this.onUpdate, required this.onFinish}) {
    _initIsolate();
  }

  Future<void> _initIsolate() async {
    _mainReceivePort = ReceivePort();
    _isolate =
        await Isolate.spawn(_timerIsolateEntrypoint, _mainReceivePort!.sendPort);

    _mainReceivePort!.listen((message) {
      if (message is SendPort) {
        _isolateSendPort = message;
      } else if (message is Map) {
        final id = message['id'] as String;
        if (message['finished'] == true) {
          final name = message['name'] as String;
          onFinish(id, name);
        } else {
          final remaining = message['remaining'] as Duration;
          onUpdate(id, remaining);
        }
      }
    });
  }

  void startTimer(TimerModel timer) {
    _isolateSendPort?.send(_StartTimerCommand(
      id: timer.id,
      name: timer.name,
      remaining: timer.remainingTime,
    ));
  }

  void pauseTimer(String timerId) {
    _isolateSendPort?.send(_PauseTimerCommand(timerId));
  }

  void dispose() {
    _isolateSendPort?.send(_DisposeCommand());
    _mainReceivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}