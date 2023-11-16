import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/components/cancel_workout_button.dart';
import 'package:group_project/pages/workout/components/tiles/components/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';
import 'package:group_project/pages/workout/components/workout_header.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<ExercisesSetsInfo> selectedExercises;
  final void Function(Exercise selectedExercise) selectExercise;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.selectedExercises,
    required this.selectExercise,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool checkBox = false;

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
                const CancelWorkoutButton(),
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
              const CancelWorkoutButton(),
            ]);
          } else {
            ExercisesSetsInfo selectedExercise =
                widget.selectedExercises[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
