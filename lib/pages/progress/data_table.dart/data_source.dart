import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:intl/intl.dart';

class DataSource extends DataTableSource {
  List<Map<String, dynamic>> workouts = [];
  final int setNumber;
  final int routineId;
  final int exerciseId;

  DataSource(this.setNumber, this.routineId, this.exerciseId) {
    loadData();
  }

  Future<void> loadData() async {
    final DatabaseService databaseService = DatabaseService.instance;
    workouts =
        await databaseService.getSetsOfAllWorkouts(routineId, exerciseId);
    notifyListeners();
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      DateTime dateTime = DateTime.parse(isoDate);
      return DateFormat("dd MMM yy").format(dateTime);
    } catch (e) {
      return "-"; // Fallback if parsing fails
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= workouts.length) return null;

    List<dynamic> weights = workouts[index]["weights"] ?? [];
    List<dynamic> reps = workouts[index]["reps"] ?? [];

    List<DataCell> cells = [];

    // Add date cell
    cells.add(DataCell(Text(formatDate(workouts[index]["date"]?.toString()))));

    // Dynamically add sets based on setNumber
    for (int i = 0; i < setNumber; i++) {
      String weightText = (i < weights.length) ? weights[i].toString() : "-";
      String repsText = (i < reps.length) ? reps[i].toString() : "-";

      cells.add(DataCell(Text(weightText)));
      cells.add(DataCell(Text(repsText)));
    }

    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => workouts.length;

  @override
  int get selectedRowCount => 0;

  // void addRow(Map<String, dynamic> newRow) {
  //   workouts.add(newRow);
  //   notifyListeners(); // Notify listeners to update the table
  // }

  void refresh() {
    loadData();
  }
}
