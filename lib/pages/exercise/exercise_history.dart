import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/exercise_records.dart';
import 'package:group_project/pages/exercise/exercise_charts.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../main.dart';
import '../../models/workout_session.dart';
import '../history/complete_workout/complete_workout_card.dart';

class ExerciseHistory extends StatefulWidget {
  final Exercise exercise;
  const ExerciseHistory(this.exercise, {super.key});

  @override
  State<ExerciseHistory> createState() => _ExerciseHistoryState();
}

class _ExerciseHistoryState extends State<ExerciseHistory> {
  final AutoScrollController _scrollController = AutoScrollController();

  void scrollToItem(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
    await _scrollController.highlight(index);
  }

  int selectedPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add edit functionality here
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
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: StreamBuilder<List<WorkoutSession>>(
          stream: objectBox.workoutSessionService.watchWorkoutSession(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  key: PageStorageKey('exerciseDetailScreen'),
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
                                  key: PageStorageKey('exerciseHistory'),
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
                                  key: PageStorageKey('exerciseCharts'),
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
                                  key: PageStorageKey('exerciseRecords'),
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
                ),
                Expanded(
                  child: snapshot.data!
                          .where((workoutSession) =>
                              workoutSession.exercisesSetsInfo.any((info) =>
                                  info.exercise.target?.name ==
                                  widget.exercise.name))
                          .isEmpty
                      ? const Column(
                          children: [
                            SizedBox(height: 200.0),
                            Text(
                              'Exercise History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Previous performance of this exercise will display here - check back later!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          controller: _scrollController,
                          children: snapshot.data!
                              .where((workoutSession) =>
                                  workoutSession.exercisesSetsInfo.any((info) =>
                                      info.exercise.target?.name ==
                                      widget.exercise.name))
                              .map((workoutSession) {
                            return AutoScrollTag(
                              key: ValueKey(workoutSession.id),
                              controller: _scrollController,
                              index: snapshot.data!.indexWhere(
                                  (element) => element.id == workoutSession.id),
                              child: IgnorePointer(
                                ignoring:
                                    true, // Set to true to make the child unpressable
                                child: CompleteWorkoutCard(
                                  key: Key(workoutSession.id.toString()),
                                  workoutSession: workoutSession,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 10.0),
              ],
            );
          },
        ),
      ),
    );
  }
}