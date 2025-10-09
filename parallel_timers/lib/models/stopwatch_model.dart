import 'package:flutter/material.dart';

@immutable
class StopwatchModel {
  final bool isRunning;
  final Duration elapsed;
  final Color color;

  const StopwatchModel({
    this.isRunning = false,
    this.elapsed = Duration.zero,
    this.color = Colors.blue,
  });

  StopwatchModel copyWith({
    bool? isRunning,
    Duration? elapsed,
    Color? color,
  }) {
    return StopwatchModel(
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
      color: color ?? this.color,
    );
  }
}