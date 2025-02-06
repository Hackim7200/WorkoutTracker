import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

import 'package:workout_tracker/pages/progress/add_set_popup.dart';
import 'package:workout_tracker/pages/progress/goalBar/goals_bar.dart';
import 'package:workout_tracker/pages/progress/data_table.dart/prorgess_table.dart';
import 'package:workout_tracker/pages/progress/notes/add_note.dart';
import 'package:workout_tracker/pages/progress/notes/notes.dart';
import 'package:workout_tracker/pages/exercise/edit_exercise.dart';

import 'package:intl/intl.dart';

class ProgressPage extends StatefulWidget {
  final String currentImage;
  final int exerciseId;
  final int routineId;
  final double monthlyProgressGoals;
  final int minRep;
  final int maxRep;
  final String risk;
  final int maxSet;

  const ProgressPage({
    super.key,
    required this.currentImage,
    required this.exerciseId,
    required this.routineId,
    required this.monthlyProgressGoals,
    required this.minRep,
    required this.maxRep,
    required this.risk,
    required this.maxSet,
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
                // Your input date
                String date = "05 02 2025";

                // Parse the date using DateFormat
                DateFormat inputFormat = DateFormat("dd MM yyyy");
                DateTime parsedDate = inputFormat.parse(date);

                // Format it to ISO 8601 format (YYYY-MM-DD)
                String isoDate = DateFormat("yyyy-MM-dd").format(parsedDate);


                databaseService.addWorkoutWithDate(widget.exerciseId, isoDate);
              },
              icon: Icon(Icons.abc)),
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
        // makes sure that the body is not rendered until the workoutData is loaded
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
                  GoalsBar(
                    minRep: widget.minRep,
                    maxRep: widget.maxRep,
                    progressOverload: widget.monthlyProgressGoals,
                    risk: widget.risk,
                  ),
                  workoutId != -1
                      ? ProgressTable(
                          setNumber: widget.maxSet,
                          routineId: widget.routineId,
                          exerciseId: widget.exerciseId,
                        )
                      : Text(
                          "No set data exists please try adding a workout set :)"),
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

          return widget.maxSet > lastSetAdded
              ? AddSetPopup(
                  workoutId: workoutId,
                  totalSet: widget.maxSet,
                  routineId: widget.routineId,
                  exerciseId: widget.exerciseId,
                  onAddSet: refreshWorkoutData,
                )
              : SizedBox();
        },
      ),
    );
  }
}
