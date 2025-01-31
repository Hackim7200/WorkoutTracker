import 'package:flutter/material.dart';

class Goal extends StatelessWidget {
  final Color backgroundColour;
  final Color textColour;
  final String title;
  final String value;

  const Goal(
      {super.key,
      required this.backgroundColour,
      required this.title,
      required this.value,
      required this.textColour});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: backgroundColour,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: textColour),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Divider(),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 18, color: textColour),
              )
            ],
          ),
        ),
      ),
    );
  }
}
