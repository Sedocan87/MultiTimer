import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'timer_model.g.dart';

typedef TimerCompleteCallback = void Function();

@HiveType(typeId: 0)
class TimerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final Duration duration;

  @HiveField(3)
  final Duration remainingTime;

  @HiveField(4)
  final bool isRunning;

  @HiveField(5)
  final Color color;

  @HiveField(6)
  final IconData icon;

  @HiveField(7)
  final List<int>? vibrationPattern;

  @HiveField(8)
  final bool isSequence;

  @HiveField(9)
  final String? sequenceId;

  final TimerCompleteCallback? onComplete;

  TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.remainingTime,
    required this.isRunning,
    required this.color,
    required this.icon,
    this.vibrationPattern,
    this.onComplete,
    this.isSequence = false,
    this.sequenceId,
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
    bool? isSequence,
    String? sequenceId,
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
      isSequence: isSequence ?? this.isSequence,
      sequenceId: sequenceId ?? this.sequenceId,
    );
  }
}