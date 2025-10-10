import 'package:flutter/material.dart';
import 'package:parallel_timers/screens/templates_screen.dart';
import 'package:parallel_timers/widgets/circular_timer_view.dart';
import 'package:parallel_timers/widgets/control_buttons.dart';
import 'package:parallel_timers/widgets/custom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainTimerView(),
    const TemplatesScreen(),
    // Add other screens here as they are built
    const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1928),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}

class MainTimerView extends StatelessWidget {
  const MainTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Parallel Timers',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Active Timers: 0 running',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const Expanded(
              child: Center(
                child: CircularTimerView(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: ControlButtons(),
            ),
          ],
        ),
      ),
    );
  }
}