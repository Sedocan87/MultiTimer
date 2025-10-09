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
  List<Sequence> build() => [];

  void addSequence({
    required String name,
    required List<TimerModel> timers,
    required Color color,
    required IconData icon,
  }) {
    final newSequence = Sequence(
      id: _uuid.v4(),
      name: name,
      timers: timers,
      color: color,
      icon: icon,
    );
    state = [...state, newSequence];
  }

  void startSequence(String sequenceId) {
    final sequence = state.firstWhere((s) => s.id == sequenceId);
    if (sequence.timers.isEmpty) return;

    ref.read(timerNotifierProvider.notifier).addTimerFromSequence(sequence);
    state = [
      for (final s in state)
        if (s.id == sequenceId) s.copyWith(isRunning: true) else s
    ];
  }

  void stopSequence(String sequenceId) {
    ref.read(timerNotifierProvider.notifier).removeTimerBySequenceId(sequenceId);
    state = [
      for (final s in state)
        if (s.id == sequenceId)
          s.copyWith(isRunning: false, currentTimerIndex: 0)
        else
          s
    ];
  }

  void deleteSequence(String sequenceId) {
    stopSequence(sequenceId);
    state = state.where((s) => s.id != sequenceId).toList();
  }

  void onSequenceTimerCompleted(String sequenceId) {
    final sequence = state.firstWhere((s) => s.id == sequenceId);
    final nextIndex = sequence.currentTimerIndex + 1;

    if (nextIndex >= sequence.timers.length) {
      // Sequence finished
      state = [
        for (final s in state)
          if (s.id == sequenceId)
            s.copyWith(isRunning: false, currentTimerIndex: 0)
          else
            s
      ];
    } else {
      // Move to next timer
      state = [
        for (final s in state)
          if (s.id == sequenceId) s.copyWith(currentTimerIndex: nextIndex) else s
      ];
      // The timer provider will start the next timer
    }
  }
}