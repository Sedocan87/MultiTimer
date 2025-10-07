import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/notification_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timer_provider.g.dart';

const _uuid = Uuid();

@riverpod
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
  }) {
    final newTimer = TimerModel(
      id: _uuid.v4(),
      name: name,
      totalDuration: duration,
      remainingTime: duration,
      color: color,
      status: TimerStatus.initial,
    );
    state = [...state, newTimer];
  }

  void startTimer(String timerId) {
    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1) return;

    final timer = state[timerIndex];
    if (timer.status == TimerStatus.running) return;

    _activeTimers[timerId]?.cancel();

    _activeTimers[timerId] = Timer.periodic(const Duration(seconds: 1), (ticker) {
      final currentTimer = state.firstWhere((t) => t.id == timerId);
      if (currentTimer.remainingTime.inSeconds > 0) {
        final newRemainingTime = currentTimer.remainingTime - const Duration(seconds: 1);
        state = [
          for (final t in state)
            if (t.id == timerId)
              t.copyWith(remainingTime: newRemainingTime, status: TimerStatus.running)
            else
              t,
        ];
      } else {
        ticker.cancel();
        _activeTimers.remove(timerId);
        state = [
          for (final t in state)
            if (t.id == timerId) t.copyWith(status: TimerStatus.finished) else t,
        ];
        ref.read(notificationServiceProvider).showNotification(
          id: timerId.hashCode,
          title: 'Timer Finished!',
          body: 'Your timer "${currentTimer.name}" is done.',
        );
      }
    });
  }

  void pauseTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);

    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(status: TimerStatus.paused) else t,
    ];
  }

  void resetTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);

    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1) return;

    final originalDuration = state[timerIndex].totalDuration;
    state = [
        for (final t in state)
            if (t.id == timerId) t.copyWith(remainingTime: originalDuration, status: TimerStatus.initial) else t,
    ];
  }

  void removeTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);
    state = state.where((timer) => timer.id != timerId).toList();
  }
}
