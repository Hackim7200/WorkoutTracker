import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/add_set_popup/cardio_progress/stop_watch_input.dart';

class AddSetCardio extends StatefulWidget {
  final VoidCallback onAddSet;
  final int routineId, exerciseId, workoutId, totalSet;

  const AddSetCardio({
    super.key,
    required this.routineId,
    required this.exerciseId,
    required this.workoutId,
    required this.totalSet,
    required this.onAddSet,
  });

  @override
  State<AddSetCardio> createState() => _AddSetCardioState();
}

class _AddSetCardioState extends State<AddSetCardio> {



  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);

    return FloatingActionButton(
      backgroundColor: floatingIconColor,
      foregroundColor: textColor,
      child: const Icon(Icons.timer),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StopWatchInput(
                exerciseId: widget.exerciseId,
                workoutId: widget.workoutId,
                totalSet: widget.totalSet,
                onAddSet: widget.onAddSet,
                routineId: widget.routineId,
              );
            });
      },
    );
  }
}
