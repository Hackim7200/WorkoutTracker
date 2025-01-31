import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/goalBar/risk.dart';

class GoalsBar extends StatelessWidget {
  final int minRep;
  final int maxRep;
  final double progressOverload;
  final String risk;
  const GoalsBar(
      {super.key,
      required this.minRep,
      required this.maxRep,
      required this.progressOverload,
      required this.risk});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);

    return Center(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 0.3,
                color: cardColor,
                child: ListTile(
                  leading: Icon(
                    Icons.golf_course_sharp,
                    size: 40,
                  ),
                  title: Text("Monthly"),
                  subtitle: Text("${progressOverload.toString()} kg increase"),
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 0.3,
                color: cardColor,
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_drop_up,
                    size: 40,
                  ),
                  title: Text("Max"),
                  subtitle: Text("${maxRep.toString()} reps"),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Risk(risk: risk),
            Expanded(
              child: Card(
                elevation: 0.3,
                color: cardColor,
                child: ListTile(
                  leading: Icon(Icons.arrow_drop_down, size: 40),
                  title: Text("Min"),
                  subtitle: Text("${minRep.toString()} reps"),
                ),
              ),
            ),
          ],
        ),

        // SizedBox(
        //     height: 100,
        //     child: Row(
        //       children: [
        //         Goal(
        //             backgroundColour: Colors.cyan,
        //             title: "Monthly Increase",
        //             value: progressOverload.toString(),
        //             textColour: textColor),
        //         Risk(
        //           risk: risk,
        //         )
        //       ],
        //     )),
        // SizedBox(
        //     height: 100,
        //     child: Row(
        //       children: [
        //         Goal(
        //             backgroundColour: Colors.amberAccent,
        //             title: "Maximum",
        //             value: "10",
        //             textColour: textColor),
        //         Goal(
        //             backgroundColour: Colors.orangeAccent,
        //             title: "Minimum",
        //             value: "5",
        //             textColour: textColor),
        //       ],
        //     )),
      ],
    ));
  }
}
