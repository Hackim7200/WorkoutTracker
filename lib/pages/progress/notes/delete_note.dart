import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class DeleteNote extends StatefulWidget {
  final int noteId;
  final Color noteText;
  const DeleteNote({super.key, required this.noteId, required this.noteText});

  @override
  State<DeleteNote> createState() => _DeleteNoteState();
}

class _DeleteNoteState extends State<DeleteNote> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;
    deleteNote() async {
      await databaseService.deleteNote(widget.noteId);
    }

    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 255, 112, 112),
                title: Text(
                  "Delete Note",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Are you sure you want to delete this Note?")
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            deleteNote();
                            // setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("Confirm"))
                    ],
                  )
                ],
              );
            },
          );
        },
        icon: Icon(Icons.delete, color: widget.noteText, size: 30));
  }
}
