import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final _textController = TextEditingController();
  String userInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(userInput)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: "Whats on your mind", border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  userInput = _textController.text;
                });
              },
              child: Text("Tweet"))
        ],
      ),
    );
  }
}
