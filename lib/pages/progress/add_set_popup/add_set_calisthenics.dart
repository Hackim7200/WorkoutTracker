import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddSetCalisthenics extends StatefulWidget {
  final int routineId, exerciseId, workoutId, totalSet;
  final VoidCallback onAddSet;

  const AddSetCalisthenics({
    super.key,
    required this.workoutId,
    required this.totalSet,
    required this.routineId,
    required this.exerciseId,
    required this.onAddSet,
  });

  @override
  State<AddSetCalisthenics> createState() => _AddSetCalisthenicsState();
}

class _AddSetCalisthenicsState extends State<AddSetCalisthenics> {
  final DatabaseService databaseService = DatabaseService.instance;
  final TextEditingController repController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int setNumber = -1;

  @override
  void initState() {
    super.initState();
  }

  void _submitAndResetAllVariables() async {
    if (mounted) {
      Navigator.of(context).pop(); // Close the dialog first
    }
    int rep = int.tryParse(repController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    Map<String, dynamic>? prevWorkoutData = await databaseService
        .getSetsOfSecondToLastWorkout(widget.routineId, widget.exerciseId);

    int lastSetNumber = await databaseService.getLastSetNumber(
        widget.routineId, widget.exerciseId, widget.workoutId);

    // print("last set number ${lastSetNumber}");

    var reps = prevWorkoutData?["reps"];

    // print(prevWorkoutData);

    if (reps != null) {
      int previousRep = reps[lastSetNumber];
      int change = rep - previousRep;
      double percentageChange =
          previousRep != 0 ? (change / previousRep) * 100 : 0;

      print("Previous rep: $previousRep");
      print("Current rep: $rep");
      print("Change: $change");
      print("Percentage Change: ${percentageChange.toStringAsFixed(2)}%");
      await databaseService.addSet(widget.workoutId, lastSetNumber + 1, rep,
          weight, change.toDouble(), percentageChange);
    } else {
      print("No previous workout data available.");
      await databaseService.addSet(
          widget.workoutId, lastSetNumber + 1, rep, weight, 0, 0);
    }

    repController.clear();
    weightController.clear();

    // Close the dialog safely, this avoids the error of using controller after disposing
    if (mounted) {
      repController.clear();
      weightController.clear();
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
      child: const FaIcon(FontAwesomeIcons.personWalking),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'ADD A CALISTHENICS SET !',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: mounted ? weightController : null,
                      keyboardType: TextInputType.number,
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
                      style: TextStyle(color: textColor),
                    ),
                    TextFormField(
                      controller: mounted ? repController : null,
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
                    // if (prevWorkoutData != null) ...[
                    //   const SizedBox(height: 10),
                    //   Text(
                    //     "Previous Workout Data: $prevWorkoutData",
                    //     style: TextStyle(color: textColor, fontSize: 12),
                    //   ),
                    // ],
                  ],
                ),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: floatingIconColor,
                  child: IconButton(
                    icon: Icon(Icons.save, color: textColor),
                    onPressed: () {
                      _submitAndResetAllVariables();

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
