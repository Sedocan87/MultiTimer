import 'package:flutter/foundation.dart';

@immutable
class StopwatchModel {
  final bool isRunning;
  final Duration elapsed;

  const StopwatchModel({
    this.isRunning = false,
    this.elapsed = Duration.zero,
  });

  StopwatchModel copyWith({
    bool? isRunning,
    Duration? elapsed,
  }) {
    return StopwatchModel(
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
    );
  }
}