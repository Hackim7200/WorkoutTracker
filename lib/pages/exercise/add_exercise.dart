import 'package:flutter/material.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final TextEditingController titleController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _keywords = [];

  void _addKeyword() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _keywords.add(_controller.text);
        _controller.clear(); // Clear the text field after adding
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          "N E W  E X E R C I S E",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Makes the button circular
                    padding:
                        EdgeInsets.all(20), // Adjust the size of the circle
                    backgroundColor: Colors.amber),
                onPressed: () {
                  print('Button pressed');
                },
                child: Icon(
                  Icons.image,
                  color: textColor, // Icon color
                  size: 100, // Icon size
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title TextField
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: textColor),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description TextField
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Muscles activated",
                        labelStyle: TextStyle(color: textColor),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _addKeyword();
                      },
                      icon: Icon(Icons.add))
                ]),
              ),
            ),

            Center(
              child: Text(
                _keywords.join(", "),
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle submission
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Add Routine",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scaffoldColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
