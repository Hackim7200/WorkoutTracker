import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracker/components/my_data.dart';
import 'package:workout_tracker/components/note.dart';
import 'package:workout_tracker/components/prorgess_table.dart';

class Progress extends StatefulWidget {
  Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  MyData myData = MyData();

  @override
  Widget build(BuildContext context) {
    void addRowDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Title"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'KG'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Rep'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'KG'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Rep'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'KG'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Rep'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'KG'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Rep'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                )
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      // this not working
                      List<dynamic> newRow = [
                        myData.rowCount + 1, // New ID
                        '01 Feb 24', // New Date
                        [0.0, 0], [0.0, 0], [0.0, 0],
                        [0.0, 0] // New workout data
                      ];

                      // Add the new row to the data source
                      myData.addRow(newRow);
                      Navigator.pop(context);
                    },
                    child: Text("Create"))
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "P R O G R E S S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addRowDialog,
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Note(type: "caution", messages: ["Please fill in all fields."]),
            Note(type: "tips", messages: ["This is a note card."]),
            ProrgessTable(),
            Note(type: "info", messages: ["This is a note card."]),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
