import 'package:flutter/material.dart';
import 'package:workout_tracker/components/workout_tile.dart';
import 'package:workout_tracker/pages/exercise/exercises.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> workoutList = [
    {"id": 1, "routine": "Back", 'type': 'weights'},
    {"id": 2, "routine": "Chest", 'type': 'cardio'},
    {"id": 3, "routine": "Arms", 'type': 'stretching'},
    {"id": 4, "routine": "Shoulders", 'type': 'weights'},
    {"id": 5, "routine": "Legs", 'type': 'cardio'},
    {"id": 6, "routine": "Forearms", 'type': 'weights'}
  ];

  final List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(value: 'cardio', child: Text('Cardio')),
    DropdownMenuItem(value: 'stretching', child: Text('Stretching')),
    DropdownMenuItem(value: 'weights', child: Text('Weightlifting')),
  ];

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: workoutList.length,
        itemBuilder: (BuildContext context, int index) {
          return WorkoutTile(
            title: workoutList[index]['routine'],
            type: workoutList[index]['type'],
            onTapCard: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Exercises(
                          // workoutName: workoutList[index]['routine'],
                          )));
            },
            onTapOption: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: showRoutineDialog, child: Icon(Icons.add)),
    );
  }

  void showRoutineDialog() {
    String dropdownValue =
        'cardio'; // Set initial value inside the dialog scope
    controller.clear(); // Clear the text field

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              // Use StatefulBuilder for the dialog's state
              return AlertDialog(
                title: Text("Add a new workout"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: 'Routine name',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      items: dropdownItems,
                      value: dropdownValue,
                      onChanged: (String? selectedValue) {
                        setDialogState(() {
                          dropdownValue = selectedValue!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          workoutList.add({
                            "id": workoutList.length + 1,
                            "routine": controller.text,
                            "type": dropdownValue
                          });
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Create"))
                ],
              );
            },
          );
        });
  }
}
