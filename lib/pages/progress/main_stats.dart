import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/goalBar/goal.dart';
import 'package:workout_tracker/pages/progress/weight_progress/data_table.dart/calisthenics/prorgess_table_calisthenics.dart';
import 'package:workout_tracker/pages/progress/weight_progress/data_table.dart/cardio/prorgess_table_cardio.dart';
import 'package:workout_tracker/pages/progress/weight_progress/data_table.dart/weightlifting/prorgess_table_weightlifting.dart';

class MainStats extends StatelessWidget {
  final String type, risk;
  final int minRep, maxRep, numberOfSets, routineId, exerciseId;
  final double progressOverload;

  const MainStats({
    super.key,
    required this.type,
    required this.risk,
    required this.minRep,
    required this.maxRep,
    required this.numberOfSets,
    required this.progressOverload,
    required this.routineId,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);

    Color riskColor;
    switch (risk) {
      case "HIGH":
        riskColor = const Color.fromARGB(255, 168, 83, 83);
        break;
      case "MED":
        riskColor = const Color.fromARGB(255, 234, 171, 76);
        break;
      case "LOW":
        riskColor = const Color.fromARGB(255, 104, 185, 107);
        break;
      default:
        riskColor = cardColor; // Fallback color
    }

    if (type == "weightlifting") {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5, // Adjusts item shape
              ),
              children: [
                Goal(
                  backgroundColour: riskColor,
                  title: "Injury Risk",
                  value: risk,
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "Monthly Progress",
                  value: "${progressOverload.toString()} kg",
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "type",
                  value: type,
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "sets",
                  value: "${numberOfSets}",
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "Min Reps",
                  value: "$minRep reps",
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "Max Reps",
                  value: "$maxRep reps",
                ),
              ],
            ),
          ),
          ProgressTableWeightlifting(
            setNumber: numberOfSets,
            routineId: routineId,
            exerciseId: exerciseId,
          )
        ],
      );
    } else if (type == "calisthenics") {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5, // Adjusts item shape
              ),
              children: [
                Goal(
                  backgroundColour: riskColor,
                  title: "Injury Risk",
                  value: risk,
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "Monthly Progress",
                  value: "${progressOverload.toString()} kg",
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "type",
                  value: type,
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "sets",
                  value: "${numberOfSets}",
                ),
              ],
            ),
          ),
          ProgressTableCalisthenics(
            setNumber: numberOfSets,
            routineId: routineId,
            exerciseId: exerciseId,
          )
        ],
      );
    } else if (type == "cardio") {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5, // Adjusts item shape
              ),
              children: [
                Goal(
                  backgroundColour: riskColor,
                  title: "Injury Risk",
                  value: risk,
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "Monthly Progress",
                  value: "${progressOverload.toString()} kg",
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "type",
                  value: type,
                ),
                Goal(
                  backgroundColour: cardColor,
                  title: "sets",
                  value: "${numberOfSets}",
                ),
              ],
            ),
          ),
          ProgressTableCardio(
            setNumber: numberOfSets,
            routineId: routineId,
            exerciseId: exerciseId,
          )
        ],
      );
    } else {
      return Text("error");
    }
  }
}
