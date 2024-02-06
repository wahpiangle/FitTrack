import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/exercise_list_theme.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/components/edit_exercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen(this.exercise, {super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  String exerciseName = '';

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
      backgroundColor: ExerciseListThemes.appBarBackground,
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  children: [
                    Stack(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$exerciseName',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () async {
                              final newExerciseName = await EditExerciseDialog.editExercise(context, objectBox, widget.exercise);
                              if (newExerciseName != null) {
                                updateExerciseName(newExerciseName);
                              }
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
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
