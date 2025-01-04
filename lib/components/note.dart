import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final String type;
  final List<String> messages;
  const Note({super.key, required this.type, required this.messages});

  @override
  Widget build(BuildContext context) {
    final Color noteText;
    final Color noteBackground;
    final Icon noteIcon;

    if (type == "caution") {
      noteText = Colors.black; // Dark text for caution to stand out more
      noteBackground =
          Color(0xFFFFC107); // Amber background for caution (vibrant yellow)
      noteIcon =
          Icon(Icons.warning, color: Colors.black); // Warning icon for caution
    } else if (type == "info") {
      noteText = Colors.white; // White text for info
      noteBackground = Color(
          0xFF2196F3); // Blue background for info (calm and trust-inducing)
      noteIcon =
          Icon(Icons.info_outline, color: Colors.white); // Info icon for info
    } else if (type == "tips") {
      noteText = Colors.white; // White text for tips
      noteBackground = Color(
          0xFF4CAF50); // Teal background for tips (refreshing and easy-going)
      noteIcon = Icon(Icons.lightbulb_outline,
          color: Colors.white); // Lightbulb icon for tips
    } else if (type == "success") {
      noteText = Colors.white; // White text for success
      noteBackground =
          Color(0xFF4CAF50); // Green background for success (positive)
      noteIcon = Icon(Icons.check_circle_outline,
          color: Colors.white); // Check icon for success
    } else {
      noteText = Colors.black; // Dark text for general notes
      noteBackground = Color(
          0xFFFFEB3B); // Yellow-orange background for general/fallback (soft and visible)
      noteIcon = Icon(Icons.notes, color: Colors.black); // General notes icon
    }

    return // Caution Note Card

        Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      color: noteBackground,
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  noteIcon.icon,
                  color: noteText,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: noteText,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\u2022",
                  style: TextStyle(
                    fontSize: 16,
                    color: noteText,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    " lorem ipsum dolor sit amet, consectetur adipiscing ",
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
