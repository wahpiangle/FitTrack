import 'package:flutter/material.dart';
import 'exercise_list.dart'; // Import the file where Exercise class is defined
import 'exerciselistthemes.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  ExerciseDetailScreen(this.exercise);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ExerciseListThemes.appBarBackground,
      appBar: AppBar(
        title: Text(exercise.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle profile icon tap, if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: ExerciseListThemes.listItemBorderColor,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 4, // Add some shadow for the card
                          child: Column(
                            children: [
                              Image.asset(exercise.imagePath),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Exercise Name: ${exercise.name}',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: ExerciseListThemes.appBarBackground,
                child: Column(
                  children: [
                    for (var letter = 'A'; letter.compareTo('Z') <= 0; letter = String.fromCharCode(letter.codeUnitAt(0) + 1))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          letter,
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
