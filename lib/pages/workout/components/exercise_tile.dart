import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/cancel_workout_button.dart';
import 'package:group_project/pages/workout/components/set_tiles.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<ExercisesSetsInfo> selectedExercises;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(Exercise selectedExercise) removeExercise;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.selectedExercises,
    required this.selectExercise,
    required this.removeExercise,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool checkBox = false;

  void removeSet(int exerciseSetId) {
    objectBox.removeSetFromExercise(exerciseSetId);
    setState(() {
      widget.selectedExercises.forEach((exercisesSetsInfo) {
        exercisesSetsInfo.exerciseSets.removeWhere((exerciseSet) =>
        exerciseSet.id == exerciseSetId);
      });
    });
    // Optionally, call removeExerciseName here if needed
    // removeExerciseName(exerciseSetId);
  }


  void removeExerciseName(int exerciseSetId) {
    // Remove set from the exercise
    objectBox.removeSetFromExercise(exerciseSetId);

    // Remove exercise sets with no sets in the list
    setState(() {
      widget.selectedExercises.removeWhere((exercisesSetsInfo) {
        exercisesSetsInfo.exerciseSets.removeWhere((exerciseSet) {
          return exerciseSet.id == exerciseSetId;
        });
        return exercisesSetsInfo.exerciseSets.isEmpty;
      });
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    //TODO: Handle the workout title
                    'snapshot.data!.title',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    //TODO: Handle the workout note
                  },
                  decoration: InputDecoration(
                    hintText: 'Add a workout note',
                    hintStyle: const TextStyle(
                      color: Color(0xFFC1C1C1),
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: const Color(0xFF333333),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AddExerciseButton(
                  exerciseData: widget.exerciseData,
                  selectedExercises: widget.selectedExercises,
                  selectExercise: widget.selectExercise,
                  removeExercise: widget.removeExercise,
                ),
                const CancelWorkoutButton(),
              ]),
            );
          }
          if (index == 0) {
            ExercisesSetsInfo selectedExercise =
                widget.selectedExercises[index];
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        //TODO: Handle the workout title
                        'snapshot.data!.title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        //TODO: Handle the workout note
                      },
                      decoration: InputDecoration(
                        hintText: 'Add a workout note',
                        hintStyle: const TextStyle(
                          color: Color(0xFFC1C1C1),
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: const Color(0xFF333333),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
                      exercisesSetsInfoId: selectedExercise.id,
                      exerciseName: selectedExercise.exercise.target!.name,
                      exerciseSet: selectedExercise.exerciseSets,
                      removeSet: removeSet,
                      removeExerciseName: (int exerciseNameId) {
                        removeExerciseName(exerciseNameId);
                      },
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
                removeExercise: widget.removeExercise,
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
                    exercisesSetsInfoId: selectedExercise.id,
                    exerciseName: selectedExercise.exercise.target!.name,
                    exerciseSet: selectedExercise.exerciseSets,
                    removeSet: removeSet,
                    removeExerciseName: (int exerciseNameId) {
                      removeExerciseName(exerciseNameId);
                    },
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
