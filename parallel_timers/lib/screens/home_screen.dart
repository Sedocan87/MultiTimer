import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/providers/timer_provider.dart';
import 'package:parallel_timers/screens/new_timer_screen.dart';
import 'package:parallel_timers/widgets/banner_ad_widget.dart';
import 'package:parallel_timers/widgets/timer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(timerNotifierProvider);
    final runningTimers = timers.where((timer) => timer.isRunning).length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Timers',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$runningTimers running',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 32),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NewTimerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: timers.length,
                itemBuilder: (context, index) {
                  final timer = timers[index];
                  return TimerCard(timer: timer);
                },
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
