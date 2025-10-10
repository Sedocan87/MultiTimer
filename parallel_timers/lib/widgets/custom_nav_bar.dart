import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF0F1928),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.timer, 0),
          _buildNavItem(Icons.grid_view, 1),
          _buildNavItem(Icons.list, 2),
          _buildNavItem(Icons.watch, 3),
          _buildNavItem(Icons.hourglass_empty, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Icon(
        icon,
        color: selectedIndex == index ? Colors.blue : Colors.grey,
        size: 30,
      ),
    );
  }
}