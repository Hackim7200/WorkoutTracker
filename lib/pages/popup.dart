import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkoutScreen(),
    );
  }
}

class WorkoutScreen extends StatelessWidget {
  void _showSetInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SetInputDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Log')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showSetInputDialog(context),
          child: Text('Log Workout'),
        ),
      ),
    );
  }
}

class SetInputDialog extends StatefulWidget {
  @override
  _SetInputDialogState createState() => _SetInputDialogState();
}

class _SetInputDialogState extends State<SetInputDialog> {
  final List<Map<String, String>> _sets = [
    {'reps': '', 'weight': ''},
    {'reps': '', 'weight': ''},
    {'reps': '', 'weight': ''},
    {'reps': '', 'weight': ''},
  ];

  void _addSet() {
    setState(() {
      _sets.add({'reps': '', 'weight': ''});
    });
  }

  void _removeSet() {
    if (_sets.length > 1) {
      setState(() {
        _sets.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter Reps & Weight',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _sets.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Set ${index + 1}'),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('Reps: '),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _sets[index]['reps'] = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Reps',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Weight: '),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _sets[index]['weight'] = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Weight',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red),
                  onPressed: _removeSet,
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green),
                  onPressed: _addSet,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Here you can handle saving the data, for now, let's just close the dialog
                Navigator.pop(context);
              },
              child: Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
