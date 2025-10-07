import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/notification_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timer_provider.g.dart';

const _uuid = Uuid();

@riverpod
@Riverpod(keepAlive: true)
class TimerNotifier extends _$TimerNotifier {
  final Map<String, Timer> _activeTimers = {};

  @override
  List<TimerModel> build() {
    ref.onDispose(() {
      for (var timer in _activeTimers.values) {
        timer.cancel();
      }
    });
    return [];
  }

  void addTimer({
    required String name,
    required Duration duration,
    required Color color,
    required IconData icon,
    bool isRunning = false,
  }) {
    final newTimer = TimerModel(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      remainingTime: duration,
      color: color,
      icon: icon,
      isRunning: false, // Start as not running, then start if needed
      stopwatch: Stopwatch(),
    );
    state = [...state, newTimer];
    if (isRunning) {
      startTimer(newTimer.id);
    }
  }

  void startTimer(String timerId) {
    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1) return;

    final timer = state[timerIndex];
    if (timer.isRunning) return;

    // Set isRunning to true immediately
    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: true) else t,
    ];

    _activeTimers[timerId]?.cancel();

    _activeTimers[timerId] = Timer.periodic(const Duration(seconds: 1), (
      ticker,
    ) {
      // Use a try-catch block to handle cases where the timer is removed while the ticker is active
      try {
        final currentTimer = state.firstWhere((t) => t.id == timerId);

        if (currentTimer.remainingTime.inSeconds > 0) {
          final newRemainingTime =
              currentTimer.duration -
              currentTimer.stopwatch.elapsed -
              const Duration(seconds: 1);
          state = [
            for (final t in state)
              if (t.id == timerId)
                t.copyWith(remainingTime: newRemainingTime)
              else
                t,
          ];
        } else {
          ticker.cancel();
          _activeTimers.remove(timerId);
          state = [
            for (final t in state)
              if (t.id == timerId) t.copyWith(isRunning: false) else t,
          ];
          ref
              .read(notificationServiceProvider)
              .showNotification(
                id: timerId.hashCode,
                title: 'Timer Finished!',
                body: 'Your timer "${currentTimer.name}" is done.',
              );
        }
      } catch (e) {
        // Timer was likely removed, so cancel the ticker
        ticker.cancel();
        _activeTimers.remove(timerId);
      }
    });
    state[timerIndex].stopwatch.start();
  }

  void pauseTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);

    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex != -1) {
      state[timerIndex].stopwatch.stop();
    }

    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: false) else t,
    ];
  }

  void removeTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);
    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex != -1) {
      state[timerIndex].stopwatch.stop();
    }
    state = state.where((timer) => timer.id != timerId).toList();
  }
}
