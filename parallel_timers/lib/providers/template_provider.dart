import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../models/template_model.dart';

part 'template_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
class TemplateNotifier extends _$TemplateNotifier {
  late final Box<TimerTemplate> _box;

  @override
  List<TimerTemplate> build() {
    _box = Hive.box<TimerTemplate>('templates');
    final templates = _box.values.toList();
    templates.sort((a, b) => a.order.compareTo(b.order));
    return templates;
  }

  void addTemplate({
    required String name,
    required int duration,
    required Color color,
    required IconData icon,
    required String categoryId,
  }) {
    final newTemplate = TimerTemplate(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      color: color,
      icon: icon,
      category: categoryId,
      order: state.where((t) => t.category == categoryId).length,
    );
    _box.put(newTemplate.id, newTemplate);
    state = [...state, newTemplate];
  }

  void updateTemplate(TimerTemplate template) {
    _box.put(template.id, template);
    state = [
      for (final t in state)
        if (t.id == template.id) template else t,
    ];
  }

  void deleteTemplate(TimerTemplate template) {
    _box.delete(template.id);
    state = state.where((t) => t.id != template.id).toList();
  }

  void reorderTemplates(String categoryId, int oldIndex, int newIndex) {
    final templatesInCategory = state.where((t) => t.category == categoryId).toList();
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = templatesInCategory.removeAt(oldIndex);
    templatesInCategory.insert(newIndex, item);

    for (int i = 0; i < templatesInCategory.length; i++) {
      final template = templatesInCategory[i];
      _box.put(template.id, template.copyWith(order: i));
    }

    final otherTemplates = state.where((t) => t.category != categoryId).toList();
    state = [...otherTemplates, ...templatesInCategory]..sort((a, b) => a.order.compareTo(b.order));
  }
}