import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/countdown_model.dart';
import 'package:parallel_timers/providers/countdown_provider.dart';

class CountdownCard extends ConsumerStatefulWidget {
  final Countdown countdown;
  final VoidCallback onDelete;

  const CountdownCard({super.key, required this.countdown, required this.onDelete});

  @override
  ConsumerState<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends ConsumerState<CountdownCard> {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

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
    final color = widget.countdown.color ?? Colors.blue;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF252A39),
            Color.alphaBlend(
              color.withAlpha((255 * 0.15).round()),
              const Color(0xFF252A39),
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha((255 * 0.2).round()),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha((255 * 0.15).round()),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: color,
                    size: 28,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onDelete,
                  color: Colors.white,
                  iconSize: 28,
                ),
              ],
            ),
            const SizedBox(height: 12),
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
              style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}