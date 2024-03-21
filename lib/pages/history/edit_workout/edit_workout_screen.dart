import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/history/edit_workout/dialogs/revert_dialog.dart';
import 'package:group_project/pages/history/edit_workout/dialogs/save_dialog.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/edit_exercise_tile.dart';

class EditWorkoutScreen extends StatefulWidget {
  final int workoutSessionId;
  final bool fromDetailPage;
  const EditWorkoutScreen({
    super.key,
    required this.workoutSessionId,
    required this.fromDetailPage,
  });

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  WorkoutSession? editingWorkoutSession =
      objectBox.workoutSessionService.getEditingWorkoutSession();
  List<Exercise> exerciseData = objectBox.exerciseService.getAllExercises();

  void selectExercise(Exercise selectedExercise) {
    objectBox.workoutSessionService
        .addExerciseToEditingWorkoutSession(selectedExercise);
    setState(() {
      editingWorkoutSession =
          objectBox.workoutSessionService.getEditingWorkoutSession();
    });
  }

  void removeSet(int exerciseSetId) {
    objectBox.exerciseService.removeSetFromExercise(exerciseSetId);
    setState(() {
      editingWorkoutSession =
          objectBox.workoutSessionService.getEditingWorkoutSession();
    });
  }

  void addSet(ExercisesSetsInfo exercisesSetsInfo) {
    setState(() {
      objectBox.exerciseService.addSetToExercise(exercisesSetsInfo);
    });
  }

  @override
  void dispose() {
    objectBox.workoutSessionService.deleteEditingWorkoutSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.black26,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const RevertDialog(
                  isWorkoutSession: true,
                );
              },
            );
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Edit Workout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(5),
            child: TextButton(
              onPressed: () {
                objectBox.workoutSessionService.editingWorkoutSessionHasChanges(
                  widget.workoutSessionId,
                )
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SaveDialog(
                            workoutSessionId: widget.workoutSessionId,
                            fromDetailPage: widget.fromDetailPage,
                            isWorkoutSession: true,
                          );
                        },
                      )
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'There are no changes!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColours.primary,
                        ),
                      );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColours.secondary),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
               TextFormField(
                initialValue: editingWorkoutSession!.title,
                onChanged: (value) {
                  objectBox.workoutSessionService
                      .updateEditingWorkoutSessionTitle(
                          widget.workoutSessionId, value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 10),
                  isDense: true,
                  hintText: 'Template Title',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                initialValue: editingWorkoutSession!.note,
                onChanged: (value) {
                  objectBox.workoutSessionService
                      .updateEditingWorkoutSessionNote(
                          widget.workoutSessionId, value);
                },
                decoration: InputDecoration(
                  hintText: 'Add a workout note',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  fillColor: const Color(0xFF333333),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              EditExerciseTile(
                exerciseData: objectBox.exerciseService.getAllExercises(),
                selectExercise: selectExercise,
                removeSet: removeSet,
                addSet: addSet,
                exercisesSetsInfoList: editingWorkoutSession!.exercisesSetsInfo,
                isEditing: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
