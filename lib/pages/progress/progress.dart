import 'package:flutter/material.dart';
import 'package:workout_tracker/components/my_data.dart';
import 'package:workout_tracker/components/note.dart';
import 'package:workout_tracker/components/prorgess_table.dart';
import 'package:workout_tracker/components/set_input.dart';

class Progress extends StatefulWidget {
  Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
  final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
  final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
  final Color textColor = Color.fromRGBO(61, 61, 61, 1);

  MyData myData = MyData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "P R O G R E S S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Note(type: "caution", messages: ["Please fill in all fields."]),
            Note(type: "tips", messages: ["This is a note card."]),
            ProrgessTable(),
            Note(type: "info", messages: ["This is a note card."]),
            SetInput(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
