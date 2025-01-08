import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Routine> routines = [
    Routine('Chest & Tricep Routine', 'assets/stretching.png'),
    Routine('Back & Bicep Routine', 'assets/stretching.png'),
    Routine('Leg Day Routine', 'assets/stretching.png'),
    Routine('Shoulder & Abs Routine', 'assets/stretching.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Routines'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) {
            return RoutineCard(routine: routines[index]);
          },
        ),
      ),
    );
  }
}

class Routine {
  final String title;
  final String imagePath;

  Routine(this.title, this.imagePath);
}

class RoutineCard extends StatelessWidget {
  final Routine routine;

  RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.asset(
              routine.imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                routine.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
