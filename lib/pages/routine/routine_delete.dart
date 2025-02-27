import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class RoutineDelete extends StatelessWidget {
  final int routineId;
  const RoutineDelete({super.key, required this.routineId});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;
    deleteExercise() async {
      await databaseService.deleteRoutine(routineId);
    }

    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 255, 112, 112),
                title: Text(
                  "Delete Routine & its Exercises",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Are you sure you want to delete this routine ? if you do so all the exercises and its histories will also be deleted")
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
