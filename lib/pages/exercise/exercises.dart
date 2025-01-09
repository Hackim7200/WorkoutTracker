import 'package:flutter/material.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/pages/exercise/add_exercise.dart';
import 'package:workout_tracker/pages/exercise/exercises_option.dart';
import 'package:workout_tracker/pages/progress/progress.dart';

class Exercises extends StatefulWidget {
  const Exercises({
    super.key,
  });

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

    final List<List<String>> exercises = [
      ["Pull-Ups", "Lats, Biceps, Rear Delts, Core", "14228733.png"],
      ["Deadlifts", "Hamstrings, Glutes, Lower Back, Traps", "142287352.png"],
      ["Barbell Rows", "Lats, Rhomboids, Traps, Biceps", "14228738.png"],
      ["Dumbbell Rows", "Lats, Rhomboids, Traps, Biceps", "142287402.png"],
      ["Lat Pulldowns", "Lats, Biceps, Rear Delts, Rhomboids", "14228743.png"],
      ["Seated Cable Rows", "Lats, Rhomboids, Traps, Biceps", "142287452.png"],
      ["T-Bar Rows", "Lats, Rhomboids, Traps, Biceps", "14228748.png"],
      ["Face Pulls", "Rear Delts, Traps, Rotator Cuff", "142287522.png"],
      ["Hyperextensions", "Lower Back, Glutes, Hamstrings", "14228758.png"],
      ["Inverted Rows", "Lats, Rhomboids, Traps, Biceps", "142287612.png"],
      ["Chin-Ups", "Biceps, Lats, Core, Rear Delts", "142287332.png"],
      ["Bent-Over Rows", "Lats, Traps, Rhomboids, Rear Delts", "14228736.png"],
      ["Pendlay Rows", "Lats, Traps, Rhomboids, Lower Back", "142287382.png"],
      ["Good Mornings", "Lower Back, Hamstrings, Glutes", "14228741.png"],
      ["Straight-Arm Pulldowns", "Lats, Triceps, Rear Delts", "142287432.png"],
    ];

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddExercise(selectedImage: '',)));
                },
                icon: Icon(Icons.add_box))
          ],
        ),
        body: ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return ExerciseTile(
                info: exercises[index][1],
                img: "assets/images/muscles/${exercises[index][2]}",
                title: exercises[index][0],
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Progress()));
                },
              );
            }));
  }
}
