import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class AddNote extends StatefulWidget {
  final int exerciseId;
  const AddNote({
    super.key,
    required this.exerciseId,
  });

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
  final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
  final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
  final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);


  final TextEditingController descriptionController = TextEditingController();

  final DatabaseService databaseService = DatabaseService.instance;

  // Dropdown variables
  String selectedValue = "TIPS"; // Default selected value
  final List<String> dropdownItems = ["CAUTION", "TIPS", "INFO"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          "A D D   N O T E",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section

              const SizedBox(height: 16),
              Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Select the type of note",
                        style: TextStyle(fontSize: 16),
                      )),
                      DropdownButton<String>(
                        value: selectedValue,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: appBarColor,
                          size: 28,
                        ),
                        style: TextStyle(color: textColor, fontSize: 16),
                        underline: SizedBox.shrink(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: dropdownItems.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: textColor),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  databaseService.addNote(
                      widget.exerciseId,selectedValue, descriptionController.text);
                    Navigator.pop(context);

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
                  "Add Note",
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
      ),
    );
  }
}
