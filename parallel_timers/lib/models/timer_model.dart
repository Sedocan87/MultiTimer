import 'package:flutter/material.dart';

enum TimerStatus { initial, running, paused, finished }

class TimerModel {
  final String id;
  final String name;
  final Duration totalDuration;
  final Duration remainingTime;
  final Color color;
  final TimerStatus status;

  TimerModel({
    required this.id,
    required this.name,
    required this.totalDuration,
    required this.remainingTime,
    required this.color,
    this.status = TimerStatus.initial,
  });

  TimerModel copyWith({
    String? id,
    String? name,
    Duration? totalDuration,
    Duration? remainingTime,
    Color? color,
    TimerStatus? status,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingTime: remainingTime ?? this.remainingTime,
      color: color ?? this.color,
      status: status ?? this.status,
    );
  }
}