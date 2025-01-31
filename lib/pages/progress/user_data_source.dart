import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/exercise_model.dart';
import 'package:workout_tracker/database/models/set_model.dart';

class UserDataSource extends DataTableSource {
  final DatabaseService databaseService = DatabaseService.instance;

  List<SetModel> workoutData = [];

  // final List<List<dynamic>> workouts = [
  //   [
  //     1,
  //     '01 Jan 24',
  //     [12.3, 11]
  //   ],
  //   [
  //     2,
  //     '02 Jan 24',
  //     [15.4, 12]
  //   ],
  //   [
  //     3,
  //     '03 Jan 24',
  //     [18.6, 10]
  //   ],
  //   [
  //     4,
  //     '04 Jan 24',
  //     [14.2, 11]
  //   ],
  //   [
  //     5,
  //     '05 Jan 24',
  //     [16.7, 12]
  //   ],
  //   [
  //     6,
  //     '06 Jan 24',
  //     [19.0, 10]
  //   ],
  //   [
  //     7,
  //     '07 Jan 24',
  //     [13.5, 11]
  //   ],
  //   [
  //     8,
  //     '08 Jan 24',
  //     [11.9, 12]
  //   ],
  //   [
  //     9,
  //     '09 Jan 24',
  //     [17.1, 10]
  //   ],
  //   [
  //     10,
  //     '10 Jan 24',
  //     [15.3, 12]
  //   ],
  //   [
  //     11,
  //     '11 Jan 24',
  //     [14.8, 11]
  //   ],
  //   [
  //     12,
  //     '12 Jan 24',
  //     [18.2, 10]
  //   ],
  //   [
  //     13,
  //     '13 Jan 24',
  //     [13.3, 12]
  //   ],
  //   [
  //     14,
  //     '14 Jan 24',
  //     [11.6, 11]
  //   ],
  //   [
  //     15,
  //     '15 Jan 24',
  //     [19.5, 10]
  //   ],
  //   [
  //     16,
  //     '16 Jan 24',
  //     [16.0, 12]
  //   ],
  //   [
  //     17,
  //     '17 Jan 24',
  //     [14.9, 11]
  //   ],
  //   [
  //     18,
  //     '18 Jan 24',
  //     [17.8, 10]
  //   ],
  //   [
  //     19,
  //     '19 Jan 24',
  //     [12.2, 12]
  //   ],
  //   [
  //     20,
  //     '20 Jan 24',
  //     [16.4, 11]
  //   ],
  //   [
  //     21,
  //     '21 Jan 24',
  //     [11.7, 12]
  //   ],
  //   [
  //     22,
  //     '22 Jan 24',
  //     [13.8, 10]
  //   ],
  //   [
  //     23,
  //     '23 Jan 24',
  //     [19.1, 11]
  //   ],
  //   [
  //     24,
  //     '24 Jan 24',
  //     [17.6, 12]
  //   ],
  //   [
  //     25,
  //     '25 Jan 24',
  //     [14.4, 10]
  //   ],
  //   [
  //     26,
  //     '26 Jan 24',
  //     [18.3, 11]
  //   ],
  //   [
  //     27,
  //     '27 Jan 24',
  //     [15.6, 12]
  //   ],
  //   [
  //     28,
  //     '28 Jan 24',
  //     [11.5, 10]
  //   ],
  //   [
  //     29,
  //     '29 Jan 24',
  //     [17.2, 12]
  //   ],
  //   [
  //     30,
  //     '30 Jan 24',
  //     [16.1, 11]
  //   ],
  //   [
  //     31,
  //     '31 Jan 24',
  //     [12.9, 10]
  //   ],
  //   [
  //     32,
  //     '01 Feb 24',
  //     [14.5, 12]
  //   ],
  //   [
  //     33,
  //     '02 Feb 24',
  //     [13.1, 11]
  //   ],
  //   [
  //     34,
  //     '03 Feb 24',
  //     [19.2, 10]
  //   ],
  //   [
  //     35,
  //     '04 Feb 24',
  //     [15.0, 30]
  //   ],
  // ];

  final int routineId, exerciseId, workoutId;
  UserDataSource(this.routineId, this.exerciseId, this.workoutId) {
    // this is constructor
    _loadData();
  }

  Future<void> _loadData() async {
    workoutData = await databaseService.getSetsOfWorkout(
        routineId, exerciseId, workoutId); // Fetch data from SQLite
    notifyListeners(); // Notifies table to rebuild
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(
        workoutData[index].reps.toString(),
        style: TextStyle(color: Colors.lightBlueAccent),
      )),

      //   DataCell(Text(
      //     workouts[index][2][0].toString(),
      //     style: TextStyle(color: Colors.lightBlueAccent),
      //   )),
      //   DataCell(Text(workouts[index][2][1].toString(),
      //       style: TextStyle(color: Colors.lightBlueAccent))),
      //   DataCell(Text(
      //     workouts[index][2][0].toString(),
      //     style: TextStyle(color: Colors.orangeAccent),
      //   )),
      //   DataCell(Text(workouts[index][2][1].toString(),
      //       style: TextStyle(color: Colors.orangeAccent))),
      //   DataCell(Text(
      //     workouts[index][2][0].toString(),
      //     style: TextStyle(color: Colors.deepOrangeAccent),
      //   )),
      //   DataCell(Text(workouts[index][2][1].toString(),
      //       style: TextStyle(color: Colors.deepOrangeAccent))),
      //   DataCell(Text(
      //     workouts[index][2][0].toString(),
      //     style: TextStyle(color: const Color.fromARGB(255, 188, 13, 0)),
      //   )),
      //   DataCell(Text(workouts[index][2][1].toString(),
      //       style: TextStyle(color: const Color.fromARGB(255, 188, 13, 0)))),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => workoutData.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
  // Method to add a new row
  // void addRow(List<dynamic> newRow) {
  //   workouts.add(newRow);
  //   notifyListeners(); // Notify listeners to update the table
  // }
}
