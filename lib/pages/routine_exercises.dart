import 'package:flutter/material.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/pages/progress.dart';

class RoutineExercises extends StatefulWidget {
  final String workoutName;
  const RoutineExercises({super.key, required this.workoutName});

  @override
  State<RoutineExercises> createState() => _RoutineExercisesState();
}

class _RoutineExercisesState extends State<RoutineExercises> {
  String? _selectedItem;
  final List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(value: '2', child: Text('2 sets')),
    DropdownMenuItem(value: '3', child: Text('3 sets')),
    DropdownMenuItem(value: '4', child: Text('4 sets')),
    DropdownMenuItem(value: '5', child: Text('5 sets')),
  ];

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
          widget.workoutName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          ExerciseTile(
              title: exercises[0],
              info: "Chest, Triceps, Core, Glutes",
              img: 'assets/images/warning (1).png',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Progress()));
              }),
          ExerciseTile(
              title: exercises[1],
              info: "Chest, Triceps, Core, Glutes",
              img: 'assets/images/barbell.png',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Progress()));
              }),
          ExerciseTile(
              title: exercises[2],
              info: "Chest, Triceps, Core, Glutes",
              img: 'assets/images/stretching.png',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Progress()));
              }),
          ExerciseTile(
              title: exercises[4],
              info: "Chest, Triceps, Core, Glutes",
              img: 'assets/images/runner.png',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Progress()));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRoutineDialog(context),
        child: Icon(Icons.directions_run_rounded),
      ),
    );
  }

  void showRoutineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Exercise"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "Exercise Name"),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select a number of sets'),
                    value: _selectedItem,
                    items: items,
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        _selectedItem = newValue;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add exercise logic here
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
