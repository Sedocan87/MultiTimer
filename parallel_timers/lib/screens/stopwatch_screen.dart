import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/providers/stopwatch_provider.dart';

class StopwatchScreen extends ConsumerWidget {
  const StopwatchScreen({super.key});

  final List<Color> _colors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  Map<String, String> _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return {
      'hours': twoDigitHours,
      'minutes': twoDigitMinutes,
      'seconds': twoDigitSeconds,
      'milliseconds': twoDigitMilliseconds,
    };
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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF252A39),
                    Color.alphaBlend(
                      stopwatch.color.withAlpha((255 * 0.15).round()),
                      const Color(0xFF252A39),
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: stopwatch.color.withAlpha((255 * 0.2).round()),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.2).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Stopwatch',
                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDuration(stopwatch.elapsed)['hours']!,
                            style: const TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatDuration(stopwatch.elapsed)['minutes']!,
                            style: const TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatDuration(stopwatch.elapsed)['seconds']!,
                            style: const TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 60),
                          Text(
                            _formatDuration(stopwatch.elapsed)['milliseconds']!,
                            style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!stopwatch.isRunning)
                  FilledButton(
                    onPressed: () => ref.read(stopwatchProvider.notifier).start(),
                    style: FilledButton.styleFrom(
                      backgroundColor: stopwatch.color,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Start', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                if (stopwatch.isRunning)
                  FilledButton(
                    onPressed: () => ref.read(stopwatchProvider.notifier).stop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Stop', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                const SizedBox(width: 20),
                FilledButton(
                  onPressed: () => ref.read(stopwatchProvider.notifier).reset(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Reset', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _colors
                  .map(
                    (color) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => ref.read(stopwatchProvider.notifier).setColor(color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: stopwatch.color == color
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1A1F2E),
    );
  }
}