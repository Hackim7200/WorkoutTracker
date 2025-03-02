import 'package:flutter/material.dart';
import 'package:workout_tracker/database/database_service.dart';

class DifferenceFromGoal extends StatelessWidget {
  final int exerciseId, setNumber;
  final double monthlyProgressGoals;
  DifferenceFromGoal(
      {Key? key,
      required this.exerciseId,
      required this.setNumber,
      required this.monthlyProgressGoals})
      : super(key: key);

  final DatabaseService databaseService = DatabaseService.instance;

  Future<List<double>> initialiseVariables() async {
    final progress =
        await databaseService.getProgressForThisMonth(exerciseId, setNumber);
    return progress ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = const Color.fromRGBO(245, 236, 213, 1);

    return FutureBuilder<List<double>>(
      future: initialiseVariables(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No progress data available.'));
        }

        final progressData = snapshot.data!;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: progressData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.blueGrey,
                    margin: EdgeInsets.all(0),
                    elevation: 4,
                    child: Container(
                      width: 80,
                      // height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Set ${index + 1}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${monthlyProgressGoals - snapshot.data![index]}', // You can replace this with dynamic data
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                monthlyProgressGoals - snapshot.data![index] ==
                                        0
                                    ? 'On Target'
                                    : monthlyProgressGoals -
                                                snapshot.data![index] >
                                            0
                                        ? 'Behind'
                                        : 'Ahead',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
