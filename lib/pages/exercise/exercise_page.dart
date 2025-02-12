import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/exercise/exercise_tile.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/exercise_model.dart';
import 'package:workout_tracker/pages/exercise/add_exercise.dart';

import 'package:workout_tracker/pages/progress/weight_progress/weight_progress_page.dart';
import 'package:workout_tracker/pages/routine/edit_routine.dart';

class ExercisePage extends StatefulWidget {
  final int routineId;
  final String currentImage;

  const ExercisePage({
    super.key,
    required this.currentImage,
    required this.routineId,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
// Widget _exercisesList (){
//   // return FutureBuilder(future: future, builder: builder)
// }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

    Widget exerciseList() {
      return FutureBuilder(
          future: databaseService.getExercises(widget.routineId),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  ExerciseModel exercise = snapshot.data![index];

                  return ExerciseTile(
                    title: exercise.title,
                    img: "assets/images/muscles/${exercise.image}",
                    info: exercise.muscleGroups,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WeightProgressPage(
                                    currentImage: exercise.image,
                                    exerciseId: exercise.id,
                                    routineId: widget.routineId,
                                    monthlyProgressGoals:
                                        exercise.monthlyProgressGoals,
                                    minRep: exercise
                                        .minRep, // Add appropriate value
                                    maxRep: exercise
                                        .maxRep, // Add appropriate value
                                    risk: exercise.risk,
                                    maxSet: exercise.sets, //
                                  )));
                    },
                  );
                });
          });
    }

    return Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "E X E R C I S E S",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: appBarColor,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditRoutine(
                                selectedImage: widget.currentImage,
                              )));
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExercise(
                                selectedImage: '',
                                routineId: widget.routineId,
                              ))).then((_) {
                    setState(() {});
                  });
                },
                icon: Icon(Icons.add_box))
          ],
        ),
        body: exerciseList());
  }
}
