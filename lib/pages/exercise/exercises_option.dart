import 'package:flutter/material.dart';

class ExercisesOption extends StatelessWidget {
  const ExercisesOption({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

    final List<List<String>> exercises = [
      ["Pull-Ups", "Lats, Biceps, Rear Delts, Core", "14228733.png"],
      ["Deadlifts", "Hamstrings, Glutes, Lower Back, Traps", "142287352.png"],
      ["Barbell Rows", "Lats, Rhomboids, Traps, Biceps", "14228738.png"],
      ["Dumbbell Rows", "Lats, Rhomboids, Traps, Biceps", "142287402.png"],
      ["Lat Pulldowns", "Lats, Biceps, Rear Delts, Rhomboids", "14228743.png"],
      ["Seated Cable Rows", "Lats, Rhomboids, Traps, Biceps", "142287452.png"],
      ["T-Bar Rows", "Lats, Rhomboids, Traps, Biceps", "14228748.png"],
      ["Face Pulls", "Rear Delts, Traps, Rotator Cuff", "142287522.png"],
      ["Hyperextensions", "Lower Back, Glutes, Hamstrings", "14228758.png"],
      ["Inverted Rows", "Lats, Rhomboids, Traps, Biceps", "142287612.png"],
      ["Chin-Ups", "Biceps, Lats, Core, Rear Delts", "142287332.png"],
      ["Bent-Over Rows", "Lats, Traps, Rhomboids, Rear Delts", "14228736.png"],
      ["Pendlay Rows", "Lats, Traps, Rhomboids, Lower Back", "142287382.png"],
      ["Good Mornings", "Lower Back, Hamstrings, Glutes", "14228741.png"],
      ["Straight-Arm Pulldowns", "Lats, Triceps, Rear Delts", "142287432.png"],
    ];

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "O P T I O N S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final TextEditingController nameController =
                TextEditingController(text: exercises[index][0]);
            final TextEditingController descriptionController =
                TextEditingController(text: exercises[index][1]);
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
                          "assets/images/muscles/${exercises[index][2]}",
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
                      maxLines: 2,
                      minLines: 1,
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
          }),
    );
  }
}
