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
        height: 100,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/muscle.png'),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("PUSH UPS",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text(
                    "Chest, Triceps, Core, Glutes",
                    style:
                        TextStyle(color: const Color.fromARGB(255, 77, 77, 77)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
