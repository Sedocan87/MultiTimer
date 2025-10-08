import 'package:flutter/material.dart';
import 'package:parallel_timers/screens/home_screen.dart';
import 'package:parallel_timers/screens/templates_screen.dart';
import 'package:parallel_timers/screens/sequence_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final mainKey = GlobalKey<_MainScreenState>();

  static void switchToHomeTab(BuildContext context) {
    final state = mainKey.currentState;
    if (state != null) {
      state.switchToTab(0);
    }
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TemplatesScreen(),
    SequenceScreen(),
  ];

  void switchToTab(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF252A39),
        indicatorColor: Colors.blue.withAlpha((255 * 0.2).round()),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer, color: Colors.grey),
            selectedIcon: Icon(Icons.timer, color: Colors.blue),
            label: 'Timers',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.bookmark, color: Colors.blue),
            label: 'Templates',
          ),
          NavigationDestination(
            icon: Icon(Icons.playlist_play, color: Colors.grey),
            selectedIcon: Icon(Icons.playlist_play, color: Colors.blue),
            label: 'Sequences',
          ),
        ],
      ),
    );
  }
}
