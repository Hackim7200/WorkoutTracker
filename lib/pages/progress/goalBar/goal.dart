import 'package:flutter/material.dart';

class Goal extends StatelessWidget {
  final Color backgroundColour;
  final String title;
  final String value;
  // final Color textColour;

  const Goal({
    super.key,
    required this.backgroundColour,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColour,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(),
          ),
          Text(value)
        ],
      ),
    );
  }
}
