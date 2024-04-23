import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/components/edit_exercise.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'exercise_navigation_buttons.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen(this.exercise, {super.key});
  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  String exerciseName = '';
  int selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    exerciseName = widget.exercise.name;
  }

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

                    !widget.exercise.isCustom
                        ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: Image.asset(
                              widget.exercise.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$exerciseName',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
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
