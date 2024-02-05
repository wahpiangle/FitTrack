import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'exercise_navigation_buttons.dart';
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
  int selectedPageIndex = 0;
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
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //TODO: Add edit functionality here
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 18,
                color: AppColours.secondary,
              ),
            ),
          )
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
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            NavigationButtonsRow(
              selectedPageIndex: selectedPageIndex,
              exercise: widget.exercise,
            ),
            const SizedBox(height: 10.0),
            Card(
              child: Image.asset(
                widget.exercise.imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Instructions',
                style: TextStyle(fontSize: 18, color: Colors.white),
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
