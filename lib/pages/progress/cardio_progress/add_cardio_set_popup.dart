import 'package:flutter/material.dart';
import 'package:workout_tracker/pages/progress/cardio_progress/stop_watch_input.dart';

class AddCardioSetPopup extends StatefulWidget {
  // final VoidCallback onAddSet;

  const AddCardioSetPopup({
    super.key,
  });

  @override
  State<AddCardioSetPopup> createState() => _AddCardioSetPopupState();
}

class _AddCardioSetPopupState extends State<AddCardioSetPopup> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = const Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = const Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = const Color.fromRGBO(61, 61, 61, 1);

    return FloatingActionButton(
      backgroundColor: floatingIconColor,
      foregroundColor: textColor,
      child: const Icon(Icons.timer),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StopWatchInput();
            });
      },
    );
  }
}
