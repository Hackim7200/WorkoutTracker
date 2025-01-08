import 'package:flutter/material.dart';

class HomePageOption extends StatelessWidget {
  HomePageOption({super.key});

  final List<List<String>> routines = [
    [
      "Full Body",
      "A balanced routine targeting the entire body.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Legs",
      "Focus on building strength in your legs.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Chest",
      "Target your chest muscles for strength and definition.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Arms",
      "Work on biceps, triceps, and forearms.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Back",
      "Improve posture and build back strength.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Core",
      "Strengthen your abs and stabilize your core.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Yoga",
      "Enhance flexibility and reduce stress with yoga.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Cardio",
      "Boost your endurance with high-intensity cardio.",
      "assets/images/bodySections/6583949.png"
    ],
    [
      "Stretching",
      "Improve flexibility and recover faster with stretching.",
      "assets/images/bodySections/6583949.png"
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          "O P T I O N",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
      ),
      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          // Controllers for name and description
          final TextEditingController nameController =
              TextEditingController(text: routines[index][0]);
          final TextEditingController descriptionController =
              TextEditingController(text: routines[index][1]);

          return Card(
            color: cardColor,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        routines[index][2],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            hintText: "Edit routine name",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    style: TextStyle(color: textColor),
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: "Edit routine description",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
