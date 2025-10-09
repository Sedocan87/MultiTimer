import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'template_model.g.dart';

@HiveType(typeId: 4)
class TimerTemplate extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  // Duration in seconds
  final int duration;

  @HiveField(3)
  final Color color;

  @HiveField(4)
  final IconData icon;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final bool isPredefined;

  @HiveField(7)
  final int order;

  TimerTemplate({
    required this.id,
    required this.name,
    required this.duration,
    required this.color,
    required this.icon,
    required this.category,
    this.isPredefined = false,
    required this.order,
  });

  TimerTemplate copyWith({
    String? id,
    String? name,
    int? duration,
    Color? color,
    IconData? icon,
    String? category,
    bool? isPredefined,
    int? order,
  }) {
    return TimerTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      isPredefined: isPredefined ?? this.isPredefined,
      order: order ?? this.order,
    );
  }
}
