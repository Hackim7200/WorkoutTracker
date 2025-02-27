import 'package:flutter/material.dart';
import 'package:workout_tracker/components/image_selection.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/routine_model.dart';
import 'package:workout_tracker/pages/routine/routine_delete.dart';

class EditRoutine extends StatefulWidget {
  final String selectedImage;
  final int routineId;

  const EditRoutine({
    super.key,
    required this.selectedImage,
    required this.routineId,
  });

  @override
  State<EditRoutine> createState() => _EditRoutineState();
}

class _EditRoutineState extends State<EditRoutine> {
  final DatabaseService databaseService = DatabaseService.instance;

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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late String _selectedImage;
  bool isImageSelected = true; // Initialize as true to hide the error initially
  late Map<String, dynamic>? routine;

  @override
  void initState() {
    super.initState();
    initialiseVariables();

    _selectedImage = widget.selectedImage;
  }

  void _selectImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
      isImageSelected = true; // Reset the error when an image is selected
    });
  }

  initialiseVariables() async {
    routine = await databaseService.getRoutine(widget.routineId);
    if (routine != null) {
      titleController.text = routine?["title"] ?? '';
      descriptionController.text = routine?["description"] ?? '';
    } else {
      print('Routine not found.');
    }
  }

  updateRoutine() async {
    await databaseService.updateRoutine(widget.routineId, titleController.text,
        descriptionController.text, widget.selectedImage);
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
          "R O U T I N E",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [RoutineDelete(routineId: widget.routineId)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                              backgroundColor: Colors.amber),
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
                            color: textColor,
                            size: 100,
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

                // Display red error message if image is not selected
                if (!isImageSelected)
                  Center(
                    child: Text(
                      "Please select an image",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 200, 15, 2),
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
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: textColor),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.trim().length < 4) {
                          return 'Title must be at least 4 characters';
                        }
                        return null;
                      },
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
                    child: TextFormField(
                      maxLines: 4,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(color: textColor),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.split(RegExp(r'\s+')).length < 3) {
                          return 'Provide at least 3 words';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isImageSelected = _selectedImage != "";
                    });

                    if ((_formKey.currentState?.validate() ?? false) &&
                        isImageSelected) {
                      // Proceed with the form submission
                      updateRoutine();

                      Navigator.pop(context);
                      // setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Update Routine",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
