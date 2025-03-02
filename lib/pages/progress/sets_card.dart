import 'package:flutter/material.dart';

class SetCardsPage extends StatelessWidget {
  final int set = 7; // Example: render 7 cards

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Cards'),
      ),
      body: SingleChildScrollView(  // Wrap in SingleChildScrollView to support horizontal scrolling
        scrollDirection: Axis.horizontal,  // Enables horizontal scrolling
        child: Row(
          children: List.generate(set, (index) {
            return Card(
              margin: EdgeInsets.all(8),
              elevation: 4,
              child: Container(
                width: 100, // Set a fixed width for each card
                height: 100, // Set a fixed height for each card
                child: Center(
                  child: Text(
                    'Set ${index + 1}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SetCardsPage(),
  ));
}
