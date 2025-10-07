import 'package:flutter/material.dart';

class TimerModel {
  final String id;
  final String name;
  final Duration duration;
  Duration remainingTime;
  bool isRunning;
  final Color color;
  final IconData icon;

  TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.remainingTime,
    this.isRunning = false,
    required this.color,
    required this.icon,
  });

  TimerModel copyWith({
    String? id,
    String? name,
    Duration? duration,
    Duration? remainingTime,
    bool? isRunning,
    Color? color,
    IconData? icon,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}