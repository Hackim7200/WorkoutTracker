import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/pages/progress/main_stats.dart';
import 'package:workout_tracker/pages/progress/weight_progress/data_table.dart/calisthenics/add_set_calisthenics.dart';

import 'package:workout_tracker/pages/progress/weight_progress/data_table.dart/cardio/cardio_progress/add_set_cardio.dart';

import 'package:workout_tracker/pages/progress/weight_progress/data_table.dart/weightlifting/add_set_weightlifting.dart';
import 'package:workout_tracker/pages/progress/goalBar/goals_bar.dart';

import 'package:workout_tracker/pages/progress/notes/add_note.dart';
import 'package:workout_tracker/pages/progress/notes/notes.dart';
import 'package:workout_tracker/pages/exercise/edit_exercise.dart';

import 'package:intl/intl.dart';

class ProgressPage extends StatefulWidget {
  final String currentImage;
  final int exerciseId;
  final int routineId;
  final String risk;
  final int numberOfSets;
  final String type;

  const ProgressPage({
    super.key,
    required this.currentImage,
    required this.exerciseId,
    required this.routineId,
    required this.risk,
    required this.numberOfSets,
    required this.type,
  });

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
  final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
  final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
  final Color textColor = Color.fromRGBO(61, 61, 61, 1);

  final DatabaseService databaseService = DatabaseService.instance;
  late Future<Map<String, dynamic>> workoutData;

  @override
  void initState() {
    super.initState();
    workoutData = initialiseVariables();
  }

  int workoutId = -1;
  String lastDate = "";
  String currentDate = "";
  int lastSetAdded = 0;

  Future<Map<String, dynamic>> initialiseVariables() async {
    Map<String, dynamic> lastWorkout = await databaseService.getLastWorkout(
        widget.routineId, widget.exerciseId);

    int lastWorkoutId = lastWorkout["id"];
    int lastSetNumber = await databaseService.getLastSetNumber(
        widget.routineId, widget.exerciseId, lastWorkoutId);

    String nowWorkoutDate = DateFormat("dd MMM yy").format(DateTime.now());
    //
    String lastWorkoutDate = ""; // Default value
    if (lastWorkoutId != -1) {
      lastWorkoutDate = DateFormat("dd MMM yy")
          .format(DateTime.parse(lastWorkout["date"].toString()));
    }

    if (lastWorkoutId == -1 || lastWorkoutDate != nowWorkoutDate) {
      await databaseService.addWorkout(widget.exerciseId);
      lastWorkout = await databaseService.getLastWorkout(
          widget.routineId, widget.exerciseId);
      lastSetNumber = await databaseService.getLastSetNumber(
          widget.routineId, widget.exerciseId, lastWorkout["id"]);
    }

    return {
      "workoutId": lastWorkout["id"],
      "lastSetAdded": lastSetNumber,
      "lastDate": lastWorkoutDate,
      "currentDate": nowWorkoutDate,
    };
  }

  void refreshWorkoutData() {
    setState(() {
      workoutData = initialiseVariables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "P R O G R E S S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditExercise(selectedImage: widget.currentImage);
                }));
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddNote(exerciseId: widget.exerciseId);
                })).then((_) {
                  setState(() {});
                });
              },
              icon: Icon(Icons.note_add)),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: workoutData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          }

          final data = snapshot.data!;
          int workoutId = data["workoutId"];
          int lastSetAdded = data["lastSetAdded"];
          String lastDate = data["lastDate"];
          String currentDate = data["currentDate"];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(
                      "id: $workoutId    Now: $currentDate     Last: $lastDate     Last Set: $lastSetAdded"),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Divider(),
                  ),
                  Notes(
                    routineId: widget.routineId,
                    exerciseId: widget.exerciseId,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Divider(),
                  ),
                  MainStats(
                    type: widget.type,
                    risk: widget.risk,
                    numberOfSets: widget.numberOfSets,
                    minRep: 10,
                    maxRep: 20,
                    progressOverload: 100,
                    routineId: widget.routineId,
                    exerciseId: widget.exerciseId,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<Map<String, dynamic>>(
        future: workoutData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              snapshot.data == null) {
            return SizedBox();
          }

          final data = snapshot.data!;
          int lastSetAdded = data["lastSetAdded"];
          int workoutId = data["workoutId"];

          if (widget.numberOfSets > lastSetAdded) {
            if (widget.type == "weightlifting") {
              return AddSetWeightlifting(
                workoutId: workoutId,
                totalSet: widget.numberOfSets,
                routineId: widget.routineId,
                exerciseId: widget.exerciseId,
                onAddSet: refreshWorkoutData,
              );
            } else if (widget.type == "calisthenics") {
              return AddSetCalisthenics(
                workoutId: workoutId,
                totalSet: widget.numberOfSets,
                routineId: widget.routineId,
                exerciseId: widget.exerciseId,
                onAddSet: refreshWorkoutData,
              );
            } else if (widget.type == "cardio") {
              return AddSetCardio(
                workoutId: workoutId,
                totalSet: widget.numberOfSets,
                routineId: widget.routineId,
                exerciseId: widget.exerciseId,
                onAddSet: refreshWorkoutData,
              );
            }
          }
          return SizedBox();
        },
      ), // <-- Closing bracket for FutureBuilder
    );
  } // <-- Closing bracket for build method
}
