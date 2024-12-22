import 'package:flutter/material.dart';
import 'package:workout_tracker/components/exercise_tile.dart';

class RoutineExercises extends StatelessWidget {
  final String workoutName;
  const RoutineExercises({super.key, required this.workoutName});

  @override
  Widget build(BuildContext context) {
    final List<String> exercises = [
      "Pull-Ups",
      "Deadlifts",
      "Barbell Rows",
      "Dumbbell Rows",
      "Lat Pulldowns",
      "Seated Cable Rows",
      "T-Bar Rows",
      "Face Pulls",
      "Hyperextensions",
      "Inverted Rows",
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          workoutName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/progress"),
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.directions_run_rounded),
      ),
      body: Column(
        children: [
          ExerciseTile(
              title: exercises[0], info: "Chest, Triceps, Core, Glutes"),
          ExerciseTile(
              title: exercises[1], info: "Chest, Triceps, Core, Glutes"),
          ExerciseTile(
              title: exercises[2], info: "Chest, Triceps, Core, Glutes"),
        ],
      ),
    );
  }
}
