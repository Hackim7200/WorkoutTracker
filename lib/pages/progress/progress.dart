import 'package:flutter/material.dart';
import 'package:workout_tracker/components/my_data.dart';
import 'package:workout_tracker/components/prorgess_table.dart';
import 'package:workout_tracker/components/set_input.dart';
import 'package:workout_tracker/pages/Notes/notes.dart';

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
    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: scaffoldColor, // Background color of bottom sheet
            child: Center(
                child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "Record your sets",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Divider(),
                ),
                SetInput(),
              ],
            )),
          );
        },
      );
    }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingIconColor,
        foregroundColor: textColor,
        child: Icon(Icons.receipt_long_rounded),
        onPressed: () {
          showBottomSheet(context);
        },
      ),
      body: Column(
        children: [
          ProrgessTable(),
          SizedBox(height: 10),
          Text(
            "N O T E S",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
          Notes(),
          // SizedBox(height: 100),
        ],
      ),
    );
  }
}
