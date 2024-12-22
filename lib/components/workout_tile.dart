import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  // global variables
  final String title;
  final VoidCallback
      onTapCard; // void callback is a function without return type
  // can be given a function e.g onclick = (){}
  // this allows us to call the button from outside using the params
  final VoidCallback onTapOption;

  const WorkoutTile(
      { // this is the contructor
      // all the parameter in function
      super.key,
      required this.title,
      required this.onTapCard,
      required this.onTapOption // since its void it needs to get its information form outside
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTapCard,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Image.asset('assets/images/barbell.png')),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(
                              0), // Minimize padding inside the button
                          minimumSize: Size(30, 30), // Adjust the button size
                        ),
                        onPressed: onTapOption,
                        child: Icon(Icons.more_vert,
                            size: 20), // Adjust icon size if necessary
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
