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
  Map<String, TimerModel> build() {
    _timerService = TimerService();
    _notificationService = NotificationService();
    Future.microtask(() async {
      await _timerService.start();
      _timerService.messages.listen(_handleIsolateMessage);
    });

    ref.onDispose(() {
      _timerService.dispose();
    });
    return {};
  }

  void _handleIsolateMessage(Map<String, dynamic> message) {
    final timerId = message['id'] as String;
    if (!state.containsKey(timerId)) return;

    if (message.containsKey('completed')) {
      final timerName = message['name'] as String;
      _notificationService.showNotification(
        id: timerId.hashCode,
        title: 'Timer Finished',
        body: '$timerName has finished.',
      );
      _handleTimerCompletion(state[timerId]!);
    } else {
      final remainingTime = message['remainingTime'] as int;
      final currentTimer = state[timerId]!;
      if (remainingTime > 0) {
        final updatedTimer =
            currentTimer.copyWith(remainingTime: Duration(seconds: remainingTime));
        final newState = Map<String, TimerModel>.from(state);
        newState[timerId] = updatedTimer;
        state = newState;
      } else {
        _handleTimerCompletion(currentTimer);
      }
    }
  }

  void addTimerFromSequence(TimerSequence sequence) {
    if (state.values.any((t) => t.sequenceId == sequence.id)) return;

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

    state = {...state, newTimer.id: newTimer};
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
    state = {...state, newTimer.id: newTimer};
    if (isRunning) {
      _timerService.addTimer({
        'id': newTimer.id,
        'name': newTimer.name,
        'remainingTime': newTimer.remainingTime.inSeconds,
      });
    }
  }

  void startTimer(String timerId) {
    if (!state.containsKey(timerId) || state[timerId]!.isRunning) return;

    final timer = state[timerId]!;
    final updatedTimer = timer.copyWith(isRunning: true);
    final newState = Map<String, TimerModel>.from(state);
    newState[timerId] = updatedTimer;
    state = newState;
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
      state = {...state, completedTimer.id: updatedTimerModel};
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
    if (!state.containsKey(timerId)) return;
    _timerService.pauseTimer(timerId);
    final timer = state[timerId]!;
    final updatedTimer = timer.copyWith(isRunning: false);
    final newState = Map<String, TimerModel>.from(state);
    newState[timerId] = updatedTimer;
    state = newState;
  }

  void removeTimer(String timerId) {
    if (!state.containsKey(timerId)) return;
    _timerService.removeTimer(timerId);
    state = Map.from(state)..remove(timerId);
  }

  void removeTimerBySequenceId(String sequenceId) {
    try {
      final entry =
          state.entries.firstWhere((e) => e.value.sequenceId == sequenceId);
      removeTimer(entry.key);
    } catch (e) {
      // Timer not found, do nothing
    }
  }
}
