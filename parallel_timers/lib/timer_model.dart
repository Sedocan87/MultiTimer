import 'package:flutter/material.dart';

class TimerModel {
  final String id;
  final String name;
  final Duration duration;
  Duration remainingTime;
  bool isRunning;
  final Color color;

  TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.remainingTime,
    this.isRunning = false,
    required this.color,
  });
}
