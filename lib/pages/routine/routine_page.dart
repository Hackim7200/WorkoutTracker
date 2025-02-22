import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/routine/add_routine_2.dart';
import 'package:workout_tracker/pages/routine/routine_tile.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/routine_model.dart';

import 'package:workout_tracker/pages/exercise/exercise_page.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final DatabaseService databaseService = DatabaseService.instance;

  Widget _routinesList() {
    return FutureBuilder(
        future: databaseService.getRoutines(),
        builder: (context, snapshot) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              RoutineModel routine = snapshot.data![index];

              return RoutineTile(
                title: routine.title,
                description: routine.description,
                image: "assets/images/bodySections/${routine.image}",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisePage(
                              currentImage: routine.image,
                              routineId: routine.id)));
                },
              );
            },
          );
        });
  }

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
                        builder: (context) => AddRoutine2(
                              selectedImage: '',
                            ))).then((_) {

                  setState(() {});
                });
              },
              icon: Icon(Icons.add_box)),
        ],
      ),
      body:
          Padding(padding: const EdgeInsets.all(12.0), child: _routinesList()),
    );
  }
}
