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
  FOREIGN KEY ($_setWorkoutIdColumnName) REFERENCES $_workoutTableName($_workoutIdColumnName)
);

              """);
        },
      );
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
  }

  Future<List<SetModel>> getSetsOfWorkout(
      int routineId, int exerciseId, int workoutId) async {
    final db = await database; // Get the database instance
    final String query = '''
    SELECT * 
    FROM $_setTableName
    JOIN $_workoutTableName ON $_workoutTableName.$_workoutIdColumnName = $_setTableName.$_setWorkoutIdColumnName
    JOIN $_exerciseTableName ON $_exerciseTableName.$_exerciseIdColumnName = $_workoutTableName.$_workoutExerciseIdColumnName
    JOIN $_routineTableName ON $_routineTableName.$_routineIdColumnName = $_exerciseTableName.$_exerciseRoutineIdColumnName
    WHERE $_routineTableName.$_routineIdColumnName = ? 
      AND $_exerciseTableName.$_exerciseIdColumnName = ? 
      AND $_workoutTableName.$_workoutIdColumnName = ?;
  ''';

    try {
      // Query the database with the provided routineId, exerciseId, and workoutId
      final data = await db.rawQuery(query, [routineId, exerciseId, workoutId]);
      if (data.isNotEmpty) {
        print("Data exists");
        List<SetModel> sets = data
            .map((e) => SetModel(
                  id: e[_setIdColumnName] as int,
                  setNumber: e[_setNumberColumnName] as int,
                  weight: e[_setWeightColumnName] as double,
                  reps: e[_setRepsColumnName] as int,
                ))
            .toList();
        print(sets);

        return sets;
      } else {
        print("Data doesnt exist");
        return [];
      }
    } catch (e) {
      // Handle any exceptions that may occur
      throw Exception("Error retrieving workout sets: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getSetsOfAllWorkouts(
      int routineId, int exerciseId) async {
    final db = await database;

    final String query = '''
  SELECT 
      Workout.$_workoutDateColumnName AS date,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight1,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps1,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight2,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps2,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight3,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps3
  FROM $_workoutTableName AS Workout
  JOIN $_exerciseTableName AS Exercise ON Exercise.$_exerciseIdColumnName = Workout.$_workoutExerciseIdColumnName
  JOIN $_routineTableName AS Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
  JOIN $_setTableName AS StrengthTrainingSet ON StrengthTrainingSet.$_setWorkoutIdColumnName = Workout.$_workoutIdColumnName
  WHERE Routine.$_routineIdColumnName = ? AND Exercise.$_exerciseIdColumnName = ?
  GROUP BY Workout.$_workoutIdColumnName
  ORDER BY Workout.$_workoutDateColumnName DESC;
  ''';

    try {
      final List<Map<String, dynamic>> data =
          await db.rawQuery(query, [routineId, exerciseId]);
      return data;
    } catch (e) {
      throw Exception("Error retrieving workout sets: $e");
    }
  }
}
