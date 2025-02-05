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

  Future<void> addRoutine(String name, String description, String image) async {
    try {
      final db = await database;
      await db.insert(
        _routineTableName,
        {
          _routineTitleColumnName: name,
          _routineDescriptionColumnName: description,
          _routineImageColumnName: image
        },
      );
      print('Routine added successfully');
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

  Future<List<RoutineModel>> getRoutines() async {
    final db = await database;
    final data = await db.query(_routineTableName);

    List<RoutineModel> routines = data
        .map((e) => RoutineModel(
            id: e[_routineIdColumnName] as int,
            title: e[_routineTitleColumnName] as String,
            description: e[_routineDescriptionColumnName] as String,
            image: e[_routineImageColumnName] as String))
        .toList();
    return routines;
  }

  Future<List<ExerciseModel>> getExercises(int routineId) async {
    final db = await database; // Get the database instance

    try {
      // Query the Exercise table
      final data = await db.query(
        _exerciseTableName,
        where: '$_exerciseRoutineIdColumnName = ?', // Filter by routineId
        whereArgs: [routineId], // Pass routineId as an argument
      );

      // Map the query results to a list of WorkoutExercise objects
      List<ExerciseModel> exercises = data
          .map((e) => ExerciseModel(
              id: e[_exerciseIdColumnName] as int,
              routineId: e[_exerciseRoutineIdColumnName] as int,
              title: e[_exerciseTitleColumnName] as String,
              image: e[_exerciseImageColumnName] as String,
              muscleGroups: e[_exerciseMusclesGroupsColumnName] as String,
              risk: e[_exerciseRiskColumnName] as String,
              minRep: e[_exerciseMinRepColumnName] as int,
              maxRep: e[_exerciseMaxRepColumnName] as int,
              sets: e[_exerciseSetsColumnName] as int,
              monthlyProgressGoals:
                  e[_exerciseMonthlyProgressGoalsColumnName] as double))
          .toList();
      return exercises;
    } catch (e) {
      throw Exception("Error retrieving exercises: $e");
    }
  }

  Future<List<NoteModel>> getNotes(int routineId, int exerciseId) async {
    final db = await database; // Get the database instance
    final String query = '''
    SELECT * 
    FROM Note
    JOIN Exercise ON Note.$_noteExerciseIdColumnName = Exercise.$_exerciseIdColumnName
    JOIN Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
    WHERE Routine.$_routineIdColumnName = ? AND Exercise.$_exerciseIdColumnName = ?;
  ''';

    try {
      // Query the database with the provided routineId and exerciseId
      final data = await db.rawQuery(query, [routineId, exerciseId]);

      // Map the query results to a list of WorkoutNote objects
      List<NoteModel> notes = data
          .map((e) => NoteModel(
                id: e[_noteIdColumnName]
                    as int, // Ensure column name matches the database schema
                content: e[_noteContentColumnName] as String,
                type: e[_noteTypeColumnName] as String,
              ))
          .toList();

      return notes;
    } catch (e) {
      // Handle any exceptions that may occur
      throw Exception("Error retrieving notes: $e");
    }
  }

  Future<Map<String, dynamic>> getLastWorkout(
      int routineId, int exerciseId) async {
    final db = await database; // Get the database instance

    final String query = '''
    SELECT Workout.id AS id, Workout.date AS date
    FROM Workout
    JOIN Exercise ON Workout.$_workoutExerciseIdColumnName = Exercise.id
    JOIN Routine ON Routine.id = Exercise.$_exerciseRoutineIdColumnName
    WHERE Routine.id = ? AND Exercise.id = ?
    ORDER BY Workout.date DESC
    LIMIT 1;  -- Select the most recent workout
  ''';

    try {
      final List<Map<String, dynamic>> data =
          await db.rawQuery(query, [routineId, exerciseId]);

      if (data.isNotEmpty) {
        print("Workout exists");

        int workoutId = data.first["id"] as int;
        String? date =
            data.first["date"] as String? ?? ""; // Handle possible null values

        print("Workout ID: $workoutId, Date: $date");

        return {"id": workoutId, "date": date};
      } else {
        print("No workout exists");
        return {"id": -1, "date": ""}; // Default response when no data exists
      }
    } catch (e) {
      print("Error retrieving workout: $e");
      return {"id": -1, "date": ""}; // Return a default error response
    }
  }

  Future<List<SetModel>> getLastSet(
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
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight2,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps2,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight3,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps3,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight4,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps4,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight5,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps5,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight6,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps6,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight7,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps7,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight8,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps8,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight9,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps9,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight10,
      MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps10
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
            element["weight10"] ?? 0.0
          ],
          "reps": [
            element["reps1"] ?? 0,
            element["reps2"] ?? 0,
            element["reps3"] ?? 0,
            element["reps4"] ?? 0,
            element["reps5"] ?? 0,
            element["reps6"] ?? 0,
            element["reps7"] ?? 0,
            element["reps8"] ?? 0,
            element["reps9"] ?? 0,
            element["reps10"] ?? 0
          ],
        });
      }

      print(workouts);
      return workouts;
    } catch (e) {
      throw Exception("Error retrieving workout sets: $e");
    }
  }

  Future<int> getLastSetNumber(
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
        return data.last["number"] as int;
      } else {
        print("Data is empty");
        return 0;
      }

      // List<WorkoutSet> sets = data
      //     .map((e) => WorkoutSet(
      //           id: e[_setIdColumnName] as int,
      //           setNumber: e[_setNumberColumnName] as int,
      //           weight: e[_setWeightColumnName] as double,
      //           reps: e[_setRepsColumnName] as int,
      //         ))
      //     .toList();

      // print(sets);
    } catch (e) {
      // Handle any exceptions that may occur
      throw Exception("Error retrieving workout sets: $e");
    }
  }

  Future<void> addExercise(
      int routineId,
      String title,
      String image,
      int minRep,
      int maxRep,
      int sets,
      double monthlyProgressGoals,
      String risk,
      String muscleGroups) async {
    try {
      final db = await database;
      await db.insert(
        _exerciseTableName,
        {
          _exerciseRoutineIdColumnName: routineId,
          _exerciseTitleColumnName: title,
          _exerciseImageColumnName: image,
          _exerciseMinRepColumnName: minRep,
          _exerciseMaxRepColumnName: maxRep,
          _exerciseSetsColumnName: sets,
          _exerciseMonthlyProgressGoalsColumnName: monthlyProgressGoals,
          _exerciseRiskColumnName: risk,
          _exerciseMusclesGroupsColumnName: muscleGroups,
        },
      );
      print('Exercise added successfully');
    } catch (e) {
      throw Exception("Error adding exercise: $e");
    }
  }

  Future<void> addNote(int exerciseId, String type, String content) async {
    try {
      final db = await database;
      await db.insert(
        _noteTableName,
        {
          _noteExerciseIdColumnName: exerciseId,
          _noteTypeColumnName: type,
          _noteContentColumnName: content
        },
      );
      print('Note added successfully');
    } catch (e) {
      throw Exception("Error adding exercise: $e");
    }
  }

  Future<void> addWorkout(int exerciseId) async {
    final String query =
        '''INSERT INTO $_workoutTableName ($_workoutExerciseIdColumnName, $_workoutDateColumnName) VALUES (?, datetime('now'));''';
    try {
      final db = await database;
      await db.rawQuery(query, [exerciseId]);

      print('workout created successfully');
    } catch (e) {
      throw Exception("Error adding workout: $e");
    }
  }

  Future<void> addWorkoutWithDate(int exerciseId, String date) async {
    final String query =
        '''INSERT INTO $_workoutTableName ($_workoutExerciseIdColumnName, $_workoutDateColumnName) VALUES (?, ?);''';
    try {
      final db = await database;
      await db.rawQuery(query, [exerciseId, date]);

      print('workout created successfully');
    } catch (e) {
      throw Exception("Error adding workout: $e");
    }
  }

  Future<void> addSet(
      int workoutId, int setNumber, int reps, double weight) async {
    try {
      final db = await database;
      await db.insert(
        _setTableName,
        {
          _setWorkoutIdColumnName: workoutId,
          _setNumberColumnName: setNumber,
          _setRepsColumnName: reps,
          _setWeightColumnName: weight,
        },
      );
      print('set added successfully');
    } catch (e) {
      throw Exception("Error adding set: $e");
    }
  }
}
