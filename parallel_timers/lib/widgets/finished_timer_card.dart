import 'package:flutter/material.dart';
import 'package:parallel_timers/models/finished_timer_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class FinishedTimerCard extends StatelessWidget {
  final FinishedTimerModel finishedTimer;

  const FinishedTimerCard({super.key, required this.finishedTimer});

  @override
  Widget build(BuildContext context) {
    final timer = finishedTimer.timer;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3B).withAlpha((255 * 0.5).round()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: timer.color.withAlpha((255 * 0.5).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(timer.icon, color: Colors.white.withAlpha((255 * 0.5).round()), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timer.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withAlpha((255 * 0.5).round()),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Finished ${timeago.format(finishedTimer.finishedAt)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
