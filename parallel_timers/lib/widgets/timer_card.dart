import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/timer_model.dart';
import 'package:parallel_timers/providers/timer_provider.dart';

class TimerCard extends ConsumerWidget {
  final TimerModel timer;

  const TimerCard({super.key, required this.timer});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerNotifier = ref.read(timerProvider.notifier);
    final progress = timer.duration.inSeconds > 0
        ? timer.remainingTime.inSeconds / timer.duration.inSeconds
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: timer.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(timer.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timer.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 1 - progress, // Invert progress to show time elapsed
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(timer.color),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDuration(timer.remainingTime),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (timer.isRunning) {
                timerNotifier.pauseTimer(timer.id);
              } else {
                timerNotifier.startTimer(timer.id);
              }
            },
            color: Colors.white,
            iconSize: 28,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => timerNotifier.removeTimer(timer.id),
            color: Colors.white,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}