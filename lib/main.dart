import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/routine/routine_page.dart';
import 'package:workout_tracker/reorder_list_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workrout App",
      theme: ThemeData(),
      home: 
      // ReorderListExample(),
      RoutinePage(),
      routes: {
        // '/': (context) => HomePage(),
        // '/exercise': (context) => ExercisePage(currentImage: '', routineId: null,),
        // '/routine': (context) => RoutinePage(),
      },
    );
  }
}
