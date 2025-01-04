import 'package:flutter/material.dart';

void main() => runApp(WorkoutApp());

class WorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage2(),
    );
  }
}

class HomePage2 extends StatelessWidget {
  final List<Map<String, String>> workouts = [
    {
      "title": "Full Body",
      "description":
          "A balanced routine targeting the entire body. Focus on building strength in your legs.",
      "image": "assets/full_body.png"
    },
    {
      "title": "Legs",
      "description": "Focus on building strength in your legs.",
      "image": "assets/legs.png"
    },
    {
      "title": "Chest",
      "description": "Target your chest muscles for strength and definition.",
      "image": "assets/chest.png"
    },
    {
      "title": "Arms",
      "description": "Work on biceps, triceps, and forearms.",
      "image": "assets/arms.png"
    },
    {
      "title": "Back",
      "description": "Improve posture and build back strength.",
      "image": "assets/back.png"
    },
    {
      "title": "Core",
      "description": "Strengthen your abs and stabilize your core.",
      "image": "assets/core.png"
    },
    {
      "title": "Yoga",
      "description": "Enhance flexibility and reduce stress with yoga.",
      "image": "assets/yoga.png"
    },
    {
      "title": "Cardio",
      "description": "Boost your endurance with high-intensity cardio.",
      "image": "assets/cardio.png"
    },
    {
      "title": "Stretching",
      "description": "Improve flexibility and recover faster with stretches.",
      "image": "assets/stretching.png"
    },
  ];

  final List<List<Color>> gradients = [
    [Colors.yellow, Colors.orange],
    [Colors.orange, Colors.red],
    [Colors.green, Colors.teal],
    [Color(0xFFffecd2), Color(0xFFfcb69f)], // Warm Cream to Sunset
    [Color(0xFFff8177), Color(0xFFff867a)], // Sunset Red to Warm Orange
    [Color(0xFF8fd3f4), Color(0xFF84fab0)], // Sky Blue to Soft Green
    [Color(0xFFa6c1ee), Color(0xFFfbc2eb)], // Light Blue to Pink Blend
    [Color(0xFFf9d423), Color(0xFFff4e50)], // Vibrant Yellow to Fiery Red
    [Color(0xFFc2e9fb), Color(0xFFa1c4fd)], // Light Sky Blue Gradient
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Routines"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            return WorkoutCard(
              title: workouts[index]["title"]!,
              description: workouts[index]["description"]!,
              image: workouts[index]["image"]!,
              gradient: gradients[index % gradients.length],
            );
          },
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final List<Color> gradient;

  const WorkoutCard({
    required this.title,
    required this.description,
    required this.image,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add navigation or interaction here
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset("assets/images/bodySections/6583949.png",
                    fit: BoxFit.contain),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
