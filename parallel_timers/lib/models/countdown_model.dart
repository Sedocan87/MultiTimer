import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'countdown_model.g.dart';

@HiveType(typeId: 5)
class Countdown extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime targetDate;

  Countdown({required this.name, required this.targetDate}) : id = const Uuid().v4();
}