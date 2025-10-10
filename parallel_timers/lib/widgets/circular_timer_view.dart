import 'package:flutter/material.dart';

class CircularTimerView extends StatelessWidget {
  const CircularTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: 0.25, // Example progress
            strokeWidth: 12,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '00:00',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ready to start',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}