import 'package:flutter/material.dart';
import 'package:workout_tracker/components/image_selection.dart';

class AddExercise extends StatefulWidget {
  final String? selectedImage;
  const AddExercise({super.key, required this.selectedImage});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final List<String> muscles = [
    // Your list of muscles
    '14228733.png',
    '142287352.png',
    // Add the rest of the images
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
        _controller.clear();
      });
    }
  }

  void _selectImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  // Dropdown variables
  int? selectedValue = 1; // Default selected value
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Center(
              child: _selectedImage == ""
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.amber,
                      ),
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
                        color: textColor,
                        size: 100,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(child: Text("How many sets")),
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
                child: Row(
                  children: [
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
                  ],
                ),
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
    );
  }
}
