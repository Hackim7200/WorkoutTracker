import 'package:flutter/material.dart';
import 'package:workout_tracker/components/routine_tile.dart';
import 'package:workout_tracker/pages/routine/add_routine.dart';
import 'package:workout_tracker/pages/routine/routine_options.dart';
import 'package:workout_tracker/pages/exercise/exercises.dart';

class Routine extends StatelessWidget {
  final List<List<String>> routines = [
    [
      "Full Body",
      "A balanced routine targeting the entire body.",
      "6583949.png"
    ],
    ["Legs", "Focus on building strength in your legs.", "6583951.png"],
    [
      "Chest",
      "Target your chest muscles for strength and definition.",
      "65839812.png"
    ],
    ["Arms", "Work on biceps, triceps, and forearms.", "6583951.png"],
    ["Back", "Improve posture and build back strength.", "6583949.png"],
    ["Core", "Strengthen your abs and stabilize your core.", "6583949.png"],
    ["Yoga", "Enhance flexibility and reduce stress with yoga.", "6583949.png"],
    [
      "Cardio",
      "Boost your endurance with high-intensity cardio.",
      "6583949.png"
    ],
    ["Stretching", "Improve flexibility and recover faster.", "6583949.png"],
  ];

  final List<List<Color>> gradients = [
    [Colors.orangeAccent, Colors.redAccent],
    [Colors.green, Colors.teal],
    [Color(0xFFffecd2), Color(0xFFfcb69f)], // Warm Cream to Sunset
    [Color(0xFFff8177), Color(0xFFff867a)], // Sunset Red to Warm Orange
    [Color(0xFF8fd3f4), Color(0xFF84fab0)], // Sky Blue to Soft Green
    [Color(0xFFa6c1ee), Color(0xFFfbc2eb)], // Light Blue to Pink Blend
    [Color(0xFFf9d423), Color(0xFFff4e50)], // Vibrant Yellow to Fiery Red
    [Color(0xFFc2e9fb), Color(0xFFa1c4fd)], // Light Sky Blue Gradient
  ];

  Routine({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "R O U T I N E S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRoutine(
                              selectedImage: '',
                            )));
              },
              icon: Icon(Icons.add_box))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemCount: routines.length,
          itemBuilder: (context, index) {
            return RoutineTile(
              title: routines[index][0],
              description: routines[index][1],
              image: "assets/images/bodySections/${routines[index][2]}",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Exercises(currentImage: routines[index][2])));
              },
            );
          },
        ),
      ),
    );
  }
}
