import 'package:flutter/material.dart';
import 'package:parallel_timers/timer_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallel Timers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<TimerModel> _timers = [
    TimerModel(
      id: '1',
      name: 'Pasta',
      duration: const Duration(minutes: 10),
      remainingTime: const Duration(minutes: 10),
      color: Colors.blue,
    ),
    TimerModel(
      id: '2',
      name: 'Sauce',
      duration: const Duration(minutes: 25),
      remainingTime: const Duration(minutes: 25),
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parallel Timers'),
      ),
      body: _timers.isEmpty
          ? const Center(
              child: Text('No timers yet.'),
            )
          : ListView.builder(
              itemCount: _timers.length,
              itemBuilder: (context, index) {
                return TimerListItem(timer: _timers[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add timer functionality
        },
        tooltip: 'Add Timer',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TimerListItem extends StatelessWidget {
  const TimerListItem({super.key, required this.timer});

  final TimerModel timer;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: timer.color,
      ),
      title: Text(timer.name),
      subtitle: Text('${timer.remainingTime.inMinutes}:${(timer.remainingTime.inSeconds % 60).toString().padLeft(2, '0')}'),
      trailing: IconButton(
        icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          // TODO: Implement play/pause functionality
        },
      ),
    );
  }
}
