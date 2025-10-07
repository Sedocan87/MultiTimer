import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/timer_provider.dart';

class TimerCard extends ConsumerWidget {
  final TimerModel timer;

  const TimerCard({super.key, required this.timer});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerNotifier = ref.read(timerProvider.notifier);

    return Card(
      color: timer.color.withAlpha((255 * 0.8).round()),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timer.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              _formatDuration(timer.remainingTime),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(timer.status == TimerStatus.running ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (timer.status == TimerStatus.running) {
                      timerNotifier.pauseTimer(timer.id);
                    } else {
                      timerNotifier.startTimer(timer.id);
                    }
                  },
                  color: Colors.white,
                  iconSize: 30,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => timerNotifier.resetTimer(timer.id),
                  color: Colors.white,
                  iconSize: 30,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => timerNotifier.removeTimer(timer.id),
                  color: Colors.white,
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}