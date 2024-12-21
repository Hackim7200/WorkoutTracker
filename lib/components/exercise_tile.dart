import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final title = "";
  final ischecked = false;

  const ExerciseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Pull ups",
                  style: TextStyle(fontSize: 24), // Customize as needed
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.amber,
                child: ischecked
                    ? Icon(Icons.check)
                    : Icon(Icons.check_box_outline_blank_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
