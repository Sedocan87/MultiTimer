import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:parallel_timers/providers/template_provider.dart';
import '../models/timer_model.dart';
import '../models/sequence_model.dart';
import '../providers/sequence_provider.dart';

class SequenceScreen extends ConsumerStatefulWidget {
  const SequenceScreen({super.key});

  @override
  ConsumerState<SequenceScreen> createState() => _SequenceScreenState();
}

class _SequenceScreenState extends ConsumerState<SequenceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  final List<TimerModel> _selectedTimers = [];
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.timer;

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
    Icons.fitness_center,
    Icons.work,
    Icons.sports,
    Icons.book,
    Icons.music_note,
  ];

  void _showDeleteConfirmation(BuildContext context, TimerSequence sequence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF252A39),
        title: const Text(
          'Delete Sequence',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${sequence.name}"?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(sequenceNotifierProvider.notifier)
                  .deleteSequence(sequence.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateSequenceDialog(
    BuildContext context,
    List<TimerModel> availableTimers,
  ) {
    setState(() {
      _name = null;
      _selectedTimers.clear();
      _selectedColor = Colors.blue;
      _selectedIcon = Icons.timer;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => AlertDialog(
          backgroundColor: const Color(0xFF252A39),
          title: const Text(
            'Create Sequence',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Sequence Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Timers (in order):',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  if (availableTimers.isEmpty)
                    const Text(
                      'Create some timers first!',
                      style: TextStyle(color: Colors.red),
                    )
                  else
                    ...availableTimers.map(
                      (timer) => CheckboxListTile(
                        title: Text(
                          timer.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${timer.duration.inMinutes} minutes',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        value: _selectedTimers.any((t) => t.id == timer.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedTimers.add(timer);
                            } else {
                              _selectedTimers.removeWhere(
                                (t) => t.id == timer.id,
                              );
                            }
                          });
                        },
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Text('Color:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colors
                        .map(
                          (color) => GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: color == _selectedColor
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Icon:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _icons
                        .map(
                          (icon) => GestureDetector(
                            onTap: () => setState(() => _selectedIcon = icon),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: icon == _selectedIcon
                                    ? Colors.blue.withAlpha(76)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                icon,
                                color: icon == _selectedIcon
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (_selectedTimers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one timer'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_name != null) {
                    ref
                        .read(sequenceNotifierProvider.notifier)
                        .addSequence(
                          name: _name!,
                          timers: List.from(_selectedTimers),
                          color: _selectedColor,
                          icon: _selectedIcon,
                        );
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Create', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sequences = ref.watch(sequenceNotifierProvider);
    final availableTemplates = ref.watch(templateNotifierProvider);
    final availableTimers = availableTemplates
        .map(
          (template) => TimerModel(
            id: template.id,
            name: template.name,
            duration: Duration(minutes: template.duration),
            remainingTime: Duration(minutes: template.duration),
            isRunning: false,
            color: template.color,
            icon: template.icon,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: const Text(
          'Timer Sequences',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () =>
                _showCreateSequenceDialog(context, availableTimers),
          ),
        ],
      ),
      body: Column(
        children: [
          if (sequences.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.playlist_play,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Sequences Yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create a sequence of timers that run one after another',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Create Sequence'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () =>
                          _showCreateSequenceDialog(context, availableTimers),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sequences.length,
                itemBuilder: (context, index) {
                  final sequence = sequences[index];
                  return Card(
                    color: const Color(0xFF252A39),
                    child: ListTile(
                      leading: Icon(sequence.icon, color: sequence.color),
                      title: Text(
                        sequence.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${sequence.timers.length} timers - ${_formatDuration(sequence.totalDuration)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sequence.timers.map((t) => t.name).join(' → '),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!sequence.isRunning)
                            IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                ref
                                    .read(sequenceNotifierProvider.notifier)
                                    .startSequence(sequence.id);
                              },
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.stop, color: Colors.red),
                              onPressed: () {
                                ref
                                    .read(sequenceNotifierProvider.notifier)
                                    .stopSequence(sequence.id);
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              _showDeleteConfirmation(context, sequence);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }
}
