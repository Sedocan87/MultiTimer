import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/models/template_model.dart';
import 'package:parallel_timers/providers/template_provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditTemplateScreen extends ConsumerStatefulWidget {
  final TimerTemplate? template;

  const EditTemplateScreen({super.key, this.template});

  @override
  _EditTemplateScreenState createState() => _EditTemplateScreenState();
}

class _EditTemplateScreenState extends ConsumerState<EditTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _duration;
  late Color _color;
  late IconData _icon;
  late String _category;

  @override
  void initState() {
    super.initState();
    _name = widget.template?.name ?? '';
    _duration = widget.template?.duration ?? 10;
    _color = widget.template?.color ?? Colors.blue;
    _icon = widget.template?.icon ?? Icons.timer;
    _category = widget.template?.category ?? 'General';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: Text(widget.template == null ? 'New Template' : 'Edit Template',
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveTemplate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _duration.toString(),
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid duration';
                  }
                  return null;
                },
                onSaved: (value) => _duration = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                onSaved: (value) => _category = value!,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Color:',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _pickColor,
                    child: CircleAvatar(backgroundColor: _color),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Icon:',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _pickIcon,
                    child: Icon(_icon, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _color,
            onColorChanged: (color) => setState(() => _color = color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _pickIcon() async {
    final icon = await showIconPicker(context);

    if (icon != null) {
      setState(() {
        _icon = icon.data;
      });
    }
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final notifier = ref.read(templateNotifierProvider.notifier);
      if (widget.template == null) {
        notifier.addTemplate(
          name: _name,
          duration: _duration,
          color: _color,
          icon: _icon,
          categoryId: _category,
        );
      } else {
        notifier.updateTemplate(
          widget.template!.copyWith(
            name: _name,
            duration: _duration,
            color: _color,
            icon: _icon,
            category: _category,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }
}