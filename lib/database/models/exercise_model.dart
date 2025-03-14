class ExerciseModel {
  final int id;
  final int routineId;
  final String title;
  final String image;
  final String muscleGroups;
  final String risk;
  final int sets;
  final String type;
  final int minRep;
  final int maxRep;
  final double monthlyProgressGoals;
  final int order;

  ExerciseModel( {
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
    required this.type,
    required this.order
  });
}
