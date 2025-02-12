import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';
import 'package:workout_tracker/pages/progress/cardio_progress/add_cardio_set_popup.dart';


class CardioProgressPage extends StatefulWidget {
  const CardioProgressPage({
    super.key,
  });

  @override
  State<CardioProgressPage> createState() => _CardioProgressPageState();
}

class _CardioProgressPageState extends State<CardioProgressPage> {
  final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
  final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
  final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
  final Color textColor = Color.fromRGBO(61, 61, 61, 1);

  final DatabaseService databaseService = DatabaseService.instance;
  late Future<Map<String, dynamic>> workoutData;

  @override
  void initState() {
    super.initState();
  }

  int workoutId = -1;
  String lastDate = "";
  String currentDate = "";
  int lastSetAdded = 0;

  void refreshWorkoutData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "P R O G R E S S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.note_add)),
        ],
      ),
      floatingActionButton: AddCardioSetPopup(),
    );
  }
}
