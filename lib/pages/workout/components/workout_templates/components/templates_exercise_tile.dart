import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/components/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';

class TemplatesExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(int exerciseSetId) removeSet;
  final List<ExercisesSetsInfo> exercisesSetsInfoList;
  const TemplatesExerciseTile({
    super.key,
    required this.exerciseData,
    required this.selectExercise,
    required this.removeSet,
    required this.exercisesSetsInfoList,
  });

  @override
  State<TemplatesExerciseTile> createState() => _TemplatesExerciseTileState();
}

class _TemplatesExerciseTileState extends State<TemplatesExerciseTile> {
  void addSet(ExercisesSetsInfo exercisesSetsInfo) {}

  void setIsCompleted(int exerciseSetId) {}

  @override
  Widget build(BuildContext context) {
    if (widget.exercisesSetsInfoList.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 20),
          AddExerciseButton(
            exerciseData: widget.exerciseData,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE1F0CF),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: exercisesSetsInfo.exerciseSets.length,
                        itemBuilder: (context, index) {
                          return SetTiles(
                            exercisesSetsInfo: exercisesSetsInfo,
                            removeSet: widget.removeSet,
                            addSet: addSet,
                            setIsCompleted: setIsCompleted,
                          );
                        },
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          AddExerciseButton(
            exerciseData: widget.exerciseData,
            selectExercise: widget.selectExercise,
          ),
        ],
      );
    }
  }
}
