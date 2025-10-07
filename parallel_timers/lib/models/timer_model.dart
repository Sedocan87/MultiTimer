import 'package:flutter/material.dart';

@immutable
class TimerModel {
  final String id;
  final String name;
  final Duration duration;
  final Duration remainingTime;
  final bool isRunning;
  final Color color;
  final IconData icon;
  final Stopwatch stopwatch;

  const TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.remainingTime,
    required this.isRunning,
    required this.color,
    required this.icon,
    required this.stopwatch,
  });

  TimerModel copyWith({
    String? id,
    String? name,
    Duration? duration,
    Duration? remainingTime,
    bool? isRunning,
    Color? color,
    IconData? icon,
    Stopwatch? stopwatch,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      stopwatch: stopwatch ?? this.stopwatch,
    );
  }
}