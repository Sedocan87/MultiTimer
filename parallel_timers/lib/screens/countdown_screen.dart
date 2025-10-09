import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/countdown_model.dart';
import 'package:parallel_timers/providers/countdown_provider.dart';
import 'package:parallel_timers/screens/new_countdown_screen.dart';
import 'package:parallel_timers/widgets/countdown_card.dart';

class CountdownScreen extends ConsumerStatefulWidget {
  const CountdownScreen({super.key});

  @override
  ConsumerState<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends ConsumerState<CountdownScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext context, Countdown countdown) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF252A39),
        title: const Text(
          'Delete Countdown',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${countdown.name}"?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(countdownNotifierProvider.notifier)
                  .removeCountdown(countdown.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countdowns = ref.watch(countdownNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdowns'),
        centerTitle: true,
      ),
      body: countdowns.isEmpty
          ? const Center(
              child: Text(
                'No countdowns yet. Tap the + button to add one.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: countdowns.length,
              itemBuilder: (context, index) {
                final countdown = countdowns[index];
                final remaining = countdown.targetDate.difference(DateTime.now());
                if (remaining.isNegative) {
                  // Optionally handle completed countdowns, e.g., remove them
                  // For now, just don't display them if they are done.
                  return const SizedBox.shrink();
                }
                return CountdownCard(
                  countdown: countdown,
                  onDelete: () => _showDeleteConfirmation(context, countdown),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewCountdownScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}