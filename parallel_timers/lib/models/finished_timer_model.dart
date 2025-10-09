import 'package:hive/hive.dart';
import 'package:parallel_timers/models/timer_model.dart';

part 'finished_timer_model.g.dart';

@HiveType(typeId: 2)
class FinishedTimerModel extends HiveObject {
  @HiveField(0)
  final TimerModel timer;

  @HiveField(1)
  final DateTime finishedAt;

  FinishedTimerModel({
    required this.timer,
    required this.finishedAt,
  });
}