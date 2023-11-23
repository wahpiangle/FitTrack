import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/components/cancel_workout_button.dart';
import 'package:group_project/pages/workout/components/tiles/components/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';
import 'package:group_project/pages/workout/components/workout_header.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_widget.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<ExercisesSetsInfo> selectedExercises;
  final void Function(Exercise selectedExercise) selectExercise;
  final TimerProvider timerProvider;
  final RestTimerProvider restTimerProvider;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.selectedExercises,
    required this.selectExercise,
    required this.timerProvider,
    required this.restTimerProvider,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}


class _ExerciseTileState extends State<ExerciseTile> {
  late TimerProvider timerProvider;
  late RestTimerProvider restTimerProvider;
  bool isSetCompleted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerProvider = Provider.of<TimerProvider>(context);
    restTimerProvider = Provider.of<RestTimerProvider>(context);
  }

  void removeSet(int exerciseSetId, ExercisesSetsInfo exercisesSetsInfo) {
    objectBox.removeSetFromExercise(exerciseSetId);
    if (exercisesSetsInfo.exerciseSets.length == 1) {
      objectBox.removeExerciseFromCurrentWorkoutSession(
          exercisesSetsInfo.exercise.target!);
    }
    setState(() {
      for (ExercisesSetsInfo exercisesSetsInfo in widget.selectedExercises) {
        exercisesSetsInfo.exerciseSets
            .removeWhere((exerciseSet) => exerciseSet.id == exerciseSetId);
      }
    });
  }

  void addSet(ExercisesSetsInfo exercisesSetsInfo) {
    setState(() {
      objectBox.addSetToExercise(exercisesSetsInfo);
    });
  }

  void setIsCompleted(int exerciseSetId) {
    objectBox.completeExerciseSet(exerciseSetId);
    setState(() {
      for (ExercisesSetsInfo exercisesSetsInfo in widget.selectedExercises) {
        exercisesSetsInfo.exerciseSets
            .where((exerciseSet) => exerciseSet.id == exerciseSetId)
            .toList()
            .forEach((exerciseSet) {
          exerciseSet.isCompleted = !exerciseSet.isCompleted;
          widget.timerProvider.isSetCompleted = exerciseSet.isCompleted;

          if (exerciseSet.isCompleted) {
            widget.restTimerProvider.resetRestTimer(exerciseSet.restTimeInSeconds,context);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.selectedExercises.length + 1,
        itemBuilder: (context, index) {
          if (widget.selectedExercises.isEmpty) {
            return Column(
              children: [
                const WorkoutHeader(),
                AddExerciseButton(
                  exerciseData: widget.exerciseData,
                  selectedExercises: widget.selectedExercises,
                  selectExercise: widget.selectExercise,
                ),
                 CancelWorkoutButton(timerProvider: widget.timerProvider,restTimerProvider: widget.restTimerProvider,),
              ],
            );
          }
          if (index == 0) {
            ExercisesSetsInfo selectedExercise =
                widget.selectedExercises[index];
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
                      removeSet: removeSet,
                      addSet: addSet,
                      setIsCompleted: setIsCompleted,
                    )
                  ],
                ),
              ),
            ]);
          }
          if (index == widget.selectedExercises.length) {
            return Column(children: [
              AddExerciseButton(
                exerciseData: widget.exerciseData,
                selectedExercises: widget.selectedExercises,
                selectExercise: widget.selectExercise,
              ),
              CancelWorkoutButton(timerProvider: widget.timerProvider,restTimerProvider: widget.restTimerProvider, ),
            ]);
          }else {
            ExercisesSetsInfo selectedExercise = widget.selectedExercises[index];
            isSetCompleted = selectedExercise.exerciseSets.any((exerciseSet) => exerciseSet.isCompleted);
            // Display RestTimerWidget if set is completed
            Widget restTimerWidget = isSetCompleted ? RestTimerWidget() : SizedBox.shrink();

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
                        const Spacer(),
                        Expanded(
                          child: restTimerWidget,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SetTiles(
                    exercisesSetsInfo: selectedExercise,
                    removeSet: removeSet,
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

  String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }


}
