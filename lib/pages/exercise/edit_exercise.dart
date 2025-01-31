import 'package:flutter/material.dart';
import 'package:workout_tracker/components/image_selection.dart';

class EditExercise extends StatefulWidget {
  final String? selectedImage;
  const EditExercise({super.key, required this.selectedImage});

  @override
  State<EditExercise> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  final List<String> muscles = [
    '14228733.png',
    '142287352.png',
    '14228738.png',
    '142287402.png',
    '14228743.png',
    '142287452.png',
    '14228748.png',
    '142287522.png',
    '14228758.png',
    '142287612.png',
    '142287332.png',
    '14228736.png',
    '142287382.png',
    '14228741.png',
    '142287432.png',
    '14228746.png',
    '142287482.png',
    '14228754.png',
    '142287582.png',
    '14228764.png',
    '14228734.png',
    '142287362.png',
    '14228739.png',
    '142287412.png',
    '14228744.png',
    '142287462.png',
    '14228749.png',
    '142287542.png',
    '14228760.png',
    '142287642.png',
    '142287342.png',
    '14228737.png',
    '142287392.png',
    '14228742.png',
    '142287442.png',
    '14228747.png',
    '142287492.png',
    '14228756.png',
    '142287602.png',
    '14228735.png',
    '142287372.png',
    '14228740.png',
    '142287422.png',
    '14228745.png',
    '142287472.png',
    '14228752.png',
    '142287562.png',
    '14228761.png'
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _keywords = [];
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage;
  }

  void _addKeyword() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _keywords.add(_controller.text);
        _controller.clear(); // Clear the text field after adding
      });
    }
  }

  void _selectImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  // Dropdown variables
  int? selectedValue = 4; // Default selected value
  final List<int> dropdownItems = [1, 2, 3, 4, 5];

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Center(
                child: _selectedImage == ""
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), // Makes the button circular
                            padding: EdgeInsets.all(
                                20), // Adjust the size of the circle
                            backgroundColor: Colors.amber),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ImageSelection(
                              folderPath: "assets/images/muscles/",
                              imageList: muscles,
                              onImageSelected: _selectImage,
                            );
                          }));
                        },
                        child: Icon(
                          Icons.image,
                          color: textColor, // Icon color
                          size: 100, // Icon size
                        ),
                      )
                    : Column(
                        children: [
                          Image.asset(
                            "assets/images/muscles/$_selectedImage",
                            height: 150,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ImageSelection(
                                  folderPath: "assets/images/muscles/",
                                  imageList: muscles,
                                  onImageSelected: _selectImage,
                                );
                              }));
                            },
                            child: Text("Change Image"),
                          ),
                        ],
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
              // Dropdown for sets
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
                          child: Text("How many sets",
                              style: TextStyle(fontSize: 16))),
                      DropdownButton<int>(
                        value: selectedValue,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: appBarColor,
                          size: 28,
                        ),
                        style: TextStyle(color: textColor, fontSize: 16),
                        underline: SizedBox.shrink(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        items: dropdownItems.map((int item) {
                          return DropdownMenuItem<int>(
                            value: item,
                            child: Text(item.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Keywords TextField
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
                      onPressed: _addKeyword,
                      icon: Icon(
                        Icons.add,
                        color: appBarColor,
                        size: 28,
                      ),
                    ),
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
                  "Add Exercise",
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
