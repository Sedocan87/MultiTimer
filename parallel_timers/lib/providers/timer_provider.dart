import 'package:flutter/material.dart';
import 'package:parallel_timers/models/finished_timer_model.dart';
import 'package:parallel_timers/models/sequence_model.dart';
import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/finished_timer_provider.dart';
import 'package:parallel_timers/providers/sequence_provider.dart';
import 'package:parallel_timers/providers/timer_history_provider.dart';
import 'package:parallel_timers/services/notification_service.dart';
import 'package:parallel_timers/services/timer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timer_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
class TimerNotifier extends _$TimerNotifier {
  late final TimerService _timerService;
  late final NotificationService _notificationService;

  @override
  List<TimerModel> build() {
    _timerService = TimerService();
    _notificationService = NotificationService();
    Future.microtask(() async {
      await _timerService.start();
      _timerService.messages.listen(_handleIsolateMessage);
    });

    ref.onDispose(() {
      _timerService.dispose();
    });
    return [];
  }

  void _handleIsolateMessage(Map<String, dynamic> message) {
    if (message.containsKey('completed')) {
      final timerId = message['id'] as String;
      final timerName = message['name'] as String;
      _notificationService.showNotification(
        id: timerId.hashCode,
        title: 'Timer Finished',
        body: '$timerName has finished.',
      );
      final timerIndex = state.indexWhere((t) => t.id == timerId);
      if (timerIndex != -1) {
        _handleTimerCompletion(state[timerIndex]);
      }
    } else {
      final timerId = message['id'] as String;
      final remainingTime = message['remainingTime'] as int;

      // Use indexWhere to safely find the timer without throwing an error
      final timerIndex = state.indexWhere((t) => t.id == timerId);

      // Check if the timer still exists in our state
      if (timerIndex != -1) {
        final currentTimer = state[timerIndex];
        if (remainingTime > 0) {
          // If the timer is still running, update its remaining time
          state = [
            for (final t in state)
              if (t.id == timerId)
                t.copyWith(remainingTime: Duration(seconds: remainingTime))
              else
                t,
          ];
        } else {
          // If the timer has finished, call the completion handler
          _handleTimerCompletion(currentTimer);
        }
      }
    }
    // If timerIndex is -1, it means the timer was already removed, so we do nothing.
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
      isRunning: true,
    );

    state = [...state, newTimer];
    _timerService.addTimer({
      'id': newTimer.id,
      'remainingTime': newTimer.remainingTime.inSeconds,
    });
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
    debugPrint('Adding timer: $name, duration: $duration');
    final newTimer = TimerModel(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      remainingTime: duration,
      color: color,
      icon: icon,
      vibrationPattern: vibrationPattern,
      isRunning: isRunning,
      onComplete: onComplete,
    );
    state = [...state, newTimer];
    if (isRunning) {
      _timerService.addTimer({
        'id': newTimer.id,
        'name': newTimer.name,
        'remainingTime': newTimer.remainingTime.inSeconds,
      });
    }
  }

  void startTimer(String timerId) {
    final timerIndex = state.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1 || state[timerIndex].isRunning) return;

    final timer = state[timerIndex];
    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: true) else t,
    ];
    _timerService.addTimer({
      'id': timer.id,
      'remainingTime': timer.remainingTime.inSeconds,
    });
  }

  void _handleTimerCompletion(TimerModel completedTimer) {
    if (completedTimer.isSequence) {
      _handleSequenceStepCompletion(completedTimer);
    } else {
      completedTimer.onComplete?.call();
      final history = TimerHistory(
        id: completedTimer.id,
        name: completedTimer.name,
        duration: completedTimer.duration,
        completedAt: DateTime.now(),
      );
      ref.read(timerHistoryNotifierProvider.notifier).addTimerHistory(history);
      final finishedTimer = FinishedTimerModel(
        timer: completedTimer,
        finishedAt: DateTime.now(),
      );
      ref
          .read(finishedTimerNotifierProvider.notifier)
          .addFinishedTimer(finishedTimer);
      removeTimer(completedTimer.id);
    }
  }

  void _handleSequenceStepCompletion(TimerModel completedTimer) {
    final sequenceId = completedTimer.sequenceId!;
    ref
        .read(sequenceNotifierProvider.notifier)
        .onSequenceTimerCompleted(sequenceId);

    final updatedSequences = ref.read(sequenceNotifierProvider);
    final updatedSequence = updatedSequences.firstWhere(
      (s) => s.id == sequenceId,
    );

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
          if (t.id == completedTimer.id) updatedTimerModel else t,
      ];
      _timerService.addTimer({
        'id': updatedTimerModel.id,
        'remainingTime': updatedTimerModel.remainingTime.inSeconds,
      });
    } else {
      final history = TimerHistory(
        id: updatedSequence.id,
        name: updatedSequence.name,
        duration: updatedSequence.totalDuration,
        completedAt: DateTime.now(),
      );
      ref.read(timerHistoryNotifierProvider.notifier).addTimerHistory(history);
      final finishedTimer = FinishedTimerModel(
        timer: completedTimer,
        finishedAt: DateTime.now(),
      );
      ref
          .read(finishedTimerNotifierProvider.notifier)
          .addFinishedTimer(finishedTimer);
      removeTimerBySequenceId(sequenceId);
    }
  }

  void pauseTimer(String timerId) {
    _timerService.pauseTimer(timerId);
    state = [
      for (final t in state)
        if (t.id == timerId) t.copyWith(isRunning: false) else t,
    ];
  }

  void removeTimer(String timerId) {
    _timerService.removeTimer(timerId);
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
