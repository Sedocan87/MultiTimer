import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallel_timers/providers/timer_provider.dart';

class NewTimerScreen extends ConsumerStatefulWidget {
  const NewTimerScreen({super.key});

  @override
  ConsumerState<NewTimerScreen> createState() => _NewTimerScreenState();
}

class _NewTimerScreenState extends ConsumerState<NewTimerScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  Color _selectedColor = Colors.red;
  IconData _selectedIcon = Icons.kitchen;

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
    Icons.kitchen,
    Icons.coffee,
    Icons.timer,
    Icons.camera_alt,
    Icons.watch,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Timer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveTimer,
            child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: 'Timer Name', controller: _nameController),
            const SizedBox(height: 24),
            _buildTextField(label: 'Duration', controller: _durationController, keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            _buildSectionTitle('Color'),
            _buildColorSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Icon'),
            _buildIconSelector(),
            const Spacer(),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E2A3B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey));
  }

  Widget _buildColorSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          final color = _colors[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedColor = color),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
                border: _selectedColor == color ? Border.all(color: Colors.white, width: 3) : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          final icon = _icons[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedIcon = icon),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedIcon == icon ? Colors.blue : const Color(0xFF1E2A3B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _startTimer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Start Timer', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void _saveTimer() {
    _addTimer(isRunning: false);
  }

  void _startTimer() {
    _addTimer(isRunning: true);
  }

  void _addTimer({required bool isRunning}) {
    final name = _nameController.text;
    final duration = int.tryParse(_durationController.text) ?? 0;

    if (name.isNotEmpty && duration > 0) {
      ref.read(timerProvider.notifier).addTimer(
            name: name,
            duration: Duration(seconds: duration),
            color: _selectedColor,
            icon: _selectedIcon,
            isRunning: isRunning,
          );
      Navigator.of(context).pop();
    }
  }
}