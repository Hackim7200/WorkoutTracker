import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/routine/routine.dart';
import 'package:workout_tracker/pages/progress/progress.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bodySections = [
      "6583949.png",
      "65839532.png",
      "6583959.png",
      "65839632.png",
      "6583969.png",
      "65839732.png",
      "6583979.png",
      "65839832.png",
      "6583988.png",
      "65839922.png",
      "65839492.png",
      "6583955.png",
      "65839592.png",
      "6583965.png",
      "65839692.png",
      "6583975.png",
      "65839792.png",
      "6583984.png",
      "65839882.png",
      "6583994.png",
      "6583951.png",
      "65839552.png",
      "6583961.png",
      "65839652.png",
      "6583971.png",
      "65839752.png",
      "6583981.png",
      "65839842.png",
      "6583990.png",
      "65839942.png",
      "65839512.png",
      "6583957.png",
      "65839612.png",
      "6583967.png",
      "65839712.png",
      "6583977.png",
      "65839812.png",
      "6583986.png",
      "65839902.png",
      "6583953.png",
      "65839572.png",
      "6583963.png",
      "65839672.png",
      "6583973.png",
      "65839772.png",
      "6583983.png",
      "65839862.png",
      "6583992.png"
    ];
    final List<String> muscles = [
      '14228733.png',
      '142287352.png',
      '14228738.png',
      '142287402.png',
      '14228743.png',
      '142287452.png',
      '14228748.png',
      '142287522.png',
      '14228758.png',
      '142287612.png',
      '142287332.png',
      '14228736.png',
      '142287382.png',
      '14228741.png',
      '142287432.png',
      '14228746.png',
      '142287482.png',
      '14228754.png',
      '142287582.png',
      '14228764.png',
      '14228734.png',
      '142287362.png',
      '14228739.png',
      '142287412.png',
      '14228744.png',
      '142287462.png',
      '14228749.png',
      '142287542.png',
      '14228760.png',
      '142287642.png',
      '142287342.png',
      '14228737.png',
      '142287392.png',
      '14228742.png',
      '142287442.png',
      '14228747.png',
      '142287492.png',
      '14228756.png',
      '142287602.png',
      '14228735.png',
      '142287372.png',
      '14228740.png',
      '142287422.png',
      '14228745.png',
      '142287472.png',
      '14228752.png',
      '142287562.png',
      '14228761.png'
    ];

    return MaterialApp(
      title: "Workrout App",
      theme: ThemeData(),
      home: Routine(),
      routes: {
        "/homepage": (context) => Routine(),
        // "/routine": (context) => const RoutineExercises(),
        "/progress": (context) => Progress(),
      },
    );
  }
}
