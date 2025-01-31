import 'package:workout_tracker/database/models/set_model.dart';

class Workout {
  final int id;
  final String date;
  final List<SetModel> sets;

  Workout(
    this.date,
    this.sets, {
    required this.id,
  });
}
