import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/routine/routine.dart';
import 'package:workout_tracker/pages/progress/progress.dart';

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
      home: Routine(),
      routes: {
        "/homepage": (context) => Routine(),
        // "/routine": (context) => const RoutineExercises(),
        "/progress": (context) => Progress(),
      },
    );
  }
}
