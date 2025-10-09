import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/template_model.dart';
import 'package:parallel_timers/providers/template_provider.dart';
import 'package:parallel_timers/providers/timer_provider.dart';
import 'package:parallel_timers/screens/main_screen.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateNotifierProvider);
    final categories = templates.map((t) => t.category).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: const Text('Templates', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...categories.map((category) {
            final categoryTemplates = templates
                .where((t) => t.category == category)
                .toList();
            return _buildCategory(context, ref, category, categoryTemplates);
          }),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    WidgetRef ref,
    String category,
    List<TimerTemplate> templates,
  ) {
    if (templates.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: templates.first.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
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
              onTap: () {
                ref
                    .read(timerNotifierProvider.notifier)
                    .addTimer(
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: template.color.withAlpha((255 * 0.15).round()),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        template.icon,
                        color: template.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        template.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: template.color.withAlpha((255 * 0.15).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${template.duration} min',
                        style: TextStyle(
                          color: template.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
