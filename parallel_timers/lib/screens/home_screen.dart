import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/providers/timer_provider.dart';
import 'package:parallel_timers/widgets/banner_ad_widget.dart';
import 'package:parallel_timers/widgets/timer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parallel Timers'),
      ),
      body: Column(
        children: [
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (timers.length < 3) {
            _showAddTimerDialog(context, ref);
          } else {
            _showTimerLimitDialog(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTimerDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Timer Name'),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration (seconds)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final duration = int.tryParse(durationController.text) ?? 0;
                if (name.isNotEmpty && duration > 0) {
                  ref.read(timerProvider.notifier).addTimer(
                        name: name,
                        duration: Duration(seconds: duration),
                        color: Colors.blue, // Placeholder color
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showTimerLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Timer Limit Reached'),
          content: const Text('Upgrade to the Pro version to run more than 3 timers at once.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}