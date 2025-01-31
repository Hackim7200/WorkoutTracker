import 'package:flutter/material.dart';
import 'package:workout_tracker/components/image_selection.dart';
import 'package:workout_tracker/database/database_service.dart';

class AddRoutine extends StatefulWidget {
  final String selectedImage;
  const AddRoutine({super.key, required this.selectedImage});

  @override
  State<AddRoutine> createState() => _AddRoutineState();
}

class _AddRoutineState extends State<AddRoutine> {
  final DatabaseService _databaseService = DatabaseService.instance;

  late String _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage; // Initialize selectedImage
  }

  void _selectImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  final List<String> bodySections = [
    "6583949.png",
    "65839532.png",
    "6583959.png",
    "65839632.png",
    "6583969.png",
    "65839732.png",
    "6583979.png",
    "65839832.png",
    "6583988.png",
    "65839922.png",
    "65839492.png",
    "6583955.png",
    "65839592.png",
    "6583965.png",
    "65839692.png",
    "6583975.png",
    "65839792.png",
    "6583984.png",
    "65839882.png",
    "6583994.png",
    "6583951.png",
    "65839552.png",
    "6583961.png",
    "65839652.png",
    "6583971.png",
    "65839752.png",
    "6583981.png",
    "65839842.png",
    "6583990.png",
    "65839942.png",
    "65839512.png",
    "6583957.png",
    "65839612.png",
    "6583967.png",
    "65839712.png",
    "6583977.png",
    "65839812.png",
    "6583986.png",
    "65839902.png",
    "6583953.png",
    "65839572.png",
    "6583963.png",
    "65839672.png",
    "6583973.png",
    "65839772.png",
    "6583983.png",
    "65839862.png",
    "6583992.png"
  ];

  final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
  final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
  final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
  final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          "N E W  R O U T I N E",
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
                child: _selectedImage.isEmpty
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape:
                              const CircleBorder(), // Makes the button circular
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ImageSelection(
                              folderPath: "assets/images/bodySections/",
                              imageList: bodySections,
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
                            "assets/images/bodySections/$_selectedImage",
                            height: 150,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ImageSelection(
                                  folderPath: "assets/images/bodySections/",
                                  imageList: bodySections,
                                  onImageSelected: _selectImage,
                                );
                              }));
                            },
                            child: const Text("Change Image"),
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
                  _databaseService.addRoutine(titleController.text,
                      descriptionController.text, _selectedImage);
                  Navigator.pop(context);
                  setState(() {});

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
      ),
    );
  }
}
