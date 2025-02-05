import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/data_table.dart/data_source.dart';

class ProgressTable extends StatelessWidget {
  final int setNumber;
  final int routineId;
  final int exerciseId;
  const ProgressTable(
      {super.key,
      required this.setNumber,
      required this.routineId,
      required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    final DataSource dataSource = DataSource(setNumber, routineId, exerciseId);
    final numberOfRows = dataSource.rowCount;
    final numberOfRowsPerPage = 9;
    final TextStyle fontStyle = TextStyle(
      color: Colors.grey,
      fontSize: 15,
    );

    // Calculate the starting row index for the last page
    final initialRowIndex = (numberOfRows > numberOfRowsPerPage)
        ? (numberOfRows - numberOfRowsPerPage)
        : 0;

    List<DataColumn> columns = [];
    columns.add(DataColumn(label: Text("date", style: fontStyle)));
    for (int i = 0; i < setNumber; i++) {
      columns.add(DataColumn(label: Text("| weight", style: fontStyle)));
      columns.add(DataColumn(label: Text(" rep", style: fontStyle)));
    }

    return FutureBuilder(
      future: dataSource.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return PaginatedDataTable(
          rowsPerPage: 9,
          source: dataSource,
          columnSpacing: 10,
          dataRowMaxHeight: 30,
          dataRowMinHeight: 30,
          initialFirstRowIndex:
              initialRowIndex, // Set to the last page's first row

          columns: columns,
        );
      },
    );

    // return PaginatedDataTable(
    //   rowsPerPage: numberOfRowsPerPage,
    //   source: dataSource,
    //   columnSpacing: 10,
    //   dataRowMaxHeight: 30,
    //   dataRowMinHeight: 30,
    //   initialFirstRowIndex: initialRowIndex, // Set to the last page's first row

    //   columns: columns,
    // );
  }
}
