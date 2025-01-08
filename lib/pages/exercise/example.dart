import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Keywords Example'),
        ),
        body: KeywordAdder(),
      ),
    );
  }
}

class KeywordAdder extends StatefulWidget {
  @override
  _KeywordAdderState createState() => _KeywordAdderState();
}

class _KeywordAdderState extends State<KeywordAdder> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _keywords = [];

  void _addKeyword() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _keywords.add(_controller.text);
        _controller.clear(); // Clear the text field after adding
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter keyword',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: _addKeyword,
            child: Text('Add'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _keywords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_keywords[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
