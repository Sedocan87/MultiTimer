import 'package:flutter/material.dart';

class TimerTemplate {
  final String id;
  final String name;
  final int duration;
  final Color color;
  final IconData icon;
  final String category;

  const TimerTemplate({
    required this.id,
    required this.name,
    required this.duration,
    required this.color,
    required this.icon,
    required this.category,
  });
}
