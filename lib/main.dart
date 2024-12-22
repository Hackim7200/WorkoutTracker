import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/home_page.dart';
import 'package:workout_tracker/pages/progress.dart';
import 'package:workout_tracker/pages/routine_exercises.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workrout App",
      theme: ThemeData(),
      home: const HomePage(),
      routes: {
        "/homepage": (context) => const HomePage(),
        // "/routine": (context) => const RoutineExercises(),
        "/progress": (context) => const Progress(),
      },
    );
  }
}
