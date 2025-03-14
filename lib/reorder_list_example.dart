import 'package:flutter/material.dart';

class ReorderListExample extends StatefulWidget {
  const ReorderListExample({super.key});

  @override
  State<ReorderListExample> createState() => _ReorderListExampleState();
}

class _ReorderListExampleState extends State<ReorderListExample> {
  final exercises = [
    "Bench Press",
    "Squats",
    "Deadlifts",
    "Pullups",
    "Pushups",
    "Dumbbell Curls",
  ];
  void updateTilePositions(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final exercise = exercises.removeAt(oldIndex);
      exercises.insert(newIndex, exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder List Example'),
      ),
      body: ReorderableListView(
        children: [
          for (final exercise in exercises)
            ListTile(
              key: ValueKey(exercise),
              title: Text('$exercise'),
            )
        ],
        onReorder: (int oldIndex, int newIndex) =>
            updateTilePositions(oldIndex, newIndex),
      ),
    );
  }
}
