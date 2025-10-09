import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/category_model.dart';
import 'package:parallel_timers/models/template_model.dart';
import 'package:parallel_timers/providers/category_provider.dart';
import 'package:parallel_timers/providers/template_provider.dart';
import 'package:parallel_timers/providers/timer_provider.dart';

class NewTimerScreen extends ConsumerStatefulWidget {
  final TimerTemplate? template;
  const NewTimerScreen({super.key, this.template});

  @override
  ConsumerState<NewTimerScreen> createState() => _NewTimerScreenState();
}

class _NewTimerScreenState extends ConsumerState<NewTimerScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _minutes = 0;
  Color _selectedColor = Colors.orange;
  IconData _selectedIcon = Icons.restaurant;
  List<int>? _selectedVibrationPattern;
  bool _saveAsTemplate = false;
  String _categoryName = 'General';

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      final template = widget.template!;
      _name = template.name;
      _minutes = template.duration;
      _selectedColor = template.color;
      _selectedIcon = template.icon;
      _saveAsTemplate = true;

      final categories = ref.read(categoryNotifierProvider);
      CategoryModel? category;
      for (final c in categories) {
        if (c.id == template.category) {
          category = c;
          break;
        }
      }
      if (category != null) {
        _categoryName = category.name;
      }
    }
  }

  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  final List<IconData> _icons = [
    Icons.restaurant,
    Icons.coffee,
    Icons.local_drink,
    Icons.camera_alt,
    Icons.timer,
  ];

  final Map<String, List<int>?> _vibrationPatterns = {
    'Default': null,
    'Short': [0, 200, 100, 200],
    'Long': [0, 500, 200, 500],
    'Pulse': [0, 100, 100, 100, 100, 100],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.template == null ? 'New Timer' : 'Edit Template',
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _saveTimer,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Timer Name',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextFormField(
                  key: const Key('timerName_text_field'),
                  initialValue: _name,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g., Pasta, Coffee, Darkroom Timer',
                    hintStyle: TextStyle(color: Color(0xFF404859)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF404859)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onSaved: (value) => _name = value ?? '',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Duration',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextFormField(
                  key: const Key('duration_text_field'),
                  initialValue: _minutes.toString(),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF404859)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onSaved: (value) =>
                      _minutes = int.tryParse(value ?? '0') ?? 0,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Color',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _colors
                      .map(
                        (color) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Icon',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _icons
                      .map(
                        (icon) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedIcon = icon),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF252A39),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedIcon == icon
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(icon, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Vibration Pattern',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: _vibrationPatterns.keys.map((name) {
                    final pattern = _vibrationPatterns[name];
                    final isSelected = _selectedVibrationPattern == pattern;
                    return ChoiceChip(
                      label: Text(name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedVibrationPattern = pattern;
                          });
                        }
                      },
                      backgroundColor: const Color(0xFF252A39),
                      selectedColor: Colors.blue,
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                if (widget.template == null)
                  SwitchListTile(
                    title: const Text('Save as template',
                        style: TextStyle(color: Colors.white)),
                    value: _saveAsTemplate,
                    onChanged: (value) {
                      setState(() {
                        _saveAsTemplate = value;
                      });
                    },
                    activeColor: Colors.blue,
                    tileColor: const Color(0xFF252A39),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                if (_saveAsTemplate) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Category',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  TextFormField(
                    initialValue: _categoryName,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'e.g., Cooking, Workout',
                      hintStyle: TextStyle(color: Color(0xFF404859)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF404859)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onSaved: (value) =>
                        _categoryName = value?.trim() ?? 'General',
                    validator: (value) {
                      if (_saveAsTemplate &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.template == null ? 'Start Timer' : 'Save Template',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveTimer() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String categoryId;

      if (_saveAsTemplate) {
        final categories = ref.read(categoryNotifierProvider);
        CategoryModel? category;
        for (final c in categories) {
          if (c.name.toLowerCase() == _categoryName.toLowerCase()) {
            category = c;
            break;
          }
        }

        if (category == null) {
          categoryId = ref
              .read(categoryNotifierProvider.notifier)
              .addCategory(_categoryName);
        } else {
          categoryId = category.id;
        }
      } else {
        categoryId = '';
      }

      if (widget.template != null) {
        ref.read(templateNotifierProvider.notifier).updateTemplate(
              widget.template!.copyWith(
                name: _name,
                duration: _minutes,
                color: _selectedColor,
                icon: _selectedIcon,
                category: categoryId,
              ),
            );
      } else {
        if (_saveAsTemplate) {
          ref.read(templateNotifierProvider.notifier).addTemplate(
                name: _name,
                duration: _minutes,
                color: _selectedColor,
                icon: _selectedIcon,
                categoryId: categoryId,
              );
        }
        ref.read(timerNotifierProvider.notifier).addTimer(
              name: _name,
              duration: Duration(minutes: _minutes),
              color: _selectedColor,
              icon: _selectedIcon,
              vibrationPattern: _selectedVibrationPattern,
              isRunning: true,
            );
      }
      Navigator.of(context).pop();
    }
  }
}