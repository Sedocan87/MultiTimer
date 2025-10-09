import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'stopwatch_model.g.dart';

@HiveType(typeId: 3)
class StopwatchModel extends HiveObject {
  @HiveField(0)
  final bool isRunning;

  @HiveField(1)
  final Duration elapsed;

  StopwatchModel({
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