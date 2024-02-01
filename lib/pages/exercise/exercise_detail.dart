import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/exercise_records.dart';
import 'package:group_project/pages/exercise/exercise_charts.dart';
import 'exercise_history.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen(this.exercise, {super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //TODO: Add edit functionality here
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {},
          icon: IconButton(
            icon: const Icon(Icons.close_sharp, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Center(
          child: Text(
            widget.exercise.name,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPageIndex = 0;
                    });
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return ExerciseDetailScreen(
                            widget.exercise,
                            key: const PageStorageKey('exerciseDetailScreen'),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPageIndex == 0
                        ? const Color(0xFF555555)
                        : const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('About'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPageIndex = 1;
                    });
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return ExerciseHistory(
                            widget.exercise,
                            key: const PageStorageKey('exerciseHistory'),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPageIndex == 1
                        ? const Color(0xFF555555)
                        : const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('History'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPageIndex = 2;
                    });
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return ExerciseCharts(
                            widget.exercise,
                            key: const PageStorageKey('exerciseCharts'),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPageIndex == 2
                        ? const Color(0xFF555555)
                        : const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Charts'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPageIndex = 3;
                    });
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return ExerciseRecords(
                            widget.exercise,
                            key: const PageStorageKey('exerciseRecords'),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPageIndex == 3
                        ? const Color(0xFF555555)
                        : const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Records'),
                ),
              ],
            ),
            Card(
              child: Image.asset(
                widget.exercise.imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Instructions',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
