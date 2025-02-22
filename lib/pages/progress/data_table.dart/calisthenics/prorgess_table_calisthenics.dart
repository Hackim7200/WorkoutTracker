import 'package:flutter/material.dart';

import 'package:workout_tracker/pages/progress/data_table.dart/calisthenics/data_source_calisthenics.dart';

class ProgressTableCalisthenics extends StatelessWidget {
  final int setNumber;
  final int routineId;
  final int exerciseId;
  const ProgressTableCalisthenics({
    super.key,
    required this.setNumber,
    required this.routineId,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context) {
    final DataSourceCalisthenics dataSource =
        DataSourceCalisthenics(setNumber, routineId, exerciseId);
    final int numberOfRowsPerPage = 9;
    final TextStyle fontStyle = TextStyle(
      color: Colors.grey,
      fontSize: 15,
    );

    List<DataColumn> columns = [];
    columns.add(DataColumn(label: Text("Date", style: fontStyle)));
    for (int i = 0; i < setNumber; i++) {
      columns.add(DataColumn(label: Text("| Weight", style: fontStyle)));
      columns.add(DataColumn(label: Text("Rep", style: fontStyle)));
    }

    return FutureBuilder(
      future: dataSource.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Error loading data. Please try again."),
          );
        }

        if (dataSource.rowCount == 0) {
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              "There is no workout data available. Please create a workout 🙂",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Calculate the starting row index for the last page
        final int initialRowIndex = (dataSource.rowCount > numberOfRowsPerPage)
            ? (dataSource.rowCount - numberOfRowsPerPage)
            : 0;
        final double columnSpacing = setNumber == 1 ? 56.0 : 10.0;

        return PaginatedDataTable(
          rowsPerPage: numberOfRowsPerPage,
          source: dataSource,
          columnSpacing: columnSpacing,
          dataRowMaxHeight: 30,
          dataRowMinHeight: 30,
          initialFirstRowIndex: initialRowIndex,
          columns: columns,
        );
      },
    );
  }
}
