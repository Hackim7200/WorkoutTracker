import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/database/models/routine_model.dart';

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
  final String _exerciseSetsColumnName = "sets";
  final String _exerciseRiskColumnName = "risk";
  final String _exerciseTypeColumnName = "exercise_type";

  final String _exerciseMonthlyProgressGoalsColumnName = "monthlyProgressGoals";
  final String _exerciseMinRepColumnName = "min_rep";
  final String _exerciseMaxRepColumnName = "max_rep";

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

  //strengthTraining table and column
  final String _strengthSetTableName = "StrengthTrainingSet";
  final String _setIdColumnName = "id";
  final String _setWorkoutIdColumnName = "workout_id";
  final String _setNumberColumnName = "number";
  final String _setRepsColumnName = "reps";
  final String _setWeightColumnName = "weight";
  final String _setPercentageChangeColumnName = "percentageIncrease";
  final String _setDifferenceColumnName = "weightDifference";

  //cardio table and column
  final String _cardioSetTableName = "CardioTrainingSet";
  final String _cardioSetIdColumnName = "id";
  final String _cardioSetWorkoutIdColumnName = "workout_id";
  final String _cardioSetNumberColumnName = "number";
  final String _cardioSetTimeColumnName = "time";
  final String _cardioSetIntensityColumnName = "intensity";
  final String _cardioSetPercentageChangeColumnName = "percentageIncrease";
  final String _cardioSetDifferenceColumnName = "difference";

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
              $_exerciseSetsColumnName INTEGER NOT NULL,
              $_exerciseTypeColumnName TEXT NOT NULL,

              $_exerciseMonthlyProgressGoalsColumnName REAL NOT NULL,
              $_exerciseMinRepColumnName INTEGER  NOT NULL, 
              $_exerciseMaxRepColumnName INTEGER  NOT NULL,

              FOREIGN KEY ($_exerciseRoutineIdColumnName) REFERENCES $_routineTableName($_routineIdColumnName)
              ON DELETE CASCADE
            );
          """);

          db.execute("""
          CREATE TABLE $_noteTableName (
              $_noteIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_noteExerciseIdColumnName INTEGER NOT NULL,
              $_noteTypeColumnName TEXT NOT NULL,
              $_noteContentColumnName TEXT NOT NULL,
              FOREIGN KEY ($_noteExerciseIdColumnName) REFERENCES $_exerciseTableName($_exerciseIdColumnName)
              ON DELETE CASCADE
              );
              """);

          db.execute("""
          CREATE TABLE $_workoutTableName (
              $_workoutIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_workoutExerciseIdColumnName INTEGER NOT NULL,
              $_workoutDateColumnName TEXT NOT NULL,
              FOREIGN KEY ($_workoutExerciseIdColumnName) REFERENCES $_exerciseTableName($_exerciseIdColumnName)
              ON DELETE CASCADE
              );
              """);

          db.execute("""
         CREATE TABLE $_strengthSetTableName (
              $_setIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_setWorkoutIdColumnName INTEGER NOT NULL,
              $_setNumberColumnName INTEGER NOT NULL,
              $_setWeightColumnName REAL NOT NULL,
              $_setRepsColumnName INTEGER NOT NULL,
              $_setPercentageChangeColumnName  REAL NOT NULL,
              $_setDifferenceColumnName  REAL NOT NULL,





              FOREIGN KEY ($_setWorkoutIdColumnName) REFERENCES $_workoutTableName($_workoutIdColumnName)
            ON DELETE CASCADE
            );

              """);

          db.execute("""
         CREATE TABLE $_cardioSetTableName (
              $_cardioSetIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
              $_cardioSetWorkoutIdColumnName INTEGER NOT NULL,
              $_cardioSetNumberColumnName INTEGER NOT NULL,
              $_cardioSetIntensityColumnName REAL NOT NULL,
              $_cardioSetTimeColumnName INTEGER NOT NULL,
              $_cardioSetPercentageChangeColumnName  REAL NOT NULL,
              $_cardioSetDifferenceColumnName  INTEGER NOT NULL,
              FOREIGN KEY ($_cardioSetWorkoutIdColumnName) REFERENCES $_workoutTableName($_workoutIdColumnName)
              ON DELETE CASCADE

            );

              """);
        },
      );
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
  }

  Future<int> getProgressForThisMonth(int exerciseId, int workoutId) async {
    final db = await database;

    final String query = '''
 SELECT strftime('%Y-%m', "date") AS "Month" , sum(StrengthTraining.diff) as progress
    FROM Exercise
    JOIN Workout ON Workout.exerciseId = Exercise.id
	JOIN StrengthTraining ON StrengthTraining.workoutId = Workout.id
	
	WHERE Exercise.id ==1


GROUP BY "Month"
ORDER BY "Month" DESC

LIMIT 1;


  ''';

    try {
      final data = await db.rawQuery(query, [exerciseId, workoutId]);

      if (data.isNotEmpty && data.first['workout_id'] != null) {
        print(data);

        return data.first['workout_id'] as int;
      } else {
        print("No workoutId found.");
        return 0;
      }
    } catch (e) {
      print("Error retrieving last workout id: $e");
      return 0;
    }
  }
}
