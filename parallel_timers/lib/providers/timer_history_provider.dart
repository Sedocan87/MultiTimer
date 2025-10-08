import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/services/history_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_history_provider.g.dart';

@Riverpod(keepAlive: true)
class TimerHistoryNotifier extends _$TimerHistoryNotifier {
  late final HistoryService _historyService;

  @override
  Future<List<TimerHistory>> build() async {
    _historyService = HistoryService();
    return _historyService.getTimerHistory();
  }

  Future<void> addTimerHistory(TimerHistory history) async {
    await _historyService.addTimerHistory(history);
    state = AsyncData([...state.value ?? [], history]);
  }
}