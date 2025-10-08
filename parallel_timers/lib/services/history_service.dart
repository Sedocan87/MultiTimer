import 'package:hive/hive.dart';
import 'package:parallel_timers/models/timer_history.dart';

class HistoryService {
  static const String _boxName = 'timer_history';

  Future<Box<TimerHistory>> _openBox() async {
    return await Hive.openBox<TimerHistory>(_boxName);
  }

  Future<void> addTimerHistory(TimerHistory history) async {
    final box = await _openBox();
    await box.add(history);
  }

  Future<List<TimerHistory>> getTimerHistory() async {
    final box = await _openBox();
    return box.values.toList();
  }
}