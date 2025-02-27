import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class ExerciseDelete extends StatelessWidget {
  final int exerciseId;
  const ExerciseDelete({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;
    deleteExercise() async {
      await databaseService.deleteExercise(exerciseId);
    }

    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 255, 112, 112),
                title: Text(
                  "Delete Exercise & History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Are you sure you want to delete the exercise and all the workout you have done for this exercise? there is no coming back")
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            deleteExercise();
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          child: Text("Confirm"))
                    ],
                  )
                ],
              );
            },
          );
        },
        icon: Icon(Icons.delete));
  }
}
