import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/Notes/note.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    final List<List<String>> messages = [
      ["tips", "Stay hydrated during your workout."],
      ["caution", "Ensure proper form to avoid injury."],
      [
        "info",
        "Deadlifts target multiple muscle groups, including the hamstrings and glutes."
      ],
      ["tips", "Warm up before starting heavy exercises."],
      ["caution", "Avoid overloading the barbell beyond your capacity."],
      [
        "info",
        "Face pulls help strengthen the rear delts and improve posture."
      ],
      [
        "info",
        "Face pulls help strengthen the rear delts and improve posture."
      ],
      [
        "info",
        "Face pulls help strengthen the rear delts and improve posture."
      ],
      [
        "info",
        "Face pulls help strengthen the rear delts and improve posture."
      ],
    ];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
        child: ListView.builder(
          shrinkWrap: true, //
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return Note(type: messages[index][0], message: messages[index][1]);
          },
        ),
      ),
    );
  }
}
