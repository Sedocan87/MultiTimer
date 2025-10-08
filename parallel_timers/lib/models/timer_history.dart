import 'package:hive/hive.dart';

part 'timer_history.g.dart';

@HiveType(typeId: 1)
class TimerHistory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final Duration duration;

  @HiveField(3)
  final DateTime completedAt;

  TimerHistory({
    required this.id,
    required this.name,
    required this.duration,
    required this.completedAt,
  });
}