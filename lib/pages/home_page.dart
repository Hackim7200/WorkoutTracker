import 'package:flutter/material.dart';
import 'package:workout_tracker/components/my_dialog.dart';
import 'package:workout_tracker/components/workout_tile.dart';
import 'package:workout_tracker/pages/routine_exercises.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.amberAccent,
              title: Text("Add a new workout"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Routine name'),
                ),
                DropdownButton<String>(
                  // value: dropdownValue,/
                  onChanged: (String? newValue) {
                    // dropdownValue = newValue!;
                  },
                  items: <String>['Cardio', 'Weight lifting', 'Stretching']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(onPressed: () {}, child: Text("Create"))
              ],
            );
          });
    }

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
        onPressed: () => _showDialog(),
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
                  onTapCard: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoutineExercises(
                          workoutName: workoutList[index],
                        ),
                      ),
                    );
                  },
                  onTapOption: () {
                    debugPrint("the option was clicked");
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
