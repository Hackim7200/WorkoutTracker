import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddSetWeightlifting extends StatefulWidget {
  final int routineId, exerciseId, workoutId, totalSet, maxRep, minRep;
  final VoidCallback onAddSet;

  const AddSetWeightlifting({
    super.key,
    required this.workoutId,
    required this.totalSet,
    required this.routineId,
    required this.exerciseId,
    required this.onAddSet,
    required this.maxRep,
    required this.minRep,
  });

  @override
  State<AddSetWeightlifting> createState() => _AddSetWeightliftingState();
}

class _AddSetWeightliftingState extends State<AddSetWeightlifting> {
  final DatabaseService databaseService = DatabaseService.instance;
  final TextEditingController repController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Map<String, dynamic>? prevWorkoutData; // Make it nullable

  @override
  void initState() {
    super.initState();
    // fetchPrevWorkoutData();
  }

  @override
  void dispose() {
    repController.dispose();
    weightController.dispose();
    super.dispose();
  }

  /// Fetch previous workout data asynchronously
  // void fetchPrevWorkoutData() async {
  //   Map<String, dynamic> data = await databaseService
  //       .getSetsOfSecondToLastWorkout(widget.routineId, widget.exerciseId);

  //   // Close the dialog safely, this avoids the error of using controller after disposing
  //   if (mounted) {
  //     setState(() {
  //       prevWorkoutData = data;
  //     });
  //   }
  //   // Debug print the result
  //   print("Previous Workout Data: $prevWorkoutData");
  // }

  void _submitAndResetAllVariables() async {
    int reps = int.tryParse(repController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    Map<String, dynamic>? prevWorkoutData = await databaseService
        .getSetsOfSecondToLastWorkout(widget.routineId, widget.exerciseId);

    int lastSetNumber = await databaseService.getLastSetNumber(
        widget.routineId, widget.exerciseId, widget.workoutId);

    print("last set number ${lastSetNumber}");

    // var weights = prevWorkoutData?["weights"];

    print(prevWorkoutData);

    // if (weights != null) {
    //   double previousWeight = weights[lastSetNumber];
    //   double change = weight - previousWeight;
    //   double percentageChange =
    //       previousWeight != 0 ? (change / previousWeight) * 100 : 0;

    //   print("Previous Weight: $previousWeight");
    //   print("Current Weight: $weight");
    //   print("Change: $change");
    //   print("Percentage Change: ${percentageChange.toStringAsFixed(2)}%");
    //   // await databaseService.addSet(widget.workoutId, lastSetNumber + 1, reps,
    //   //       weight, change, percentageChange);
    // } else {
    //   print("No previous workout data available.");
    //   //   await databaseService.addSet(
    //   //       widget.workoutId, lastSetNumber + 1, reps, weight, 0, 0);
    // }

    repController.clear();
    weightController.clear();

    // Close the dialog safely, this avoids the error of using controller after disposing
    if (mounted) {
      Navigator.of(context).pop();
    }
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
      child: FaIcon(FontAwesomeIcons.dumbbell), // Dumbbell icon
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'ADD A WEIGHTLIFTING SET ! ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor),
                      decoration: const InputDecoration(labelText: 'Weight'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter weight';
                        }
                        final weight = int.tryParse(value);
                        if (weight == null || weight > 500) {
                          return 'Max weight 500 kg';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: repController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor),
                      decoration: const InputDecoration(labelText: 'Reps '),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter reps';
                      //     }
                      //     final reps = int.tryParse(value);
                      //     if (reps == null || reps > widget.maxRep) {
                      //       return 'Max ${widget.maxRep}';
                      //     } else if (reps < widget.minRep) {
                      //       return 'Min ${widget.minRep}';
                      //     }
                      //     return null;
                      //   },
                    ),
                    //   if (prevWorkoutData != null) ...[
                    //     const SizedBox(height: 10),
                    //     Text(
                    //       "Previous Workout Data: $prevWorkoutData",
                    //       style: TextStyle(color: textColor, fontSize: 8),
                    //     ),
                    //   ],
                  ],
                ),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: floatingIconColor,
                  child: IconButton(
                    icon: Icon(Icons.save, color: textColor),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _submitAndResetAllVariables();

                        // widget.onAddSet();
                      }
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
