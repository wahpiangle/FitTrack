import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'exercise_navigation_buttons.dart';
import 'exercise_workoutcard.dart';

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
      backgroundColor: AppColours.primary,
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
                color: AppColours.secondary,
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
        child: StreamBuilder<List<WorkoutSession>>(
          stream: objectBox.workoutSessionService.watchWorkoutSession(),
          builder: (context, snapshot) {
            return Column(
              children: [
                const SizedBox(height: 10.0),
                NavigationButtonsRow(
                  selectedPageIndex: selectedPageIndex,
                  exercise: widget.exercise,
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                .where((workoutSession) => workoutSession
                                    .exercisesSetsInfo
                                    .any((info) =>
                                        info.exercise.target?.name ==
                                        widget.exercise.name))
                                .map((workoutSession) {
                              return AutoScrollTag(
                                key: ValueKey(workoutSession.id),
                                controller: _scrollController,
                                index: snapshot.data!.indexWhere((element) =>
                                    element.id == workoutSession.id),
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: ExerciseWorkoutCard(
                                    key: Key(workoutSession.id.toString()),
                                    workoutSession: workoutSession,
                                    exerciseName: widget.exercise.name,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
