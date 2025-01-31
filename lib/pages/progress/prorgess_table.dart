import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/user_data_source.dart';

class ProrgessTable extends StatelessWidget {
  final int routineId, exerciseId, workoutId;

  const ProrgessTable(
      {super.key,
      required this.routineId,
      required this.exerciseId,
      required this.workoutId});

  @override

  Widget build(BuildContext context) {
    final UserDataSource mydata = UserDataSource(routineId, exerciseId, workoutId);

    final numberOfRows = mydata.rowCount;
    final numberOfRowsPerPage = 9;

    return PaginatedDataTable(
      rowsPerPage: numberOfRowsPerPage,
      source: mydata,
      columnSpacing: 10,

      // both needs to be set or it wont work
      dataRowMaxHeight: 30,
      dataRowMinHeight: 30,

      // this is used to determine which page you start on pased on what row you give it
      // if the last row is 30 than table will be on 30th row
      // if last row is on 30 but you want to see 5 items before you do 30-5
      initialFirstRowIndex: numberOfRows - numberOfRowsPerPage,

      columns: [
        DataColumn(
            label: Text("Date"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("KG"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("Rep"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("KG"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("Rep"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("KG"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("Rep"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("KG"), headingRowAlignment: MainAxisAlignment.center),
        // DataColumn(
        //     label: Text("Rep"), headingRowAlignment: MainAxisAlignment.center),
      ],
    );
  }
}
