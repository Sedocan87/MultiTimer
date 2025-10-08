import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/providers/stopwatch_provider.dart';

class StopwatchScreen extends ConsumerWidget {
  const StopwatchScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatch = ref.watch(stopwatchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: const Color(0xFF1A1F2E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(stopwatch.elapsed),
              style: const TextStyle(fontSize: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!stopwatch.isRunning)
                  ElevatedButton(
                    onPressed: () => ref.read(stopwatchProvider.notifier).start(),
                    child: const Text('Start'),
                  ),
                if (stopwatch.isRunning)
                  ElevatedButton(
                    onPressed: () => ref.read(stopwatchProvider.notifier).stop(),
                    child: const Text('Stop'),
                  ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => ref.read(stopwatchProvider.notifier).reset(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1A1F2E),
    );
  }
}