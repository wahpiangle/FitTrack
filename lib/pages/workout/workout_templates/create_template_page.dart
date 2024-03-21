import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:group_project/pages/workout/components/tiles/edit_exercise_tile.dart';

class CreateTemplatePage extends StatefulWidget {
  const CreateTemplatePage({
    super.key,
  });

  @override
  State<CreateTemplatePage> createState() => _CreateTemplatePageState();
}

class _CreateTemplatePageState extends State<CreateTemplatePage> {
  WorkoutTemplate editingWorkoutTemplate =
      objectBox.workoutTemplateService.getEditingWorkoutTemplate();
  List<Exercise> exerciseData = objectBox.exerciseService.getAllExercises();

  void selectExercise(Exercise selectedExercise) {
    objectBox.workoutTemplateService
        .addExerciseToEditingWorkoutTemplate(selectedExercise);
    setState(() {
      editingWorkoutTemplate =
          objectBox.workoutTemplateService.getEditingWorkoutTemplate();
    });
  }

  void removeSet(int exerciseSetId) {
    objectBox.exerciseService.removeSetFromExercise(exerciseSetId);
    setState(() {
      editingWorkoutTemplate =
          objectBox.workoutTemplateService.getEditingWorkoutTemplate();
    });
  }

  void addSet(ExercisesSetsInfo exercisesSetsInfo) {
    setState(() {
      objectBox.exerciseService.addSetToExercise(exercisesSetsInfo);
    });
  }

  void _askToDiscard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColours.primary,
          surfaceTintColor: Colors.transparent,
          title: const Center(
            child: Text(
              'Discard Template?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            'Are you sure you want to discard this template? All changes will be lost.',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.black38,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        objectBox.workoutTemplateService
                            .deleteEditingWorkoutTemplate();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Discard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _askToSave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColours.primary,
          surfaceTintColor: Colors.transparent,
          title: const Center(
            child: Text(
              'Save Template?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            'Are you sure you want to save this template?',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.black38,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        try {
                          objectBox.workoutTemplateService
                              .saveEditingWorkoutTemplate();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                error.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: AppColours.primary,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColours.secondary,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    objectBox.workoutTemplateService.deleteEditingWorkoutTemplate();
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
            _askToDiscard();
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'New Template',
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
                _askToSave();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColours.secondary,
                ),
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
                onChanged: (value) {
                  editingWorkoutTemplate.title = value;
                  objectBox.workoutTemplateService
                      .updateEditingWorkoutTemplateTitle(
                    editingWorkoutTemplate.title,
                  );
                },
                initialValue: editingWorkoutTemplate.title,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 10),
                  isDense: true,
                  hintText: 'Template Title',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onChanged: (value) {
                  editingWorkoutTemplate.note = value;
                  objectBox.workoutTemplateService
                      .updateEditingWorkoutTemplateNote(
                    editingWorkoutTemplate.note,
                  );
                },
                initialValue: editingWorkoutTemplate.note,
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
                exerciseData: exerciseData,
                selectExercise: selectExercise,
                removeSet: removeSet,
                addSet: addSet,
                exercisesSetsInfoList: editingWorkoutTemplate.exercisesSetsInfo,
                isEditing: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
