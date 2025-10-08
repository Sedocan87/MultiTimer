import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../models/sequence_model.dart';
import '../models/timer_model.dart';
import 'timer_provider.dart';

part 'sequence_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
class SequenceNotifier extends _$SequenceNotifier {
  @override
  List<TimerSequence> build() => [];

  void addSequence({
    required String name,
    required List<TimerModel> timers,
    required Color color,
    required IconData icon,
  }) {
    final newSequence = TimerSequence(
      id: _uuid.v4(),
      name: name,
      timers: timers,
      color: color,
      icon: icon,
    );
    state = [...state, newSequence];
  }

  void startSequence(String sequenceId) {
    final index = state.indexWhere((seq) => seq.id == sequenceId);
    if (index == -1) return;

    final sequence = state[index];
    if (sequence.timers.isEmpty) return;

    // Start the first timer in the sequence
    ref
        .read(timerNotifierProvider.notifier)
        .addTimer(
          name: '${sequence.name}: ${sequence.timers[0].name}',
          duration: sequence.timers[0].duration,
          color: sequence.color,
          icon: sequence.icon,
          isRunning: true,
          onComplete: () => _continueSequence(sequenceId, 0),
        );

    // Update sequence state
    state = [
      for (var i = 0; i < state.length; i++)
        i == index
            ? sequence.copyWith(isRunning: true, currentTimerIndex: 0)
            : state[i],
    ];
  }

  void _continueSequence(String sequenceId, int completedIndex) {
    final index = state.indexWhere((seq) => seq.id == sequenceId);
    if (index == -1) return;

    final sequence = state[index];
    final nextIndex = completedIndex + 1;

    if (nextIndex >= sequence.timers.length) {
      // Sequence completed
      state = [
        for (var i = 0; i < state.length; i++)
          i == index
              ? sequence.copyWith(isRunning: false, currentTimerIndex: 0)
              : state[i],
      ];

      return;
    }

    // Start the next timer
    final nextTimer = sequence.timers[nextIndex];
    ref
        .read(timerNotifierProvider.notifier)
        .addTimer(
          name: '${sequence.name}: ${nextTimer.name}',
          duration: nextTimer.duration,
          color: sequence.color,
          icon: sequence.icon,
          isRunning: true,
          onComplete: () => _continueSequence(sequenceId, nextIndex),
        );

    // Update sequence state
    state = [
      for (var i = 0; i < state.length; i++)
        i == index ? sequence.copyWith(currentTimerIndex: nextIndex) : state[i],
    ];
  }

  void stopSequence(String sequenceId) {
    final idx = state.indexWhere((seq) => seq.id == sequenceId);
    if (idx == -1) return;

    final sequence = state[idx];
    if (!sequence.isRunning) return;

    // Stop all active timers from this sequence
    final activeTimers = ref.read(timerNotifierProvider);
    for (final timer in activeTimers) {
      if (timer.name.startsWith('${sequence.name}:')) {
        ref.read(timerNotifierProvider.notifier).removeTimer(timer.id);
      }
    }

    // Reset sequence state
    state = [
      for (var i = 0; i < state.length; i++)
        i == idx
            ? sequence.copyWith(isRunning: false, currentTimerIndex: 0)
            : state[i],
    ];
  }

  void deleteSequence(String sequenceId) {
    // Stop the sequence if it's running
    stopSequence(sequenceId);
    // Remove from state
    state = state.where((s) => s.id != sequenceId).toList();
  }
}
