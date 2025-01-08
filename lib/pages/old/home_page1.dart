import 'package:flutter/material.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  List routines = [
    [
      "Full body",
      "The workout is for full body focusing on compound movements",
      "assets/images/fullbody.jpg"
    ],
    [
      "Upper body",
      "The workout is for upper body focusing on compound movements",
      "assets/images/upperbody.jpg"
    ],
    [
      "Lower body",
      "The workout is for lower body focusing on compound movements",
      "assets/images/lowerbody.jpg"
    ],
    [
      "Core",
      "The workout is for core focusing on compound movements",
      "assets/images/core.jpg"
    ],
    [
      "Cardio",
      "The workout is for cardio focusing on compound movements",
      "assets/images/cardio.jpg"
    ],
    [
      "Yoga",
      "The workout is for yoga focusing on compound movements",
      "assets/images/yoga.jpg"
    ],
    [
      "Stretching",
      "The workout is for stretching focusing on compound movements",
      "assets/images/stretching.jpg"
    ],
    [
      "Crossfit",
      "The workout is for crossfit focusing on compound movements",
      "assets/images/crossfit.jpg"
    ],
    [
      "Calisthenics",
      "The workout is for calisthenics focusing on compound movements",
      "assets/images/calisthenics.jpg"
    ],
    [
      "Weightlifting",
      "The workout is for weightlifting focusing on compound movements",
      "assets/images/weightlifting.jpg"
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Workout Routines'), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.orangeAccent
                  ], // Orange to Light Orange gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    // routines[index][2],
                    "assets/images/bodySections/6583949.png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  routines[index][0],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  routines[index][1],
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                trailing: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
