import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/exercise_list_theme.dart';
import 'package:group_project/models/exercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen(this.exercise, {Key? key}) : super(key: key);

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
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
                      alignment: Alignment.bottomCenter, // Aligns the image at the bottom of the Stack
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: Image.asset(
                              widget.exercise.imagePath,
                              fit: BoxFit.cover, // Ensure the image covers the whole area
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
                            'Exercise Name: ${widget.exercise.name}',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(width: 4), // Adjust the width as needed
                          IconButton(
                            onPressed: () {
                              // Handle edit button press
                            },
                            icon: Icon(Icons.edit),
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
