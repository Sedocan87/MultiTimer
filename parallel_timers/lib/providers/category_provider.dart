import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../models/template_model.dart';

part 'category_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
class CategoryNotifier extends _$CategoryNotifier {
  late final Box<CategoryModel> _box;

  @override
  List<CategoryModel> build() {
    _box = Hive.box<CategoryModel>('categories');
    if (_box.isEmpty) {
      _box.addAll(_getPredefinedCategories());
    }
    final categories = _box.values.toList();
    categories.sort((a, b) => a.order.compareTo(b.order));
    return categories;
  }

  List<CategoryModel> _getPredefinedCategories() {
    return [
      CategoryModel(id: 'cooking', name: 'Cooking', order: 0),
      CategoryModel(id: 'beverages', name: 'Beverages', order: 1),
      CategoryModel(id: 'photography', name: 'Photography', order: 2),
      CategoryModel(id: 'fitness', name: 'Fitness', order: 3),
      CategoryModel(id: 'study', name: 'Study', order: 4),
    ];
  }

  void addCategory(String name) {
    final newCategory = CategoryModel(
      id: _uuid.v4(),
      name: name,
      order: state.length,
    );
    _box.put(newCategory.id, newCategory);
    state = [...state, newCategory];
  }

  void deleteCategory(CategoryModel category) {
    _box.delete(category.id);
    // Also delete all templates in this category
    final templateBox = Hive.box<TimerTemplate>('templates');
    final templatesToDelete = templateBox.values.where((t) => t.category == category.id);
    for (final template in templatesToDelete) {
      templateBox.delete(template.id);
    }
    state = state.where((c) => c.id != category.id).toList();
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
    for (int i = 0; i < state.length; i++) {
      final category = state[i];
      _box.put(category.id, CategoryModel(id: category.id, name: category.name, order: i));
    }
    state = _box.values.toList()..sort((a, b) => a.order.compareTo(b.order));
  }
}
