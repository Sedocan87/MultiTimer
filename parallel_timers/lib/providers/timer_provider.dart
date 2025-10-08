import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parallel_timers/models/sequence_model.dart';
import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/sequence_provider.dart';
import 'package:parallel_timers/providers/timer_history_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timer_provider.g.dart';

const _uuid = Uuid();

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

  void addTimerFromSequence(TimerSequence sequence) {
    if (state.any((t) => t.sequenceId == sequence.id)) return;

    final firstTimer = sequence.timers.first;
    final newTimer = TimerModel(
      id: _uuid.v4(),
      name: sequence.name,
      duration: firstTimer.duration,
      remainingTime: firstTimer.duration,
      color: sequence.color,
      icon: sequence.icon,
      isSequence: true,
      sequenceId: sequence.id,
      isRunning: false,
    );

    state = [...state, newTimer];
    startTimer(newTimer.id);
  }

  void addTimer({
    required String name,
    required Duration duration,
    required Color color,
    required IconData icon,
    List<int>? vibrationPattern,
    bool isRunning = false,
    TimerCompleteCallback? onComplete,
  }) {
    final newTimer = TimerModel(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      remainingTime: duration,
      color: color,
      icon: icon,
      vibrationPattern: vibrationPattern,
      isRunning: false,
      onComplete: onComplete,
    );
    state = [...state, newTimer];
    if (isRunning) {
      startTimer(newTimer.id);
    }
  }

  void startTimer(String timerId) {
    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1 || state[timerIndex].isRunning) return;

    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: true) else t
    ];
    _startTicker(timerId);
  }

  void _startTicker(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers[timerId] =
        Timer.periodic(const Duration(seconds: 1), (ticker) {
      try {
        final currentTimer = state.firstWhere((t) => t.id == timerId);
        if (currentTimer.remainingTime.inSeconds > 0) {
          state = [
            for (final t in state)
              if (t.id == timerId)
                t.copyWith(
                    remainingTime: t.remainingTime - const Duration(seconds: 1))
              else
                t
          ];
        } else {
          ticker.cancel();
          _activeTimers.remove(timerId);
          if (currentTimer.isSequence) {
            _handleSequenceStepCompletion(currentTimer);
          } else {
            currentTimer.onComplete?.call();
            final history = TimerHistory(
              id: currentTimer.id,
              name: currentTimer.name,
              duration: currentTimer.duration,
              completedAt: DateTime.now(),
            );
            ref
                .read(timerHistoryNotifierProvider.notifier)
                .addTimerHistory(history);
            removeTimer(currentTimer.id);
          }
        }
      } catch (e) {
        ticker.cancel();
        _activeTimers.remove(timerId);
      }
    });
  }

  void _handleSequenceStepCompletion(TimerModel completedTimer) {
    final sequenceId = completedTimer.sequenceId!;
    ref
        .read(sequenceNotifierProvider.notifier)
        .onSequenceTimerCompleted(sequenceId);

    final updatedSequences = ref.read(sequenceNotifierProvider);
    final updatedSequence =
        updatedSequences.firstWhere((s) => s.id == sequenceId);

    if (updatedSequence.isRunning) {
      final nextTimerInfo =
          updatedSequence.timers[updatedSequence.currentTimerIndex];
      final updatedTimerModel = completedTimer.copyWith(
        duration: nextTimerInfo.duration,
        remainingTime: nextTimerInfo.duration,
        isRunning: true,
      );
      state = [
        for (final t in state)
          if (t.id == completedTimer.id) updatedTimerModel else t
      ];
      _startTicker(completedTimer.id);
    } else {
      final history = TimerHistory(
        id: updatedSequence.id,
        name: updatedSequence.name,
        duration: updatedSequence.totalDuration,
        completedAt: DateTime.now(),
      );
      ref
          .read(timerHistoryNotifierProvider.notifier)
          .addTimerHistory(history);
      removeTimerBySequenceId(sequenceId);
    }
  }

  void pauseTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);
    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: false) else t
    ];
  }

  void removeTimer(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);
    state = state.where((timer) => timer.id != timerId).toList();
  }

  void removeTimerBySequenceId(String sequenceId) {
    try {
      final timer = state.firstWhere((t) => t.sequenceId == sequenceId);
      removeTimer(timer.id);
    } catch (e) {
      // Timer not found, do nothing
    }
  }
}