import 'package:flutter/material.dart';
import 'package:parallel_timers/models/timer_model.dart';

class TimerSequence {
  final String id;
  final String name;
  final List<TimerModel> timers;
  final IconData icon;
  final Color color;
  final bool isRunning;
  final int currentTimerIndex;

  const TimerSequence({
    required this.id,
    required this.name,
    required this.timers,
    required this.icon,
    required this.color,
    this.isRunning = false,
    this.currentTimerIndex = 0,
  });

  TimerSequence copyWith({
    String? id,
    String? name,
    List<TimerModel>? timers,
    IconData? icon,
    Color? color,
    bool? isRunning,
    int? currentTimerIndex,
  }) {
    return TimerSequence(
      id: id ?? this.id,
      name: name ?? this.name,
      timers: timers ?? this.timers,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isRunning: isRunning ?? this.isRunning,
      currentTimerIndex: currentTimerIndex ?? this.currentTimerIndex,
    );
  }

  Duration get totalDuration {
    return timers.fold(Duration.zero, (total, timer) => total + timer.duration);
  }

  Duration get remainingDuration {
    if (currentTimerIndex >= timers.length) return Duration.zero;

    Duration remaining = Duration.zero;
    for (var i = currentTimerIndex; i < timers.length; i++) {
      remaining += timers[i].duration;
      if (i == currentTimerIndex) {
        remaining -= (timers[i].duration - timers[i].remainingTime);
      }
    }
    return remaining;
  }
}
