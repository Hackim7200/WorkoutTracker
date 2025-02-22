import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/goalBar/goal.dart';

class GoalsBar extends StatelessWidget {
  final int minRep;
  final int maxRep;
  final double progressOverload;
  final String risk;
  final String type;
  final int numberOfSets;

  const GoalsBar({
    super.key,
    required this.minRep,
    required this.maxRep,
    required this.progressOverload,
    required this.risk,
    required this.type,
    required this.numberOfSets,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);

    // Set risk color dynamically
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



    return Padding(
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
            title: "Min Reps",
            value: "$minRep reps",
          ),
          Goal(
            backgroundColour: cardColor,
            title: "Max Reps",
            value: "$maxRep reps",
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
            value: "$numberOfSets",
          ),
        ],
      ),
    );
  }
}
