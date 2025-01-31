import 'package:flutter/material.dart';

import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/set_model.dart';

import 'package:workout_tracker/pages/progress/add_set_popup.dart';
import 'package:workout_tracker/pages/progress/goalBar/goals_bar.dart';
import 'package:workout_tracker/pages/progress/prorgess_table.dart';

import 'package:workout_tracker/pages/progress/notes/add_note.dart';
import 'package:workout_tracker/pages/progress/notes/notes.dart';
import 'package:workout_tracker/pages/exercise/edit_exercise.dart';
import 'package:workout_tracker/pages/progress/user_data_source.dart';

class Progress extends StatefulWidget {
  final String currentImage;
  final int exerciseId;
  final int routineId;
  final double monthlyProgressGoals;
  final int minRep;
  final int maxRep;
  final String risk;

  const Progress(
      {super.key,
      required this.currentImage,
      required this.exerciseId,
      required this.routineId,
      required this.monthlyProgressGoals,
      required this.minRep,
      required this.maxRep,
      required this.risk});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
  final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
  final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
  final Color textColor = Color.fromRGBO(61, 61, 61, 1);

  final DatabaseService databaseService = DatabaseService.instance;
  int workoutId = -1;

  Future<void> createWorkout() async {
    int fetchedWorkoutId =
        await databaseService.getWorkout(widget.routineId, widget.exerciseId);

    if (fetchedWorkoutId == -1) {
      await databaseService.addWorkout(widget.exerciseId);
      fetchedWorkoutId =
          await databaseService.getWorkout(widget.routineId, widget.exerciseId);
    }
    setState(() {
      workoutId = fetchedWorkoutId;
    });
  }

  @override
  void initState() {
    super.initState();
    createWorkout();
  }

  Widget setData() {
    if (workoutId == -1) {
      return Center(
          child:
              CircularProgressIndicator()); // Show loading indicator if workoutId isn't set yet.
    }

    return FutureBuilder(
      future: databaseService.getSetsOfWorkout(
          widget.routineId, widget.exerciseId, workoutId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Show loading indicator
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No sets available"));
        }

        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            SetModel set = snapshot.data![index];
            return ListTile(
              title: Text('Set #${set.setNumber}'),
              subtitle: Text('Reps: ${set.reps} | Weight: ${set.weight}'),
            );
          },
        );
      },
    );
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
                databaseService.addWorkoutWithDate(
                    widget.exerciseId, DateTime.now().toIso8601String());

                print(databaseService.getSetsOfAllWorkouts(
                    widget.routineId, widget.exerciseId));
              },
              icon: Icon(Icons.edit_attributes)),
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
      floatingActionButton: AddSetPopup(
        workoutId: workoutId,
        totalSet: 4,
        routineId: widget.routineId,
        exerciseId: widget.exerciseId,
        onAddSet: () {
          setState(() {});
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text("Workout id is $workoutId"),
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
                minRep: widget.minRep, // Add appropriate value
                maxRep: widget.maxRep, // Add appropriate value
                progressOverload: widget.monthlyProgressGoals,
                risk: widget.risk, // Add appropriate value
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Divider(),
              ),
              // ProrgessTable(
              //   routineId: widget.routineId,
              //   exerciseId: widget.exerciseId,
              //   workoutId: workoutId,
              // ),
              SizedBox(
                height: 100,
              ),
              SizedBox(height: 200, child: setData())
            ],
          ),
        ),
      ),
    );
  }
}
