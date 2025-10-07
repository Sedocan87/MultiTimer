import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/notification_provider.dart';
import 'package:parallel_timers/services/timer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timer_provider.g.dart';

const _uuid = Uuid();

@riverpod
@Riverpod(keepAlive: true)
class TimerNotifier extends _$TimerNotifier {
  late final TimerService _timerService;

  @override
  List<TimerModel> build() {
    _timerService = TimerService(
      onUpdate: (timerId, remainingTime) {
        state = [
          for (final timer in state)
            if (timer.id == timerId)
              timer.copyWith(remainingTime: remainingTime)
            else
              timer,
        ];
      },
      onFinish: (timerId, name) {
        final finishedTimer = state.firstWhere((t) => t.id == timerId);
        state = [
          for (final timer in state)
            if (timer.id == timerId) timer.copyWith(isRunning: false) else timer,
        ];
        ref.read(notificationServiceProvider).showNotification(
              id: timerId.hashCode,
              title: 'Timer Finished!',
              body: 'Your timer "$name" is done.',
              vibrationPattern: finishedTimer.vibrationPattern,
            );
      },
    );

    ref.onDispose(() {
      _timerService.dispose();
    });

    return [];
  }

  void addTimer({
    required String name,
    required Duration duration,
    required Color color,
    required IconData icon,
    Int64List? vibrationPattern,
    bool isRunning = false,
  }) {
    final newTimer = TimerModel(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      remainingTime: duration,
      color: color,
      icon: icon,
      isRunning: false,
      vibrationPattern: vibrationPattern,
    );
    state = [...state, newTimer];
    if (isRunning) {
      startTimer(newTimer.id);
    }
  }

  void startTimer(String timerId) {
    final timer = state.firstWhere((t) => t.id == timerId);
    if (timer.isRunning) return;

    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: true) else t,
    ];

    _timerService.startTimer(timer);
  }

  void pauseTimer(String timerId) {
    _timerService.pauseTimer(timerId);

    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: false) else t,
    ];
  }

  void removeTimer(String timerId) {
    _timerService.pauseTimer(timerId);
    state = state.where((timer) => timer.id != timerId).toList();
  }
}