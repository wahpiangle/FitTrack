import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/cancel_workout_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';
import 'package:group_project/pages/workout/components/workout_header.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<ExercisesSetsInfo> exercisesSetsInfo;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(int exerciseSetId) removeSet;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.exercisesSetsInfo,
    required this.selectExercise,
    required this.removeSet,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  void addSet(ExercisesSetsInfo exercisesSetsInfo) {
    setState(() {
      objectBox.exerciseService.addSetToExercise(exercisesSetsInfo);
    });
  }

  void setIsCompleted(int exerciseSetId) {
    objectBox.exerciseService.completeExerciseSet(exerciseSetId);
    setState(() {
      for (ExercisesSetsInfo exercisesSetsInfo in widget.exercisesSetsInfo) {
        exercisesSetsInfo.exerciseSets
            .where((exerciseSet) => exerciseSet.id == exerciseSetId)
            .toList()
            .forEach((exerciseSet) {
          if (exerciseSet.reps != null && exerciseSet.weight != null) {
            exerciseSet.isCompleted = !exerciseSet.isCompleted;
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
        itemCount: widget.exercisesSetsInfo.length + 1,
        itemBuilder: (context, index) {
          if (widget.exercisesSetsInfo.isEmpty) {
            return Column(
              children: [
                const WorkoutHeader(),
                AddExerciseButton(
                  exerciseData: widget.exerciseData,
                  selectExercise: widget.selectExercise,
                ),
                const CancelWorkoutButton(),
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
                          fontSize: 14,
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
                selectExercise: widget.selectExercise,
              ),
              const CancelWorkoutButton(),
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
                    child: Text(
                      selectedExercise.exercise.target!.name,
                      style: const TextStyle(
                        fontSize: 14,
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
            );
          }
        },
      ),
    );
  }
}
