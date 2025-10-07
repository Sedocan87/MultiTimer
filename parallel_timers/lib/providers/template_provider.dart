import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/template_model.dart';

part 'template_provider.g.dart';

@riverpod
@Riverpod(keepAlive: true)
class TemplateNotifier extends _$TemplateNotifier {
  @override
  List<TimerTemplate> build() {
    return [
      // Cooking Templates
      TimerTemplate(
        id: 'pasta',
        name: 'Pasta',
        duration: 8,
        color: Colors.orange,
        icon: Icons.restaurant,
        category: 'Cooking',
      ),
      TimerTemplate(
        id: 'rice',
        name: 'Rice',
        duration: 20,
        color: Colors.orange,
        icon: Icons.restaurant,
        category: 'Cooking',
      ),
      TimerTemplate(
        id: 'eggs',
        name: 'Boiled Eggs',
        duration: 7,
        color: Colors.orange,
        icon: Icons.restaurant,
        category: 'Cooking',
      ),
      TimerTemplate(
        id: 'pizza',
        name: 'Pizza',
        duration: 15,
        color: Colors.orange,
        icon: Icons.restaurant,
        category: 'Cooking',
      ),
      TimerTemplate(
        id: 'chicken',
        name: 'Chicken',
        duration: 25,
        color: Colors.orange,
        icon: Icons.restaurant,
        category: 'Cooking',
      ),
      // Beverages
      TimerTemplate(
        id: 'tea',
        name: 'Tea',
        duration: 3,
        color: Colors.red,
        icon: Icons.coffee,
        category: 'Beverages',
      ),
      TimerTemplate(
        id: 'coffee',
        name: 'Coffee',
        duration: 4,
        color: Colors.red,
        icon: Icons.coffee,
        category: 'Beverages',
      ),
      TimerTemplate(
        id: 'french_press',
        name: 'French Press',
        duration: 4,
        color: Colors.red,
        icon: Icons.coffee,
        category: 'Beverages',
      ),
      TimerTemplate(
        id: 'cold_brew',
        name: 'Cold Brew',
        duration: 720, // 12 hours
        color: Colors.red,
        icon: Icons.coffee,
        category: 'Beverages',
      ),
      // Photography Templates
      TimerTemplate(
        id: 'develop',
        name: 'Film Development',
        duration: 11,
        color: Colors.purple,
        icon: Icons.camera_alt,
        category: 'Photography',
      ),
      TimerTemplate(
        id: 'fix',
        name: 'Film Fixing',
        duration: 5,
        color: Colors.purple,
        icon: Icons.camera_alt,
        category: 'Photography',
      ),
      TimerTemplate(
        id: 'wash',
        name: 'Film Washing',
        duration: 10,
        color: Colors.purple,
        icon: Icons.camera_alt,
        category: 'Photography',
      ),
      TimerTemplate(
        id: 'print_expose',
        name: 'Print Exposure',
        duration: 2,
        color: Colors.purple,
        icon: Icons.camera_alt,
        category: 'Photography',
      ),
      // Fitness
      TimerTemplate(
        id: 'hiit',
        name: 'HIIT Round',
        duration: 1,
        color: Colors.green,
        icon: Icons.timer,
        category: 'Fitness',
      ),
      TimerTemplate(
        id: 'plank',
        name: 'Plank',
        duration: 1,
        color: Colors.green,
        icon: Icons.timer,
        category: 'Fitness',
      ),
      TimerTemplate(
        id: 'rest',
        name: 'Rest Period',
        duration: 2,
        color: Colors.green,
        icon: Icons.timer,
        category: 'Fitness',
      ),
      // Study
      TimerTemplate(
        id: 'pomodoro',
        name: 'Pomodoro',
        duration: 25,
        color: Colors.blue,
        icon: Icons.timer,
        category: 'Study',
      ),
      TimerTemplate(
        id: 'short_break',
        name: 'Short Break',
        duration: 5,
        color: Colors.blue,
        icon: Icons.timer,
        category: 'Study',
      ),
      TimerTemplate(
        id: 'long_break',
        name: 'Long Break',
        duration: 15,
        color: Colors.blue,
        icon: Icons.timer,
        category: 'Study',
      ),
    ];
  }
}
