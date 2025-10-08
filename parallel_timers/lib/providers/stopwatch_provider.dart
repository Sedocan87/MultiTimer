import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/stopwatch_model.dart';

class StopwatchNotifier extends StateNotifier<StopwatchModel> {
  Timer? _timer;

  StopwatchNotifier() : super(const StopwatchModel());

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
    state = const StopwatchModel();
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