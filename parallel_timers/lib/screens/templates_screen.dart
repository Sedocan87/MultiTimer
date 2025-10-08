import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reorderable_grid_view/flutter_reorderable_grid_view.dart';
import 'package:parallel_timers/models/category_model.dart';
import 'package:parallel_timers/models/template_model.dart';
import 'package:parallel_timers/providers/category_provider.dart';
import 'package:parallel_timers/providers/template_provider.dart';
import 'package:parallel_timers/providers/timer_provider.dart';
import 'package:parallel_timers/screens/main_screen.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryNotifierProvider);
    final templates = ref.watch(templateNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: const Text('Templates', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context, ref),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryTemplates = templates.where((t) => t.category == category.id).toList();
          return _buildCategory(context, ref, category, categoryTemplates);
        },
        onReorder: (oldIndex, newIndex) {
          ref.read(categoryNotifierProvider.notifier).reorderCategories(oldIndex, newIndex);
        },
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
    List<TimerTemplate> templates,
  ) {
    return Card(
      key: ValueKey(category.id),
      margin: const EdgeInsets.all(8.0),
      color: const Color(0xFF252A39),
      child: Column(
        children: [
          ListTile(
            title: Text(category.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _showAddTemplateDialog(context, ref, category.id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Category'),
                        content: Text('Are you sure you want to delete ${category.name} and all its templates?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(categoryNotifierProvider.notifier).deleteCategory(category);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ReorderableGridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: templates.length,
            itemBuilder: (context, templateIndex) {
              final template = templates[templateIndex];
              return GestureDetector(
                key: ValueKey(template.id),
                onTap: () {
                  ref.read(timerNotifierProvider.notifier).addTimer(
                        name: template.name,
                        duration: Duration(minutes: template.duration),
                        color: template.color,
                        icon: template.icon,
                        isRunning: true,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${template.name} timer started'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  MainScreen.switchToHomeTab(context);
                },
                onLongPress: () {
                  _showEditTemplateDialog(context, ref, template);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF252A39),
                        Color.alphaBlend(
                          template.color.withAlpha((255 * 0.15).round()),
                          const Color(0xFF252A39),
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: template.color.withAlpha((255 * 0.2).round()),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(template.icon, color: template.color, size: 32),
                      const SizedBox(height: 12),
                      Text(template.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${template.duration} min', style: TextStyle(color: template.color, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              ref.read(templateNotifierProvider.notifier).reorderTemplates(category.id, oldIndex, newIndex);
            },
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(categoryNotifierProvider.notifier).addCategory(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTemplateDialog(BuildContext context, WidgetRef ref, String categoryId) {
    final nameController = TextEditingController();
    final durationController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Template'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Template Name'),
              ),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration in minutes'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final duration = int.tryParse(durationController.text);
                if (name.isNotEmpty && duration != null) {
                  ref.read(templateNotifierProvider.notifier).addTemplate(
                        name: name,
                        duration: duration,
                        color: Colors.blue, // Default color
                        icon: Icons.timer, // Default icon
                        categoryId: categoryId,
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTemplateDialog(
    BuildContext context,
    WidgetRef ref,
    TimerTemplate template,
  ) {
    final controller = TextEditingController(text: template.duration.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${template.name}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration in minutes',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Template'),
                    content: Text('Are you sure you want to delete ${template.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(templateNotifierProvider.notifier).deleteTemplate(template);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newDuration = int.tryParse(controller.text);
                if (newDuration != null) {
                  ref.read(templateNotifierProvider.notifier).updateTemplate(
                        template.copyWith(duration: newDuration),
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}