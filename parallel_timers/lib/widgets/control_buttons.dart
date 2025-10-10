import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
          ),
          child: const Icon(
            Icons.refresh,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 20),
        // Play and Add buttons
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
            Positioned(
              right: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}