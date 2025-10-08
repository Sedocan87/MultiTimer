import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parallel_timers/models/timer_history.dart';
import 'package:parallel_timers/providers/timer_history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(timerHistoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Analytics'),
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(child: Text('No completed timers yet.'));
          }
          return Column(
            children: [
              _buildAnalytics(history),
              Expanded(
                child: _buildHistoryList(history),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildAnalytics(List<TimerHistory> history) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    final timerCounts = <String, int>{};
    for (final item in history) {
      timerCounts[item.name] = (timerCounts[item.name] ?? 0) + 1;
    }

    final sortedTimers = timerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final mostFrequentTimer = sortedTimers.first;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "You've completed the '${mostFrequentTimer.key}' timer ${mostFrequentTimer.value} times.",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<TimerHistory> history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text(
              'Completed on ${DateFormat.yMMMd().add_jm().format(item.completedAt)}'),
          trailing: Text(
            '${item.duration.inMinutes} min',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}