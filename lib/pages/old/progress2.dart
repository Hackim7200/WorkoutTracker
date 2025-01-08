
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracker/components/my_data.dart';
import 'package:workout_tracker/components/prorgess_table.dart';

class Progress2 extends StatefulWidget {
  Progress2({super.key});

  @override
  State<Progress2> createState() => _Progress2State();
}

class _Progress2State extends State<Progress2> {
  MyData myData = MyData();

  @override
  Widget build(BuildContext context) {
    void addRowDialog() {
      List<Map<String, dynamic>> sets = [
        {'kg': '', 'rep': ''},
      ];

      void addSet() {
        setState(() {
          sets.add({'kg': '', 'rep': ''});
        });
      }

      void removeSet(int index) {
        setState(() {
          if (sets.length > 1) sets.removeAt(index);
        });
      }

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Add Progress"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...sets.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> set = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'KG',
                                    border: OutlineInputBorder(),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) => setState(() {
                                    set['kg'] = value;
                                  }),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Rep',
                                    border: OutlineInputBorder(),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) => setState(() {
                                    set['rep'] = value;
                                  }),
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () => removeSet(index),
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: addSet,
                        icon: Icon(Icons.add),
                        label: Text("Add Set"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bool isValid = sets.every((set) =>
                          set['kg'].isNotEmpty && set['rep'].isNotEmpty);
                      if (isValid) {
                        // Prepare data
                        List<dynamic> newRow = [
                          myData.rowCount + 1, // New ID
                          '01 Feb 24', // New Date
                          ...sets.map((set) => [
                                double.parse(set['kg']),
                                int.parse(set['rep']),
                              ])
                        ];

                        // Add the new row to the data source
                        myData.addRow(newRow);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please fill in all fields."),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: Text("Create"),
                  ),
                ],
              );
            },
          );
        },
      );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepOrangeAccent,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Note:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "\u2022 Deadlift is very high risk and reward exercise. Make sure you use proper form and technique.",
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ProrgessTable(),
        ],
      ),
    );
  }
}
