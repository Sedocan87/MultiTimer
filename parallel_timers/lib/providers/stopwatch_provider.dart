import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:parallel_timers/models/stopwatch_model.dart';

class StopwatchNotifier extends StateNotifier<StopwatchModel> {
  Timer? _timer;
  late final Box _box;

  StopwatchNotifier() : super(StopwatchModel()) {
    _box = Hive.box('stopwatch_settings');
    final colorValue = _box.get('color', defaultValue: Colors.blue.value);
    state = state.copyWith(color: Color(colorValue));
  }

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      state = state.copyWith(elapsed: state.elapsed + const Duration(milliseconds: 10));
    });
  }

  void stop() {
    if (!state.isRunning) return;
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = StopwatchModel(color: state.color);
  }

  void setColor(Color color) {
    state = state.copyWith(color: color);
    _box.put('color', color.value);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, StopwatchModel>((ref) {
  return StopwatchNotifier();
});