import 'package:flutter/material.dart';
import 'package:workout_tracker/components/workout_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List workoutList = [
      "Back",
      "Chest",
      "Arms",
      "Shoulders",
      "Legs",
      "forearms",
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "W O R K O U T S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/routine"),
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        // Safe area is the section outside the abstruction of camera lens and edge
        child: Column(
          children: [
            Expanded(
                child: GridView.builder(
              itemCount: workoutList.length, // the number of item is grid
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2), // number of columns per row
              // this is like list.map((index)=>{}) in js
              itemBuilder: (context, index) {
                return WorkoutTile(
                  title: workoutList[index].toString(),
                  onTapCustom: () {
                    debugPrint("the function is working!!");
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  void onPressed() {}
}
