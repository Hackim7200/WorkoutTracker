import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/database/models/note_model.dart';
import 'package:workout_tracker/pages/progress/notes/note.dart';

class Notes extends StatelessWidget {
  final int routineId;
  final int exerciseId;

  const Notes({super.key, required this.routineId, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    return FutureBuilder<List<NoteModel>>(
      future: databaseService.getNotes(routineId, exerciseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No notes found"));
        } else {
          return Column(
            children: snapshot.data!
                .map((note) => Note(
                      type: note.type,
                      message: note.content,
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
