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

  @override
  void initState() {
    super.initState();
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
          'ADD A SET !',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
          CupertinoButton(
            onPressed: handleStartStop,
            padding: EdgeInsets.zero,
            child: Container(
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xff0395eb),
                  width: 4,
                ),
              ),
              child: Text(
                returnFormattedText(),
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
              onPressed: () async {
                int setNumber = 3;
                int time = returnFormattedTextInteger();
                int intensity = int.parse(
                    intensityController.text); // Parse intensity to int
                double difference = 10;
                double percentage = 20;

                await databaseService.addCardioSet(widget.workoutId, setNumber,
                    time, intensity, difference, percentage);

                print(returnFormattedTextInteger());
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
