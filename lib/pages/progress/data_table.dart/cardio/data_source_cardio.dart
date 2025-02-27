import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:intl/intl.dart';

class DataSourceCardio extends DataTableSource {
  List<Map<String, dynamic>> workouts = [];
  final int setNumber;
  final int routineId;
  final int exerciseId;

  DataSourceCardio(this.setNumber, this.routineId, this.exerciseId) {
    loadData();
  }

  Future<void> loadData() async {
    final DatabaseService databaseService = DatabaseService.instance;
    workouts =
        await databaseService.getCardioSetsOfAllWorkouts(routineId, exerciseId);
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

  Color getColorFromPercentage(double percent) {
    if (percent < 0) {
      return Color.fromARGB(255, 255, 0, 212); // Soft
    } else if (percent >= 1 && percent < 3) {
      return Color(0xFFC8E6C9); // Soft Pastel Green
    } else if (percent >= 3 && percent < 5) {
      return Color(0xFFA5D6A7); // Light Mint Green
    } else if (percent >= 5 && percent < 7) {
      return Color(0xFF81C784); // Soft Medium Green
    } else if (percent >= 7 && percent < 9) {
      return Color(0xFFFFF9C4); // Light Cream Yellow
    } else if (percent >= 9 && percent < 11) {
      return Color(0xFFFFF59D); // Soft Yellow
    } else if (percent >= 11 && percent < 13) {
      return Color(0xFFFFE082); // Warm Golden Yellow
    } else if (percent >= 13 && percent < 15) {
      return Color(0xFFFFD54F); // Soft Amber
    } else if (percent >= 15 && percent < 17) {
      return Color(0xFFFFCC80); // Light Peach Orange
    } else if (percent >= 17 && percent < 19) {
      return Color(0xFFFFAB91); // Warm Soft Orange
    } else if (percent >= 19 && percent < 21) {
      return Color(0xFFFF8A80); // Soft Coral Red
    } else if (percent >= 21 && percent < 23) {
      return Color(0xFFE57373); // Light Red
    } else if (percent >= 23 && percent < 25) {
      return Color(0xFFD32F2F); // Medium Red
    } else if (percent >= 25) {
      return Color(0xFFB71C1C); // Deep Red for max danger
    }
    return Colors.transparent; // Default fallback
  }

  @override
  DataRow? getRow(int index) {
    if (index >= workouts.length) return null;

    List<dynamic> intensities = workouts[index]["intensities"] ?? [];
    List<dynamic> time = workouts[index]["times"] ?? [];
    List<dynamic> percentageChange = workouts[index]["percentageChanges"] ?? [];

    List<DataCell> cells = [];

    // Add date cell
    cells.add(DataCell(Text(formatDate(workouts[index]["date"]?.toString()))));

    // Dynamically add sets based on setNumber
    for (int i = 0; i < setNumber; i++) {
      String intensitiesText =
          (i < intensities.length) ? intensities[i].toString() : "-";
      String timeText = (i < time.length) ? time[i].toString() : "-";

      double percentChange =
          (i < percentageChange.length) ? percentageChange[i] : 0.0;

      if (intensitiesText == "0" || intensitiesText == "0.0") {
        intensitiesText = "-";
      }
      if (timeText == "0" || timeText == "0.0") {
        timeText = "-";
      }

      Color newColour = getColorFromPercentage(percentChange);

      cells.add(DataCell(Center(child: Text(intensitiesText))));
      cells.add(
        DataCell(
            Container(color: newColour, child: Center(child: Text(timeText)))),
      );
    }

    return DataRow(cells: cells);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => workouts.length;

  @override
  int get selectedRowCount => 0;
}
