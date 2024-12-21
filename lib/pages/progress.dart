import 'package:flutter/material.dart';
import 'package:workout_tracker/components/prorgess_table.dart';

class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context) {
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
        onPressed: () => Navigator.pushNamed(context, "/progress"),
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.save),
      ),
      body: ProrgessTable(),

    );
  }
}
