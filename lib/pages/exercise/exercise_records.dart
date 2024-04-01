import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/exercise/components/edit_exercise.dart';
import 'exercise_navigation_buttons.dart';

class ExerciseRecords extends StatefulWidget {
  final Exercise exercise;

  const ExerciseRecords(this.exercise, {super.key});

  @override
  State<ExerciseRecords> createState() => _ExerciseRecordsState();
}

class _ExerciseRecordsState extends State<ExerciseRecords> {
  int selectedPageIndex = 3;
  String exerciseName = '';

  void updateExerciseName(String newName) {
    setState(() {
      exerciseName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          widget.exercise.isCustom
              ? TextButton(
                  onPressed: () async {
                    final newExerciseName =
                        await EditExerciseDialog.editExercise(
                            context, objectBox, widget.exercise);
                    if (newExerciseName != null) {
                      updateExerciseName(newExerciseName);
                    }
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColours.secondary,
                    ),
                  ),
                )
              : Container(),
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
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    NavigationButtonsRow(
                      selectedPageIndex: selectedPageIndex,
                      exercise: widget.exercise,
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Records',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
