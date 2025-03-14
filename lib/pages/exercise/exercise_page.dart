import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/exercise/exercise_tile.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/exercise_model.dart';
import 'package:workout_tracker/pages/exercise/add_exercise.dart';

import 'package:workout_tracker/pages/progress/progress_page.dart';
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loader while fetching data
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading exercises"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No exercises found"));
            }

            return ReorderableListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ExerciseModel exercise = snapshot.data![index];
                  return ExerciseTile(
                    key: ValueKey(exercise.id),
                    title: exercise.title,
                    img: "assets/images/muscles/${exercise.image}",
                    info: exercise.muscleGroups,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgressPage(
                            currentImage: exercise.image,
                            exerciseId: exercise.id,
                            routineId: widget.routineId,
                            monthlyProgress: exercise.monthlyProgressGoals,
                            minRep: exercise.minRep,
                            maxRep: exercise.maxRep,
                            type: exercise.type,
                            risk: exercise.risk,
                            numberOfSets: exercise.sets,
                          ),
                        ),
                      );
                    },
                  );
                },
                onReorder: (int oldIndex, int newIndex) async {
                  if (oldIndex < newIndex) {
                    newIndex -=
                        1; // Adjust index since the list shrinks temporarily
                  }

                  final movedExercise = snapshot.data![oldIndex];

                  setState(() {
                    final updatedList = List.from(snapshot.data!);
                    updatedList.insert(
                        newIndex, updatedList.removeAt(oldIndex));
                    snapshot.data!.clear();
                    snapshot.data!.addAll(updatedList.cast<ExerciseModel>());
                  });

                  await databaseService.reorderExercise(
                    movedExercise.id,
                    oldIndex,
                    newIndex,
                  );
                });
          });
    }

    return Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "E X E R C I S E",
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
                        routineId: widget.routineId,
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() {}); // Only refresh if needed
                    }
                  });
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
