import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class DeleteWorkout extends StatefulWidget {
  final int workoutId, exerciseId;
  final Color textColor;
  final VoidCallback onDeleteNote; // Add this callback

  const DeleteWorkout(
      {super.key,
      required this.workoutId,
      required this.textColor,
      required this.onDeleteNote,
      required this.exerciseId});

  @override
  State<DeleteWorkout> createState() => _DeleteWorkoutState();
}

class _DeleteWorkoutState extends State<DeleteWorkout> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;
    deleteWorkout() async {
      databaseService.deleteWorkout(widget.workoutId);

      widget.onDeleteNote();
      print("delete note");
    }

    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 255, 112, 112),
                title: Text(
                  "Delete todays workout ?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Are you sure you want to delete this Workout?")
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
                            deleteWorkout();

                            Navigator.pop(context);
                          },
                          child: Text("Confirm"))
                    ],
                  )
                ],
              );
            },
          );
        },
        icon: Icon(Icons.delete, color: widget.textColor, size: 30));
  }
}
