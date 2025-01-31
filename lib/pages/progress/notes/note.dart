import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final String type;
  final String message;
  const Note({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    final Color noteText;
    final Color noteBackground;
    final Icon noteIcon;

    if (type == "CAUTION") {
      noteText = Colors.black; // Dark text for caution to stand out more
      noteBackground = Color.fromRGBO(
          231, 111, 81, 1); // Amber background for caution (vibrant yellow)
      noteIcon =
          Icon(Icons.warning, color: Colors.black); // Warning icon for caution
    } else if (type == "TIPS") {
      noteText = Colors.white; // White text for tips
      noteBackground = Color.fromRGBO(54, 186, 152,
          1); // Teal background for tips (refreshing and easy-going)
      noteIcon = Icon(Icons.lightbulb_outline,
          color: Colors.white); // Lightbulb icon for tips
    } else {
      noteText = Colors.white; // White text for info
      noteBackground = Color.fromRGBO(233, 195, 106,
          1); // Blue background for info (calm and trust-inducing)
      noteIcon =
          Icon(Icons.info_outline, color: Colors.white); // Info icon for info
    }

    return // Caution Note Card

        Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      color: noteBackground,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  noteIcon.icon,
                  color: noteText,
                  size: 30,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: noteText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
