import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/routine/routine_page.dart';


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

      RoutinePage(),
      routes: {
        // '/': (context) => HomePage(),
        // '/exercise': (context) => ExercisePage(currentImage: '', routineId: null,),
        // '/routine': (context) => RoutinePage(),
      },
    );
  }
}
