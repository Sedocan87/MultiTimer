import 'package:flutter/material.dart';

typedef TimerCompleteCallback = void Function();

class TimerModel {
  final TimerCompleteCallback? onComplete;
  final String id;
  final String name;
  final Duration duration;
  final Duration remainingTime;
  final bool isRunning;
  final Color color;
  final IconData icon;
  final List<int>? vibrationPattern;

  const TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.remainingTime,
    required this.isRunning,
    required this.color,
    required this.icon,
    this.vibrationPattern,
    this.onComplete,
  });

  TimerModel copyWith({
    String? id,
    String? name,
    Duration? duration,
    Duration? remainingTime,
    bool? isRunning,
    Color? color,
    IconData? icon,
    List<int>? vibrationPattern,
    TimerCompleteCallback? onComplete,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      vibrationPattern: vibrationPattern ?? this.vibrationPattern,
      onComplete: onComplete ?? this.onComplete,
    );
  }
}
