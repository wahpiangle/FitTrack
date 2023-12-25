import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/components/cancel_workout_button.dart';
import 'package:group_project/pages/workout/components/tiles/components/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';
import 'package:group_project/pages/workout/components/workout_header.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';

import '../timer/resttimer_details_dialog.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<ExercisesSetsInfo> exercisesSetsInfo;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(int exerciseSetId) removeSet;
  final TimerProvider timerProvider;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.exercisesSetsInfo,
    required this.selectExercise,
    required this.removeSet,
    required this.timerProvider,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late TimerProvider timerProvider;
  late RestTimerProvider restTimerProvider;
  bool isSetCompleted = false;
  bool displayRestTimer = false;
  late int restTimerDuration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerProvider = Provider.of<TimerProvider>(context);
    restTimerProvider =
        Provider.of<RestTimerProvider>(context); // Initialize restTimerProvider
    restTimerDuration = restTimerProvider.restTimerDuration;
  }

  void addSet(ExercisesSetsInfo exercisesSetsInfo) {
    setState(() {
      objectBox.addSetToExercise(exercisesSetsInfo);
    });
  }

  void setIsCompleted(int exerciseSetId) {
    objectBox.completeExerciseSet(exerciseSetId);
    setState(() {
      for (ExercisesSetsInfo exercisesSetsInfo in widget.exercisesSetsInfo) {
        exercisesSetsInfo.exerciseSets
            .where((exerciseSet) => exerciseSet.id == exerciseSetId)
            .toList()
            .forEach((exerciseSet) {
          if (exerciseSet.reps != null && exerciseSet.weight != null) {
            exerciseSet.isCompleted = !exerciseSet.isCompleted;
          }

          if (exerciseSet.isCompleted && restTimerProvider.isRestTimerEnabled) {
            // Start the rest timer when a set is completed
            restTimerProvider.startRestTimer(context);
            // Set the flag to display the rest timer
            displayRestTimer = true;
            //show the rest timer details dialog
            showRestTimerDetailsDialog(context);
          } else {
            // Cancel the rest timer when a set is not completed
            restTimerProvider.stopRestTimer();
            // Set the flag to hide the rest timer
            displayRestTimer = false;
          }
        });
      }
    });
  }

  //To show the RestTimerDetailsDialog
  void showRestTimerDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestTimerDetailsDialog(
          restTimerProvider: restTimerProvider,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.exercisesSetsInfo.length + 1,
        itemBuilder: (context, index) {
          if (widget.exercisesSetsInfo.isEmpty) {
            return Column(
              children: [
                const WorkoutHeader(),
                AddExerciseButton(
                  exerciseData: widget.exerciseData,
                  exercisesSetsInfo: widget.exercisesSetsInfo,
                  selectExercise: widget.selectExercise,
                ),
                CancelWorkoutButton(
                  timerProvider: widget.timerProvider,
                ),
              ],
            );
          }
          if (index == 0) {
            ExercisesSetsInfo selectedExercise =
                widget.exercisesSetsInfo[index];
            return Column(children: [
              const WorkoutHeader(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        selectedExercise.exercise.target!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE1F0CF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SetTiles(
                      exercisesSetsInfo: selectedExercise,
                      removeSet: widget.removeSet,
                      addSet: addSet,
                      setIsCompleted: setIsCompleted,
                    )
                  ],
                ),
              ),
            ]);
          }
          if (index == widget.exercisesSetsInfo.length) {
            return Column(children: [
              AddExerciseButton(
                exerciseData: widget.exerciseData,
                exercisesSetsInfo: widget.exercisesSetsInfo,
                selectExercise: widget.selectExercise,
              ),
              CancelWorkoutButton(
                timerProvider: widget.timerProvider,
              ),
            ]);
          } else {
            ExercisesSetsInfo selectedExercise =
                widget.exercisesSetsInfo[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Text(
                          selectedExercise.exercise.target!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE1F0CF),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SetTiles(
                    exercisesSetsInfo: selectedExercise,
                    removeSet: widget.removeSet,
                    addSet: addSet,
                    setIsCompleted: setIsCompleted,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
