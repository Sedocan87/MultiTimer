
import 'package:parallel_timers/models/timer_model.dart';

class FinishedTimerModel {
  final TimerModel timer;
  final DateTime finishedAt;

  FinishedTimerModel({
    required this.timer,
    required this.finishedAt,
  });
}
