import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/components/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';

class EditExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(int exerciseSetId) removeSet;
  final void Function(ExercisesSetsInfo exercisesSetsInfo) addSet;
  final List<ExercisesSetsInfo> exercisesSetsInfoList;
  const EditExerciseTile({
    super.key,
    required this.exerciseData,
    required this.selectExercise,
    required this.addSet,
    required this.removeSet,
    required this.exercisesSetsInfoList,
  });

  @override
  State<EditExerciseTile> createState() => _EditExerciseTileState();
}

class _EditExerciseTileState extends State<EditExerciseTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.exercisesSetsInfoList.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 20),
          AddExerciseButton(
            selectExercise: widget.selectExercise,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Column(
            children: widget.exercisesSetsInfoList
                .map(
                  (exercisesSetsInfo) => Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          exercisesSetsInfo.exercise.target!.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE1F0CF),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SetTiles(
                        exercisesSetsInfo: exercisesSetsInfo,
                        removeSet: widget.removeSet,
                        addSet: widget.addSet,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          AddExerciseButton(
            selectExercise: widget.selectExercise,
          ),
        ],
      );
    }
  }
}
