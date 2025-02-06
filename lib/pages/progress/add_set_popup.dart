import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class AddSetPopup extends StatefulWidget {
  final int routineId, exerciseId, workoutId, totalSet;
  final VoidCallback onAddSet;

  const AddSetPopup({
    super.key,
    required this.workoutId,
    required this.totalSet,
    required this.routineId,
    required this.exerciseId,
    required this.onAddSet,
  });

  @override
  State<AddSetPopup> createState() => _AddSetPopupState();
}

class _AddSetPopupState extends State<AddSetPopup> {
  final DatabaseService databaseService = DatabaseService.instance;
  final TextEditingController repController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  int setNumber = -1;
  Map<String, dynamic>? prevWorkoutData; // Make it nullable

  @override
  void initState() {
    super.initState();
    fetchPrevWorkoutData();
  }

  /// Fetch previous workout data asynchronously
  void fetchPrevWorkoutData() async {
    Map<String, dynamic> data = await databaseService
        .getSetsOfSecondToLastWorkout(widget.routineId, widget.exerciseId);

    setState(() {
      prevWorkoutData = data;
    });

    // Debug print the result
    print("Previous Workout Data: $prevWorkoutData");
  }

  void _submitAndResetAllVariables() async {
    int reps = int.tryParse(repController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    int lastSetNumber = await databaseService.getLastSetNumber(
        widget.routineId, widget.exerciseId, widget.workoutId);

    var weights = prevWorkoutData?["weights"];
    if (weights != null && weights.isNotEmpty && lastSetNumber > 0) {
      double previousWeight = weights[lastSetNumber];
      double change = weight - previousWeight;
      double percentageChange =
          previousWeight != 0 ? (change / previousWeight) * 100 : 0;

      print("Previous Weight: $previousWeight");
      print("Current Weight: $weight");
      print("Change: $change");
      print("Percentage Change: ${percentageChange.toStringAsFixed(2)}%");
    } else {
      print("No previous workout data available.");
    }

    await databaseService.addSet(
        widget.workoutId, lastSetNumber + 1, reps, weight);

    repController.clear();
    weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);

    return FloatingActionButton(
      backgroundColor: floatingIconColor,
      foregroundColor: textColor,
      child: const Icon(Icons.receipt_long_rounded),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ADD A SET TO YOUR WORKOUT'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Weight",
                      labelStyle: TextStyle(color: textColor),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                  TextField(
                    controller: repController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Reps",
                      labelStyle: TextStyle(color: textColor),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                  if (prevWorkoutData != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      "Previous Workout Data: $prevWorkoutData",
                      style: TextStyle(color: textColor, fontSize: 12),
                    ),
                  ],
                ],
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: floatingIconColor,
                  child: IconButton(
                    icon: Icon(Icons.save, color: textColor),
                    onPressed: () {
                      _submitAndResetAllVariables();
                      Navigator.of(context).pop();
                      widget.onAddSet();
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
