import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  // global variables
  final String title;
  final VoidCallback
      onTapCustom; // void callback is a function without return type
  // can be given a function e.g onclick = (){}

  const WorkoutTile(
      { // this is the contructor
      // all the parameter in function
      super.key,
      required this.title,
      required this.onTapCustom // since its void it needs to get its information form outside
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Back Day",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
