import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/countdown_model.dart';
import 'package:parallel_timers/providers/countdown_provider.dart';

class CountdownCard extends ConsumerStatefulWidget {
  final Countdown countdown;

  const CountdownCard({super.key, required this.countdown});

  @override
  ConsumerState<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends ConsumerState<CountdownCard> {
  Timer? _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    }
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _remainingTime = widget.countdown.targetDate.difference(DateTime.now());
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      _timer?.cancel();
      return "Reached!";
    }

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (days > 0) parts.add('$days d');
    if (hours > 0) parts.add('$hours h');
    if (minutes > 0) parts.add('$minutes m');
    if (seconds >= 0) parts.add('$seconds s');

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.blue, // Example color
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.countdown.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(_remainingTime),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(countdownNotifierProvider.notifier).removeCountdown(widget.countdown.id);
            },
            color: Colors.white,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}