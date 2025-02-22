import 'package:flutter/material.dart';

import 'package:workout_tracker/components/image_selection.dart';
import 'package:workout_tracker/database/database_service.dart';

class AddExercise extends StatefulWidget {
  final String selectedImage;
  final int routineId;
  const AddExercise(
      {super.key, required this.selectedImage, required this.routineId});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final DatabaseService databaseService = DatabaseService.instance;

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController musclesController = TextEditingController();
  final List<String> _keywords = [];

  late String _selectedImage;
  bool isImageSelected = true; // Initialize as true to hide the error initially

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage;
    isImageSelected = true; // Reset the error when an image is selected
  }

  void _addKeyword() {
    if (musclesController.text.isNotEmpty) {
      setState(() {
        _keywords.add(musclesController.text.trim());
        musclesController.clear(); // Clear the text field after adding
      });
    }
  }

  void _selectImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  // Dropdown variables
  int selectedSets = 1; // Default selected value
  final List<int> setOptions = [1, 2, 3, 4, 5];

  String selectedRisk = "MED"; // Default selected value
  final List<String> riskOptions = ["LOW", "MED", "HIGH"];

  double selectedProgress = 0.5; // Default selected value
  final List<double> progressOptions = [
    0.5,
    1,
    1.5,
    2,
    2.5,
    3,
    3.5,
    4,
    4.5,
    5,
    5.5
  ];

  String selectedType = "weightlifting";
  final List<String> typeOptions = ["weightlifting", "cardio", "calisthenics"];

  int selectedMinRep = 1;
  int selectedMaxRep = 10;
  final List<int> repOptions = List.generate(30, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);
    final Color cardWeightLiftingColor =
        const Color.fromARGB(255, 209, 167, 167);

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
                              shape:
                                  CircleBorder(), // Makes the button circular
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
                Row(
                  children: [
                    Expanded(
                      child: Card(
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
                                  child: Text("Exercise Type",
                                      style: TextStyle(fontSize: 16))),
                              DropdownButton<String>(
                                value: selectedType,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: appBarColor,
                                  size: 28,
                                ),
                                style:
                                    TextStyle(color: textColor, fontSize: 16),
                                underline: SizedBox.shrink(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedType = newValue!;
                                  });
                                },
                                items: typeOptions.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

// Adding conditional logic for "weightlifting" type
                if (selectedType == "weightlifting") ...[
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: cardWeightLiftingColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Min Rep",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                DropdownButton<int>(
                                  value: selectedMinRep,
                                  items: repOptions.map((int item) {
                                    return DropdownMenuItem<int>(
                                      value: item,
                                      child: Text(item.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedMinRep = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: cardWeightLiftingColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Max Rep",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                DropdownButton<int>(
                                  value: selectedMaxRep,
                                  items: repOptions.map((int item) {
                                    return DropdownMenuItem<int>(
                                      value: item,
                                      child: Text(item.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedMaxRep = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: cardWeightLiftingColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Monthly Progress",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                DropdownButton<double>(
                                  value: selectedProgress,
                                  items: progressOptions.map((double item) {
                                    return DropdownMenuItem<double>(
                                      value: item,
                                      child: Text("${item} kg"),
                                    );
                                  }).toList(),
                                  onChanged: (double? newValue) {
                                    setState(() {
                                      selectedProgress = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    Expanded(
                      child: Card(
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
                                  child: Text("Risk",
                                      style: TextStyle(fontSize: 16))),
                              DropdownButton<String>(
                                value: selectedRisk,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: appBarColor,
                                  size: 28,
                                ),
                                style:
                                    TextStyle(color: textColor, fontSize: 16),
                                underline: SizedBox.shrink(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRisk = newValue!;
                                  });
                                },
                                items: riskOptions.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
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
                                  child: Text("Sets",
                                      style: TextStyle(fontSize: 16))),
                              DropdownButton<int>(
                                value: selectedSets,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: appBarColor,
                                  size: 28,
                                ),
                                style:
                                    TextStyle(color: textColor, fontSize: 16),
                                underline: SizedBox.shrink(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedSets = newValue!;
                                  });
                                },
                                items: setOptions.map((int item) {
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
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Keywords TextField
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(children: [
                            Expanded(
                              child: TextFormField(
                                controller: musclesController,
                                validator: (value) {
                                  if (_keywords.isEmpty) {
                                    return 'Please enter a muscle';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Muscles Worked",
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
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Wrap(
                  spacing: 8.0,
                  children: _keywords.map((keyword) {
                    return Chip(
                      label: Text(keyword),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _keywords.remove(keyword);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isImageSelected = _selectedImage != "";
                    });

                    if ((_formKey.currentState?.validate() ?? false) &&
                        isImageSelected) {
                      // Proceed with the form submission

                      if (selectedType == "weightlifting") {
                        databaseService.addExercise(
                            widget.routineId,
                            titleController.text.trim(),
                            _selectedImage,
                            selectedSets,
                            selectedRisk,
                            _keywords.join(", "),
                            selectedType,
                            selectedProgress,
                            selectedMinRep,
                            selectedMaxRep);
                      } else {
                        databaseService.addExercise(
                            widget.routineId,
                            titleController.text.trim(),
                            _selectedImage,
                            selectedSets,
                            selectedRisk,
                            _keywords.join(", "),
                            selectedType,
                            0.0,
                            0,
                            0);
                      }

                      Navigator.pop(context);
                      setState(() {});
                    }
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
      ),
    );
  }
}
