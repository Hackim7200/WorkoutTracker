import 'dart:math';

import 'package:flutter/material.dart';
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
  final String _routineOrderColumnName = "routine_order";

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
  final String _exerciseOrderColumnName = "exercise_order";

  final String _exerciseMonthlyProgressGoalsColumnName = "monthlyProgressGoals";
  final String _exerciseMinRepColumnName = "min_rep";
  final String _exerciseMaxRepColumnName = "max_rep";

  //Note table and column
  final String _noteTableName = "Note";
  final String _noteIdColumnName = "id";
  final String _noteExerciseIdColumnName = "exercise_id";
  final String _noteTypeColumnName = "type";
  final String _noteContentColumnName = "content";
  final String _noteOrderColumnName = "note_order";

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
            $_routineImageColumnName TEXT NOT NULL,
            $_routineOrderColumnName INTEGER NOT NULL
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
            $_exerciseOrderColumnName INTEGER NOT NULL,  -- **Added missing comma**
            $_exerciseMonthlyProgressGoalsColumnName REAL NOT NULL,
            $_exerciseMinRepColumnName INTEGER NOT NULL, 
            $_exerciseMaxRepColumnName INTEGER NOT NULL,
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
            $_noteOrderColumnName INTEGER NOT NULL,
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
            $_setPercentageChangeColumnName REAL NOT NULL,
            $_setDifferenceColumnName REAL NOT NULL,
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
            $_cardioSetPercentageChangeColumnName REAL NOT NULL,
            $_cardioSetDifferenceColumnName INTEGER NOT NULL,
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

  Future<void> addRoutine(String name, String description, String image) async {
    try {
      final db = await database;

      // Get the next available order number
      final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COALESCE(MAX($_routineOrderColumnName), 0) + 1 AS nextOrder
      FROM $_routineTableName
    ''');

      int nextOrder = result.first['nextOrder'] ?? 1;

      await db.insert(
        _routineTableName,
        {
          _routineTitleColumnName: name,
          _routineDescriptionColumnName: description,
          _routineImageColumnName: image,
          _routineOrderColumnName: nextOrder, // Auto-increment order
        },
      );

      print('Routine added successfully with order: $nextOrder');
    } catch (e) {
      throw Exception("Error adding routine: $e");
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

  // Get a routine by ID from the database
  Future<Map<String, dynamic>?> getRoutine(int id) async {
    final db = await database;
    final result = await db.query(
      _routineTableName,
      where: '$_routineIdColumnName = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<ExerciseModel>> getExercises(int routineId) async {
    final db = await database; // Get the database instance

    try {
      // Query the Exercise table
      final data = await db.query(
        _exerciseTableName,
        where: '$_exerciseRoutineIdColumnName = ?', // Filter by routineId
        whereArgs: [routineId], // Pass routineId as an argument
        orderBy:
            '$_exerciseOrderColumnName ASC', // Orders exercises by `exercise_order`
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
              sets: e[_exerciseSetsColumnName] as int,
              type: e[_exerciseTypeColumnName] as String,
              minRep: e[_exerciseMinRepColumnName] as int,
              maxRep: e[_exerciseMaxRepColumnName] as int,
              order: e[_exerciseOrderColumnName] as int,
              monthlyProgressGoals:
                  e[_exerciseMonthlyProgressGoalsColumnName] as double))
          .toList();
      return exercises;
    } catch (e) {
      throw Exception("Error retrieving exercises: $e");
    }
  }

// Get an exercise by ID from the database
  Future<Map<String, dynamic>?> getExercise(int id) async {
    final db = await database;
    final result = await db.query(
      _exerciseTableName,
      where: '$_exerciseIdColumnName = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<NoteModel>> getNotes(int routineId, int exerciseId) async {
    final db = await database; // Get the database instance
    final String query = '''
    SELECT Note.id as id,Note.type as type, Note.content as content 
    FROM Note
    JOIN Exercise ON Note.$_noteExerciseIdColumnName = Exercise.$_exerciseIdColumnName
    JOIN Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
    WHERE Routine.$_routineIdColumnName = ? AND Exercise.$_exerciseIdColumnName = ?
    ORDER BY Note.$_noteOrderColumnName ASC;
  ''';

    try {
      // Query the database with the provided routineId and exerciseId
      final data = await db.rawQuery(query, [routineId, exerciseId]);
      print(data);

      // Map the query results to a list of WorkoutNote objects
      List<NoteModel> notes = data
          .map((e) => NoteModel(
                id: e[_noteIdColumnName]
                    as int, // Ensure column name matches the database schema
                content: e[_noteContentColumnName] as String,
                type: e[_noteTypeColumnName] as String,
                // order:e[_noteOrderColumnName] as int
              ))
          .toList();
      print(data.toString());

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

        // print("Workout ID: $workoutId, Date: $date");

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
    FROM $_strengthSetTableName
    JOIN $_workoutTableName ON $_workoutTableName.$_workoutIdColumnName = $_strengthSetTableName.$_setWorkoutIdColumnName
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
        print("data of last set$data ");

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
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff1,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 1 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange1,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight2,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps2,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff2,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 2 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange2,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight3,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps3,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff3,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 3 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange3,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight4,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps4,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff4,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 4 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange4,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight5,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps5,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff5,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 5 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange5,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight6,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps6,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff6,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 6 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange6,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight7,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps7,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff7,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 7 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange7,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight8,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps8,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff8,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 8 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange8,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight9,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps9,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff9,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 9 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange9,

    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setWeightColumnName END) AS weight10,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setRepsColumnName END) AS reps10,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS weightDiff10,
    MAX(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = 10 THEN StrengthTrainingSet.$_setPercentageChangeColumnName END) AS percentageChange10

  FROM $_workoutTableName AS Workout
  JOIN $_exerciseTableName AS Exercise ON Exercise.$_exerciseIdColumnName = Workout.$_workoutExerciseIdColumnName
  JOIN $_routineTableName AS Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
  JOIN $_strengthSetTableName AS StrengthTrainingSet ON StrengthTrainingSet.$_setWorkoutIdColumnName = Workout.$_workoutIdColumnName
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

  Future<int> getLastSetNumber(
      int routineId, int exerciseId, int workoutId) async {
    final db = await database;

    final String query = '''
    SELECT MAX($_setNumberColumnName) AS lastSetNumber
    FROM $_strengthSetTableName
    JOIN $_workoutTableName 
      ON $_workoutTableName.$_workoutIdColumnName = $_strengthSetTableName.$_setWorkoutIdColumnName
    JOIN $_exerciseTableName 
      ON $_exerciseTableName.$_exerciseIdColumnName = $_workoutTableName.$_workoutExerciseIdColumnName
    JOIN $_routineTableName 
      ON $_routineTableName.$_routineIdColumnName = $_exerciseTableName.$_exerciseRoutineIdColumnName
    WHERE $_routineTableName.$_routineIdColumnName = ? 
      AND $_exerciseTableName.$_exerciseIdColumnName = ? 
      AND $_workoutTableName.$_workoutIdColumnName = ?;
  ''';

    try {
      final data = await db.rawQuery(query, [routineId, exerciseId, workoutId]);

      if (data.isNotEmpty && data.first['lastSetNumber'] != null) {
        print(data);
        print("Last strength set number found: ${data.first['lastSetNumber']}");

        return data.first['lastSetNumber'] as int;
      } else {
        print("No prevous set found. Returning 0.");
        return 0;
      }
    } catch (e) {
      print("Error retrieving last strength set number: $e");
      return 0;
    }
  }

  Future<int> getLastWorkoutId(int exerciseId, int workoutId) async {
    final db = await database;

    final String query = '''
     SELECT *
    FROM $_strengthSetTableName
    JOIN $_workoutTableName 
      ON $_workoutTableName.$_workoutIdColumnName = $_strengthSetTableName.$_setWorkoutIdColumnName
    JOIN $_exerciseTableName 
      ON $_exerciseTableName.$_exerciseIdColumnName = $_workoutTableName.$_workoutExerciseIdColumnName
    WHERE $_exerciseTableName.$_exerciseIdColumnName = ? 
      AND $_workoutTableName.$_workoutIdColumnName = ?;
  ''';

    try {
      final data = await db.rawQuery(query, [exerciseId, workoutId]);

      if (data.isNotEmpty && data.first['workout_id'] != null) {
        print(data);
        print("Last workout id found: ${data.first['workout_id']}");

        return data.first['workout_id'] as int;
      } else {
        print("No workoutId found.");
        return -1;
      }
    } catch (e) {
      print("Error retrieving last workout id: $e");
      return -1;
    }
  }

  Future<void> addExercise(
      int routineId,
      String title,
      String image,
      int sets,
      String risk,
      String muscleGroups,
      String type,
      double monthlyProgressGoals,
      int minRep,
      int maxRep) async {
    try {
      final db = await database;

      // Get the next available order number
      final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COALESCE(MAX($_exerciseOrderColumnName), 0) + 1 AS nextOrder
      FROM $_exerciseTableName
      WHERE $_exerciseRoutineIdColumnName = ?
    ''', [routineId]);

      int nextOrder = result.first['nextOrder'] ?? 1;

      await db.insert(
        _exerciseTableName,
        {
          _exerciseRoutineIdColumnName: routineId,
          _exerciseImageColumnName: image,
          _exerciseTitleColumnName: title,
          _exerciseRiskColumnName: risk,
          _exerciseSetsColumnName: sets,
          _exerciseMusclesGroupsColumnName: muscleGroups,
          _exerciseTypeColumnName: type,
          _exerciseMonthlyProgressGoalsColumnName: monthlyProgressGoals,
          _exerciseMinRepColumnName: minRep,
          _exerciseMaxRepColumnName: maxRep,
          _exerciseOrderColumnName: nextOrder, // Auto-increment order
        },
      );
      print('Exercise added successfully with order: $nextOrder');
    } catch (e) {
      throw Exception("Error adding exercise: $e");
    }
  }

  Future<void> addNote(int exerciseId, String type, String content) async {
    try {
      final db = await database;

      //   // Get the next available order number for the given exercise
      //   final List<Map<String, dynamic>> result = await db.rawQuery('''
      //   SELECT COALESCE(MAX($_noteOrderColumnName), 0) + 1 AS nextOrder
      //   FROM $_noteTableName
      //   WHERE $_noteExerciseIdColumnName = ?
      // ''', [exerciseId]);

      //   int nextOrder = result.first['nextOrder'] ?? 1;

      int order = -1;
      if (type == "CAUTION") {
        order = 1;
      } else if (type == "TIPS") {
        order = 2;
      } else {
        order = 3;
      }

      await db.insert(
        _noteTableName,
        {
          _noteExerciseIdColumnName: exerciseId,
          _noteTypeColumnName: type,
          _noteContentColumnName: content,
          _noteOrderColumnName: order, // Auto-increment order
        },
      );

      print('Note added successfully with order: $order');
    } catch (e) {
      throw Exception("Error adding note: $e");
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

  Future<void> addSet(int workoutId, int setNumber, int reps, double weight,
      double difference, double percentageChange) async {
    try {
      final db = await database;
      await db.insert(
        _strengthSetTableName,
        {
          _setWorkoutIdColumnName: workoutId,
          _setNumberColumnName: setNumber,
          _setRepsColumnName: reps,
          _setWeightColumnName: weight,
          _setDifferenceColumnName: difference,
          _setPercentageChangeColumnName: percentageChange
        },
      );
      print('set added successfully');
    } catch (e) {
      throw Exception("Error adding set: $e");
    }
  }

  Future<Map<String, dynamic>?> getSetsOfSecondToLastWorkout(
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
JOIN $_strengthSetTableName AS StrengthTrainingSet ON StrengthTrainingSet.$_setWorkoutIdColumnName = Workout.$_workoutIdColumnName
WHERE Routine.$_routineIdColumnName = ? 
  AND Exercise.$_exerciseIdColumnName = ?
  AND Workout.$_workoutDateColumnName < CURRENT_DATE
GROUP BY Workout.$_workoutIdColumnName
ORDER BY Workout.$_workoutDateColumnName DESC
LIMIT 1;

  ''';

    try {
      final List<Map<String, dynamic>> data =
          await db.rawQuery(query, [routineId, exerciseId]);

      if (data.isEmpty) {
        return null; // Return an empty map if there's no second-to-last workout
      }

      final Map<String, dynamic> workout = {
        "id": data.first["id"],
        "date": data.first["date"],
        "weights": [
          data.first["weight1"] ?? 0.0,
          data.first["weight2"] ?? 0.0,
          data.first["weight3"] ?? 0.0,
          data.first["weight4"] ?? 0.0,
          data.first["weight5"] ?? 0.0,
          data.first["weight6"] ?? 0.0,
          data.first["weight7"] ?? 0.0,
          data.first["weight8"] ?? 0.0,
          data.first["weight9"] ?? 0.0,
          data.first["weight10"] ?? 0.0
        ],
        "reps": [
          data.first["reps1"] ?? 0,
          data.first["reps2"] ?? 0,
          data.first["reps3"] ?? 0,
          data.first["reps4"] ?? 0,
          data.first["reps5"] ?? 0,
          data.first["reps6"] ?? 0,
          data.first["reps7"] ?? 0,
          data.first["reps8"] ?? 0,
          data.first["reps9"] ?? 0,
          data.first["reps10"] ?? 0
        ],
      };

      print("---------- $workout");

      return workout; // Wrap in a list to match return type
    } catch (e) {
      throw Exception("Error retrieving workout sets: $e");
    }
  }

  Future<void> addCardioSet(int workoutId, int setNumber, int time,
      double intensity, int difference, double percentageChange) async {
    try {
      final db = await database;
      await db.insert(
        _cardioSetTableName,
        {
          _cardioSetWorkoutIdColumnName: workoutId,
          _cardioSetNumberColumnName: setNumber,
          _cardioSetIntensityColumnName: intensity,
          _cardioSetTimeColumnName: time,
          _cardioSetDifferenceColumnName: difference,
          _cardioSetPercentageChangeColumnName: percentageChange
        },
      );
      print('set added successfully');
    } catch (e) {
      throw Exception("Error adding set: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getCardioSetsOfAllWorkouts(
      int routineId, int exerciseId) async {
    final db = await database;

    final String query = '''
  SELECT 
    Workout.$_workoutIdColumnName AS id,
    Workout.$_workoutDateColumnName AS date,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 1 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time1,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 1 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference1,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 1 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange1,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 1 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity1,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 2 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time2,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 2 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference2,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 2 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange2,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 2 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity2,
    
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 3 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time3,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 3 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference3,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 3 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange3,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 3 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity3,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 4 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time4,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 4 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference4,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 4 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange4,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 4 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity4,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 5 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time5,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 5 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference5,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 5 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange5,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 5 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity5,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 6 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time6,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 6 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference6,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 6 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange6,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 6 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity6,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 7 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time7,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 7 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference7,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 7 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange7,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 7 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity7,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 8 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time8,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 8 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference8,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 8 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange8,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 8 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity8,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 9 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time9,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 9 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference9,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 9 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange9,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 9 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity9,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 10 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time10,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 10 THEN CardioTrainingSet.$_cardioSetDifferenceColumnName END) AS difference10,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 10 THEN CardioTrainingSet.$_cardioSetPercentageChangeColumnName END) AS percentageChange10,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 10 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity10
    
  FROM $_workoutTableName AS Workout
  JOIN $_exerciseTableName AS Exercise ON Exercise.$_exerciseIdColumnName = Workout.$_workoutExerciseIdColumnName
  JOIN $_routineTableName AS Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
  JOIN $_cardioSetTableName AS CardioTrainingSet ON CardioTrainingSet.$_cardioSetWorkoutIdColumnName = Workout.$_workoutIdColumnName
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
          "times": [for (int i = 1; i <= 10; i++) element["time$i"] ?? 0.0],
          "differences": [
            for (int i = 1; i <= 10; i++) element["difference$i"] ?? 0.0
          ],
          "percentageChanges": [
            for (int i = 1; i <= 10; i++) element["percentageChange$i"] ?? 0.0
          ],
          "intensities": [
            for (int i = 1; i <= 10; i++) element["intensity$i"] ?? 0.0
          ]
        });
      }
      print(workouts);

      return workouts;
    } catch (e) {
      throw Exception("Error retrieving cardio workout sets: $e");
    }
  }

  Future<Map<String, dynamic>?> getCardioSetsOfSecondToLastWorkout(
      int routineId, int exerciseId) async {
    final db = await database;

    final String query = '''
  SELECT 
    Workout.$_workoutIdColumnName AS id,
    Workout.$_workoutDateColumnName AS date,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 1 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time1,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 1 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity1,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 2 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time2,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 2 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity2,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 3 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time3,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 3 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity3,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 4 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time4,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 4 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity4,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 5 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time5,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 5 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity5,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 6 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time6,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 6 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity6,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 7 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time7,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 7 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity7,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 8 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time8,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 8 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity8,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 9 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time9,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 9 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity9,

    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 10 THEN CardioTrainingSet.$_cardioSetTimeColumnName END) AS time10,
    MAX(CASE WHEN CardioTrainingSet.$_cardioSetNumberColumnName = 10 THEN CardioTrainingSet.$_cardioSetIntensityColumnName END) AS intensity10
FROM $_workoutTableName AS Workout
JOIN $_exerciseTableName AS Exercise ON Exercise.$_exerciseIdColumnName = Workout.$_workoutExerciseIdColumnName
JOIN $_routineTableName AS Routine ON Routine.$_routineIdColumnName = Exercise.$_exerciseRoutineIdColumnName
JOIN $_cardioSetTableName AS CardioTrainingSet ON CardioTrainingSet.$_cardioSetWorkoutIdColumnName = Workout.$_workoutIdColumnName
WHERE Routine.$_routineIdColumnName = ? 
  AND Exercise.$_exerciseIdColumnName = ?
  AND Workout.$_workoutDateColumnName < CURRENT_DATE
GROUP BY Workout.$_workoutIdColumnName
ORDER BY Workout.$_workoutDateColumnName DESC
LIMIT 1;

  ''';

    try {
      final List<Map<String, dynamic>> data =
          await db.rawQuery(query, [routineId, exerciseId]);

      if (data.isEmpty) {
        return null; // Return an empty map if there's no second-to-last workout
      }

      final Map<String, dynamic> workout = {
        "id": data.first["id"],
        "date": data.first["date"],
        "times": [
          data.first["time1"] ?? 0,
          data.first["time2"] ?? 0,
          data.first["time3"] ?? 0,
          data.first["time4"] ?? 0,
          data.first["time5"] ?? 0,
          data.first["time6"] ?? 0,
          data.first["time7"] ?? 0,
          data.first["time8"] ?? 0,
          data.first["time9"] ?? 0,
          data.first["time10"] ?? 0
        ],
        "intensities": [
          data.first["intensity1"] ?? 0.0,
          data.first["intensity2"] ?? 0.0,
          data.first["intensity3"] ?? 0.0,
          data.first["intensity4"] ?? 0.0,
          data.first["intensity5"] ?? 0.0,
          data.first["intensity6"] ?? 0.0,
          data.first["intensity7"] ?? 0.0,
          data.first["intensity8"] ?? 0.0,
          data.first["intensity9"] ?? 0.0,
          data.first["intensity10"] ?? 0.0
        ]
      };

      print("---------- $workout");

      return workout; // Return the workout with times and intensities
    } catch (e) {
      throw Exception("Error retrieving workout sets: $e");
    }
  }

  Future<int> getLastSetNumberCardio(
      int routineId, int exerciseId, int workoutId) async {
    final db = await database;

    final String query = '''
    SELECT MAX($_cardioSetNumberColumnName) AS lastSetNumber
    FROM $_cardioSetTableName
    JOIN $_workoutTableName 
      ON $_workoutTableName.$_workoutIdColumnName = $_cardioSetTableName.$_cardioSetWorkoutIdColumnName
    JOIN $_exerciseTableName 
      ON $_exerciseTableName.$_exerciseIdColumnName = $_workoutTableName.$_workoutExerciseIdColumnName
    JOIN $_routineTableName 
      ON $_routineTableName.$_routineIdColumnName = $_exerciseTableName.$_exerciseRoutineIdColumnName
    WHERE $_routineTableName.$_routineIdColumnName = ? 
      AND $_exerciseTableName.$_exerciseIdColumnName = ? 
      AND $_workoutTableName.$_workoutIdColumnName = ?;
  ''';

    try {
      final data = await db.rawQuery(query, [routineId, exerciseId, workoutId]);

      if (data.isNotEmpty && data.first['lastSetNumber'] != null) {
        print("Last set number found: ${data.first['lastSetNumber']}");
        return data.first['lastSetNumber'] as int;
      } else {
        print("No sets found. Returning 0.");
        return 0;
      }
    } catch (e) {
      print("Error retrieving last set number: $e");
      return 0;
    }
  }

  Future<void> checkCardioSetsForWorkout(int workoutId) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> sets = await db.query(
        _cardioSetTableName,
        where: '$_cardioSetWorkoutIdColumnName = ?',
        whereArgs: [workoutId],
      );

      if (sets.isEmpty) {
        print('No cardio sets found for workoutId: $workoutId');
      } else {
        print('Cardio sets for workoutId $workoutId:');
        for (var set in sets) {
          print(set);
        }
      }
    } catch (e) {
      print('Error checking cardio sets: $e');
    }
  }

  Future<void> updateRoutine(
      int id, String title, String description, String image) async {
    try {
      final db = await database;
      await db.update(
        _routineTableName,
        {
          _routineTitleColumnName: title,
          _routineDescriptionColumnName: description,
          _routineImageColumnName: image,
        },
        where: '$_routineIdColumnName = ?',
        whereArgs: [id],
      );
      print('Routine updated: $title, $description, $image');
    } catch (e) {
      print('Not updated: $e');
    }
  }

  Future<void> updateExercise({
    required int id,
    required int routineId,
    required String title,
    required String image,
    required String musclesGroups,
    required String risk,
    required int sets,
    required String exerciseType,
    required double monthlyProgressGoals,
    required int minRep,
    required int maxRep,
  }) async {
    try {
      final db = await database;
      await db.update(
        _exerciseTableName,
        {
          _exerciseRoutineIdColumnName: routineId,
          _exerciseTitleColumnName: title,
          _exerciseImageColumnName: image,
          _exerciseMusclesGroupsColumnName: musclesGroups,
          _exerciseRiskColumnName: risk,
          _exerciseSetsColumnName: sets,
          _exerciseTypeColumnName: exerciseType,
          _exerciseMonthlyProgressGoalsColumnName: monthlyProgressGoals,
          _exerciseMinRepColumnName: minRep,
          _exerciseMaxRepColumnName: maxRep,
        },
        where: '$_exerciseIdColumnName = ?',
        whereArgs: [id],
      );
      print('Exercise updated: $title');
    } catch (e) {
      print('Not updated: $e');
    }
  }

  Future<void> deleteRoutine(int routineId) async {
    try {
      final db = await database;
      await db.delete(
        _routineTableName,
        where: '$_routineIdColumnName = ?',
        whereArgs: [routineId],
      );
      print('Routine deleted: $routineId');
    } catch (e) {
      print('Not deleted: $e');
    }
  }

  Future<void> deleteExercise(int exerciseId) async {
    try {
      final db = await database;
      await db.delete(
        _exerciseTableName,
        where: '$_exerciseIdColumnName = ?',
        whereArgs: [exerciseId],
      );
      print('Exercise deleted: $exerciseId');
    } catch (e) {
      print('Not deleted: $e');
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      final db = await database;
      await db.delete(
        _noteTableName,
        where: '$_noteIdColumnName = ?',
        whereArgs: [noteId],
      );
      print('Note deleted: $noteId');
    } catch (e) {
      print('Not deleted: $e');
    }
  }

  Future<void> deleteWorkout(int workoutId) async {
    try {
      final db = await database;
      await db.delete(
        _workoutTableName,
        where: '$_workoutIdColumnName = ?',
        whereArgs: [workoutId],
      );
      print('Workout deleted: $workoutId');
    } catch (e) {
      print('Not deleted: $e');
    }
  }

  Future<List<double>?> getProgressForThisMonth(
      int exerciseId, int setNumber) async {
    final db = await database;

    // Generate dynamic SQL for up to 10 sets
    String generateSetProgressColumns(int setNumber) {
      return '''
      SUM(CASE WHEN StrengthTrainingSet.$_setNumberColumnName = $setNumber 
        THEN StrengthTrainingSet.$_setDifferenceColumnName END) AS "progress$setNumber"
    ''';
    }

    // Generate the SQL for all 10 sets
    String setProgressColumns =
        List.generate(10, (i) => generateSetProgressColumns(i + 1)).join(',');

    final String query = '''
    SELECT strftime('%Y-%m', Workout."$_workoutDateColumnName") AS "Month",
           $setProgressColumns
    FROM "$_exerciseTableName" Exercise
    JOIN "$_workoutTableName" Workout 
      ON Workout."$_workoutExerciseIdColumnName" = Exercise."$_exerciseIdColumnName"
    JOIN "$_strengthSetTableName" StrengthTrainingSet 
      ON StrengthTrainingSet."$_setWorkoutIdColumnName" = Workout."$_workoutIdColumnName"
    WHERE Exercise."$_exerciseIdColumnName" = ?
    GROUP BY "Month"
    ORDER BY "Month" DESC
    LIMIT 1;
  ''';

    try {
      final data = await db.rawQuery(query, [exerciseId]);

      List<double> progress = [];
      if (data.isNotEmpty) {
        print(data);

        for (int i = 1; i <= setNumber; i++) {
          progress.add(data.first["progress$i"] == null
              ? 0.0
              : data.first["progress$i"] as double);
        }
        return progress;
      } else {
        return null;

        print("No progress found for this month.");
      }
    } catch (e) {
      print("Error retrieving progress for this month: $e");
      return null;
    }
  }

  Future<int> getLastExerciseOrder(int routine_id) async {
    {
      final db = await database;

      final String query = '''
    SELECT MAX($_exerciseOrderColumnName) AS exercise_order
    FROM $_exerciseTableName
    WHERE $_routineIdColumnName = ?;
    
  ''';

      try {
        final data = await db.rawQuery(query, [routine_id]);

        if (data.isNotEmpty && data.first['exercise_order'] != null) {
          print("Last order number found: ${data.first['exercise_order']}");
          return data.first['exercise_order'] as int;
        } else {
          print("No exercises order found. Returning 0.");
          return 0;
        }
      } catch (e) {
        print("Error retrieving last exercise order: $e");
        return 0;
      }
    }
  }

  Future<void> reorderExercise(int movedId, int oldIndex, int newIndex) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        if (oldIndex < newIndex) {
          // Moving down: Shift all in between up
          await txn.rawUpdate('''
          UPDATE $_exerciseTableName 
          SET $_exerciseOrderColumnName = $_exerciseOrderColumnName - 1
          WHERE $_exerciseOrderColumnName > ? AND $_exerciseOrderColumnName <= ?
        ''', [oldIndex, newIndex]);
        } else {
          // Moving up: Shift all in between down
          await txn.rawUpdate('''
          UPDATE $_exerciseTableName 
          SET $_exerciseOrderColumnName = $_exerciseOrderColumnName + 1
          WHERE $_exerciseOrderColumnName >= ? AND $_exerciseOrderColumnName < ?
        ''', [newIndex, oldIndex]);
        }

        // Place the moved exercise in its new position
        await txn.rawUpdate('''
        UPDATE $_exerciseTableName 
        SET $_exerciseOrderColumnName = ?
        WHERE $_exerciseIdColumnName = ?
      ''', [newIndex, movedId]);
      });

      print('Exercise moved from $oldIndex to $newIndex');
    } catch (e) {
      print('Failed to reorder exercise: $e');
    }
  }

  // old working code  Future<void> reorderExercise(
  //     int firstId, int lastId, int firstOrder, int lastOrder) async {
  //   try {
  //     final db = await database;

  //     // Temporarily set the first exercise's order to a unique value
  //     await db.update(
  //       _exerciseTableName,
  //       {_exerciseOrderColumnName: -1}, // Temporary placeholder
  //       where: '$_exerciseIdColumnName = ?',
  //       whereArgs: [firstId],
  //     );

  //     // Update the second exercise with the first exercise's order
  //     await db.update(
  //       _exerciseTableName,
  //       {_exerciseOrderColumnName: firstOrder},
  //       where: '$_exerciseIdColumnName = ?',
  //       whereArgs: [lastId],
  //     );

  //     // Finally, set the first exercise to the second exercise's order
  //     await db.update(
  //       _exerciseTableName,
  //       {_exerciseOrderColumnName: lastOrder},
  //       where: '$_exerciseIdColumnName = ?',
  //       whereArgs: [firstId],
  //     );

  //     print('Exercise order updated: $firstOrder ↔ $lastOrder');
  //   } catch (e) {
  //     print('Failed to update exercise order: $e');
  //   }
  // }
}

//     Future<void>? reorderRoutine() {
//       return null;
//     }

//     Future<void>? reorderNote() {
//       return null;

// }
