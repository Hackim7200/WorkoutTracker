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
  final TextEditingController repControler = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  int setNumber = -1;

  @override
  void dispose() {
    repControler.dispose();
    weightController.dispose();
    super.dispose();
  }

  void _submitAndResetAllVariables() async {
    print("Submitted set");
    int reps = int.parse(repControler.text);
    double weight = double.parse(weightController.text);

    int lastSetNumber = await databaseService.getLastSetNumber(
        widget.routineId, widget.exerciseId, widget.workoutId);

    databaseService.addSet(widget.workoutId, lastSetNumber + 1, reps, weight);

    repControler.clear();
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
                    controller: repControler,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Reps",
                      labelStyle: TextStyle(color: textColor),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: floatingIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.save,
                      color: textColor,
                    ),
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
