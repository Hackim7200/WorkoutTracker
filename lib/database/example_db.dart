import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/database/models/exercise_model.dart';
import 'package:workout_tracker/database/models/note_model.dart';
import 'package:workout_tracker/database/models/routine_model.dart';
import 'package:workout_tracker/database/models/set_model.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._internal();

  // Routine Table and Columns
  final String _routineTableName = "Routine";
  final String _routineIdColumnName = "id";
  final String _routineTitleColumnName = "title";
  final String _routineDescriptionColumnName = "description";
  final String _routineImageColumnName = "image";

  //Exercise table and column
  final String _exerciseTableName = "Exercise";
  final String _exerciseIdColumnName = "id";
  final String _exerciseRoutineIdColumnName = "routine_id";
  final String _exerciseTitleColumnName = "title";
  final String _exerciseImageColumnName = "image";
  final String _exerciseMusclesGroupsColumnName = "musclesGroups";
  final String _exerciseRiskColumnName = "risk";
  final String _exerciseMinRepColumnName = "min_rep";
  final String _exerciseMaxRepColumnName = "max_rep";
  final String _exerciseSetsColumnName = "sets";
  final String _exerciseMonthlyProgressGoalsColumnName = "monthlyProgressGoals";

  //Note table and column
  final String _noteTableName = "Note";
  final String _noteIdColumnName = "id";
  final String _noteExerciseIdColumnName = "exercise_id";
  final String _noteTypeColumnName = "type";
  final String _noteContentColumnName = "content";

  //workout table and column
  final String _workoutTableName = "Workout";
  final String _workoutIdColumnName = "id";
  final String _workoutExerciseIdColumnName = "exercise_id";
  final String _workoutDateColumnName = "date";

  //set table and column
  final String _setTableName = "StrengthTrainingSet";
  final String _setIdColumnName = "id";
  final String _setWorkoutIdColumnName = "workout_id";
  final String _setNumberColumnName = "number";
  final String _setRepsColumnName = "reps";
  final String _setWeightColumnName = "weight";
  final String _setPercentageIncreaseColumnName = "percentageIncrease";
  final String _setWeightDifferenceColumnName = "weightDifference";

  // Private constructor

  DatabaseService._internal();

  // Getter for the database instance
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      final databaseDirPath = await getDatabasesPath();
      final databasePath = join(databaseDirPath, "master_db.db");

      return await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) {
          db.execute("""
            CREATE TABLE $_routineTableName (
              $_routineIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_routineTitleColumnName TEXT NOT NULL,
              $_routineDescriptionColumnName TEXT NOT NULL,
               $_routineImageColumnName TEXT NOT NULL

            );
          """);

          db.execute("""
            CREATE TABLE $_exerciseTableName (
              $_exerciseIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_exerciseRoutineIdColumnName INTEGER NOT NULL,
              $_exerciseTitleColumnName TEXT NOT NULL,
              $_exerciseImageColumnName TEXT NOT NULL,
              $_exerciseMusclesGroupsColumnName TEXT NOT NULL,
              $_exerciseRiskColumnName TEXT NOT NULL,
              $_exerciseMinRepColumnName INTEGER NOT NULL, 
              $_exerciseMaxRepColumnName INTEGER NOT NULL,
              $_exerciseSetsColumnName INTEGER NOT NULL,
              $_exerciseMonthlyProgressGoalsColumnName REAL NOT NULL,
              FOREIGN KEY ($_exerciseRoutineIdColumnName) REFERENCES $_routineTableName($_routineIdColumnName)
            );
          """);

          db.execute("""
          CREATE TABLE $_noteTableName (
              $_noteIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_noteExerciseIdColumnName INTEGER NOT NULL,
              $_noteTypeColumnName TEXT NOT NULL,
              $_noteContentColumnName TEXT NOT NULL,
              FOREIGN KEY ($_noteExerciseIdColumnName) REFERENCES $_exerciseTableName($_exerciseIdColumnName)
              );
              """);

          db.execute("""
          CREATE TABLE $_workoutTableName (
              $_workoutIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_workoutExerciseIdColumnName INTEGER NOT NULL,
              $_workoutDateColumnName TEXT NOT NULL,
              FOREIGN KEY ($_workoutExerciseIdColumnName) REFERENCES $_exerciseTableName($_exerciseIdColumnName)
              );
              """);

          db.execute("""
         CREATE TABLE $_setTableName (
              $_setIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_setWorkoutIdColumnName INTEGER NOT NULL,
              $_setNumberColumnName INTEGER NOT NULL,
              $_setWeightColumnName REAL NOT NULL,
              $_setRepsColumnName INTEGER NOT NULL,
              $_setWeightDifferenceColumnName REAL NOT NULL,
              $_setPercentageIncreaseColumnName REAL NOT NULL,

              FOREIGN KEY ($_setWorkoutIdColumnName) REFERENCES $_workoutTableName($_workoutIdColumnName)
            );

              """);
        },
      );
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
 
  }
  Future<int> getSetsOfWorkout(
      int routineId, int exerciseId, int workoutId) async {
    final db = await database;
    const String query = '''
      SELECT MAX(number) AS lastSet
      FROM StrengthTrainingSet
      JOIN Workout ON Workout.id = StrengthTrainingSet.workout_id
      JOIN Exercise ON Exercise.id = Workout.exercise_id
      JOIN Routine ON Routine.id = Exercise.routine_id
      WHERE Routine.id = ? AND Exercise.id = ? AND Workout.id = ?;
    ''';

    try {
      final data = await db.rawQuery(query, [routineId, exerciseId, workoutId]);
      return (data.isNotEmpty && data.first["lastSet"] != null)
          ? data.first["lastSet"] as int
          : -1;
    } catch (e) {
      print("Error retrieving workout sets: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getSetsOfAllWorkouts(
      int routineId, int exerciseId) async {
    final db = await database;

    final String query = '''
  SELECT 
    Workout.$_workoutIdColumnName AS id,
    Workout.$_workoutDateColumnName AS date,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight1,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps1,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff1,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange1,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight2,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps2,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff2,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange2,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight3,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps3,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff3,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange3,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight4,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps4,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff4,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange4,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight5,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps5,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff5,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange5,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight6,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps6,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff6,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange6,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight7,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps7,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff7,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange7,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight8,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps8,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff8,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange8,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight9,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps9,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff9,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange9,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight10,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps10,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setWeightDifferenceColumnName END) AS weightDiff10,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setPercentageIncreaseColumnName END) AS percentageChange10

  FROM $_workoutTableName AS Workout
  JOIN $_exerciseTableName AS Exercise ON Exercise.$_exerciseIdColumnName = Workout.$_workoutExerciseIdColumnName
  JOIN $_routineTableName AS Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
  JOIN $_setTableName AS StrengthTrainingSet ON StrengthTrainingSet.$_setWorkoutIdColumnName = Workout.$_workoutIdColumnName
  WHERE Routine.$_routineIdColumnName = ? AND Exercise.$_exerciseIdColumnName = ?
  GROUP BY Workout.$_workoutIdColumnName, Workout.$_workoutDateColumnName
  ORDER BY Workout.$_workoutDateColumnName ASC;
''';

    try {
      final List<Map<String, dynamic>> data =
          await db.rawQuery(query, [routineId, exerciseId]);

      List<Map<String, dynamic>> workouts = [];

      for (var element in data) {
        workouts.add({
          "id": element["id"],
          "date": element["date"],
          "weights": [
            element["weight1"] ?? 0.0,
            element["weight2"] ?? 0.0,
            element["weight3"] ?? 0.0,
            element["weight4"] ?? 0.0,
            element["weight5"] ?? 0.0,
            element["weight6"] ?? 0.0,
            element["weight7"] ?? 0.0,
            element["weight8"] ?? 0.0,
            element["weight9"] ?? 0.0,
            element["weight10"] ?? 0.0,
          ],
          "reps": [
            element["reps1"] ?? 0.0,
            element["reps2"] ?? 0.0,
            element["reps3"] ?? 0.0,
            element["reps4"] ?? 0.0,
            element["reps5"] ?? 0.0,
            element["reps6"] ?? 0.0,
            element["reps7"] ?? 0.0,
            element["reps8"] ?? 0.0,
            element["reps9"] ?? 0.0,
            element["reps10"] ?? 0.0,
          ],
          "weightDifferences": [
            element["weightDiff1"] ?? 0.0,
            element["weightDiff2"] ?? 0.0,
            element["weightDiff3"] ?? 0.0,
            element["weightDiff4"] ?? 0.0,
            element["weightDiff5"] ?? 0.0,
            element["weightDiff6"] ?? 0.0,
            element["weightDiff7"] ?? 0.0,
            element["weightDiff8"] ?? 0.0,
            element["weightDiff9"] ?? 0.0,
            element["weightDiff10"] ?? 0.0,
          ],
          "percentageChanges": [
            element["percentageChange1"] ?? 0.0,
            element["percentageChange2"] ?? 0.0,
            element["percentageChange3"] ?? 0.0,
            element["percentageChange4"] ?? 0.0,
            element["percentageChange5"] ?? 0.0,
            element["percentageChange6"] ?? 0.0,
            element["percentageChange7"] ?? 0.0,
            element["percentageChange8"] ?? 0.0,
            element["percentageChange9"] ?? 0.0,
            element["percentageChange10"] ?? 0.0,
          ]
        });
      }
      print(workouts);

      return workouts;
    } catch (e) {
      throw Exception("Error retrieving workout sets: $e");
    }
  }
}