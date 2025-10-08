import 'dart:async';
import 'package:parallel_timers/models/finished_timer_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'finished_timer_provider.g.dart';

@Riverpod(keepAlive: true)
class FinishedTimerNotifier extends _$FinishedTimerNotifier {
  Timer? _timer;

  @override
  List<FinishedTimerModel> build() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _removeOldTimers();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    return [];
  }

  void addFinishedTimer(FinishedTimerModel finishedTimer) {
    state = [finishedTimer, ...state];
  }

  void _removeOldTimers() {
    final now = DateTime.now();
    state = state.where((finishedTimer) {
      return now.difference(finishedTimer.finishedAt).inHours < 24;
    }).toList();
  }
}
