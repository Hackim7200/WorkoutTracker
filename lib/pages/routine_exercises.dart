import 'package:flutter/material.dart';
import 'package:workout_tracker/components/exercise_tile.dart';

class RoutineExercise extends StatelessWidget {
  const RoutineExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "E X E R C I S E S",
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
          ExerciseTile(),
          ExerciseTile(),
        ],
      ),
    );
  }
}
