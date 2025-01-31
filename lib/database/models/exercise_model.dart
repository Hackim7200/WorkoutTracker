class ExerciseModel {
  final int id;
  final int routineId;
  final String title;
  final String image;
  final String muscleGroups;
  final String risk;
  final int minRep;
  final int maxRep;
  final int sets;
  final double monthlyProgressGoals;

  ExerciseModel({
    required this.id,
    required this.routineId,
    required this.title,
    required this.image,
    required this.minRep,
    required this.maxRep,
    required this.sets,
    required this.monthlyProgressGoals,
    required this.risk,
    required this.muscleGroups,
  });
}
