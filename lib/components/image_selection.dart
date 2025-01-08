import 'package:flutter/material.dart';

class ImageSelection extends StatefulWidget {
  final String folderPath;
  final List<String> imageList;

  ImageSelection(
      {super.key, required this.folderPath, required this.imageList});

  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  // Variable to track the selected image index
  int selectedImageIndex = -1;

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);
    final Color selectedColor =
        const Color.fromRGBO(87, 142, 126, 1); // Selected image border color

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          "Select an Image",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: widget.imageList
                  .length, // Use widget.imageList instead of bodySections
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns per row
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageIndex =
                          index; // Update the selected image index
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: selectedImageIndex == index
                            ? Border.all(
                                color: selectedColor,
                                width: 3) // Border for selected image
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color(0x4D000000), // Shadow color with opacity
                            offset: Offset(
                                0, 4), // Shadow position (horizontal, vertical)
                            blurRadius: 6, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                          ),
                        ],
                      ),
                      child: Image.asset(
                        widget.folderPath + widget.imageList[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedImageIndex != -1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected: ${widget.imageList[selectedImageIndex]}',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
