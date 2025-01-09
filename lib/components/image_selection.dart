import 'package:flutter/material.dart';

class ImageSelection extends StatefulWidget {
  final String folderPath;
  final List<String> imageList;
  final void Function(String imagePath) onImageSelected;

  const ImageSelection({
    super.key,
    required this.folderPath,
    required this.imageList,
    required this.onImageSelected,
  });

  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  int selectedImageIndex = -1;

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);
    final Color selectedColor = const Color.fromRGBO(87, 142, 126, 1);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          "Select an Image",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        actions: [
          IconButton(
            onPressed: selectedImageIndex != -1
                ? () {
                    widget.onImageSelected(
                      widget.imageList[selectedImageIndex],
                    );
                    Navigator.pop(context); // Go back after selection
                  }
                : null, // Disable if no image is selected
            icon: Icon(Icons.save,
                color: selectedImageIndex != -1 ? textColor : Colors.grey),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: widget.imageList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                crossAxisSpacing: 8, // Space between columns
                mainAxisSpacing: 8, // Space between rows
              ),
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: selectedImageIndex == index
                          ? Border.all(color: selectedColor, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x4D000000), // Shadow color
                          offset: const Offset(0, 4), // Shadow position
                          blurRadius: 6, // Shadow blur radius
                          spreadRadius: 2, // Shadow spread radius
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
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
