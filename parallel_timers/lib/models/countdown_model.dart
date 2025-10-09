import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'countdown_model.g.dart';

@HiveType(typeId: 6)
class Countdown extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime targetDate;

  @HiveField(3)
  Color? color;

  Countdown({required this.name, required this.targetDate, this.color}) {
    id = const Uuid().v4();
  }
}