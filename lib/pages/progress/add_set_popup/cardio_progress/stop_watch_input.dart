import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class StopWatchInput extends StatefulWidget {
  final int routineId, exerciseId, workoutId, totalSet;
  final VoidCallback onAddSet;

  const StopWatchInput(
      {super.key,
      required this.routineId,
      required this.exerciseId,
      required this.workoutId,
      required this.totalSet,
      required this.onAddSet});

  @override
  State<StopWatchInput> createState() => _StopWatchInputState();
}

class _StopWatchInputState extends State<StopWatchInput> {
  final DatabaseService databaseService = DatabaseService.instance;
  final TextEditingController intensityController = TextEditingController();
  late Stopwatch stopwatch;
  late Timer t;
  int setNumber = -1;
  Map<String, dynamic>? prevWorkoutData; // Make it nullable

  /// Fetch previous workout data asynchronously
  void fetchPrevWorkoutData() async {
    Map<String, dynamic> data =
        await databaseService.getCardioSetsOfSecondToLastWorkout(
            widget.routineId, widget.exerciseId);

    setState(() {
      prevWorkoutData = data;
    });

    // Debug print the result
    print("Previous Workout Data: $prevWorkoutData");
  }

// ********************************** timer related stuff ****************************************************
  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }

  String returnFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;

    // String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }

  int returnFormattedTextInteger() {
    var milli = stopwatch.elapsed.inMilliseconds;
    return milli;
  }

  // ********************************** the main logic ****************************************************

  void _submitAndResetAllVariables() async {
    int currentTime = returnFormattedTextInteger();
    double intensity = double.tryParse(intensityController.text) ??
        0.0; // Parse intensity to int

    int lastSetNumber = await databaseService.getLastSetNumberCardio(
        widget.routineId, widget.exerciseId, widget.workoutId);

    var times = prevWorkoutData?["times"];
    if (times != null && times.isNotEmpty && lastSetNumber >= 0) {
      int previousTime = times[lastSetNumber];
      int change = currentTime - previousTime;
      double percentageChange =
          previousTime != 0 ? (change / previousTime) * 100 : 0;

      print("Previous Weight: $previousTime");
      print("Current Weight: $currentTime");
      print("Change: $change");
      print("Percentage Change: ${percentageChange.toStringAsFixed(2)}%");

      await databaseService.addCardioSet(widget.workoutId, lastSetNumber + 1,
          currentTime, intensity, change, percentageChange);
    } else {
      print("No previous workout data available.");
      await databaseService.addCardioSet(
          widget.workoutId, lastSetNumber + 1, currentTime, intensity, 0, 0);
    }

    print("time $currentTime intensity $intensity");

    intensityController.clear();
    stopwatch.stop();
    stopwatch.reset();
  }

  // ********************************** the rest **********************************************************

  @override
  void initState() {
    super.initState();
    fetchPrevWorkoutData();

    stopwatch = Stopwatch();
    t = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    t.cancel(); // Cancel the timer to prevent memory leaks
    intensityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);

    return AlertDialog(
      title: Center(
        child: Text(
          'ADD A CARDIO SET !',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prevWorkoutData.toString(),
              style: TextStyle(
                fontSize: 8,
              )),
          SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Intensity"),
                  TextField(
                    controller: intensityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          CupertinoButton(
            onPressed: handleStartStop,
            padding: EdgeInsets.zero,
            child: Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xff0395eb),
                  width: 4,
                ),
              ),
              child: Text(
                returnFormattedTextInteger().toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                stopwatch.reset();
              },
              child: const Text(
                "Reset",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (intensityController.text.trim() == "" ||
                      returnFormattedTextInteger() == 0)
                  ? null
                  : () {
                      _submitAndResetAllVariables();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      setState(() {});
                    },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
