import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parallel_timers/models/timer_model.dart';

part 'sequence_model.g.dart';

@HiveType(typeId: 1)
class Sequence extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<TimerModel> timers;

  @HiveField(3)
  final IconData icon;

  @HiveField(4)
  final Color color;

  @HiveField(5)
  final bool isRunning;

  @HiveField(6)
  final int currentTimerIndex;

  Sequence({
    required this.id,
    required this.name,
    required this.timers,
    required this.icon,
    required this.color,
    this.isRunning = false,
    this.currentTimerIndex = 0,
  });

  Sequence copyWith({
    String? id,
    String? name,
    List<TimerModel>? timers,
    IconData? icon,
    Color? color,
    bool? isRunning,
    int? currentTimerIndex,
  }) {
    return Sequence(
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