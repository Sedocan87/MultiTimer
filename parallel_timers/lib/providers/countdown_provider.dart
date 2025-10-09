import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
import 'package:parallel_timers/models/countdown_model.dart';
import 'package:parallel_timers/main.dart';

part 'countdown_provider.g.dart';

@Riverpod(keepAlive: true)
class CountdownNotifier extends _$CountdownNotifier {
  late final Box<Countdown> _box;

  @override
  List<Countdown> build() {
    _box = Hive.box<Countdown>('countdowns');
    return _box.values.toList();
  }

  void addCountdown({required String name, required DateTime targetDate}) {
    final newCountdown = Countdown(name: name, targetDate: targetDate);
    _box.put(newCountdown.id, newCountdown);
    state = _box.values.toList();

    notificationService.scheduleNotification(
      id: newCountdown.id.hashCode,
      title: 'Countdown Finished!',
      body: 'Your countdown "$name" has ended.',
      scheduledDate: targetDate,
    );
  }

  void removeCountdown(String id) {
    notificationService.cancelNotification(id.hashCode);
    _box.delete(id);
    state = _box.values.toList();
  }
}