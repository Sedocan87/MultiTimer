import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int order;

  CategoryModel({
    required this.id,
    required this.name,
    required this.order,
  });
}
