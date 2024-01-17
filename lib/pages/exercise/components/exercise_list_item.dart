import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final String searchText;

  const ExerciseListItem(
      {super.key, required this.exercise, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final exerciseName = exercise.name;
    final exerciseBodyPart = exercise.bodyPart.target!.name;

    // Check if the exercise name or category contains the search text
    final containsSearchText =
        exerciseName.toLowerCase().contains(searchText.toLowerCase());
    if (searchText.isEmpty || containsSearchText) {
      return Material(
        color: const Color(0xFF1A1A1A),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // Set to false to overlay the existing page
                pageBuilder: (BuildContext context, _, __) {
                  return Stack(
                    children: [
                      // Existing page content
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Container(
                          color: Colors.black.withOpacity(0.8), // Adjust the opacity as needed
                        ),
                      ),
                      // New page content at the center
                      Positioned.fill(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              heightFactor: 0.8,
                              child: ExerciseDetailScreen(exercise),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
          child: ListTile(
            leading: SizedBox(
              height: 80,
              width: 60,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(300.0),
                  child: exercise.imagePath == ''
                      ? Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F0CF),
                            borderRadius: BorderRadius.circular(300.0),
                          ),
                          child: Center(
                            child: Text(
                              exercise.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        )
                      : Image.asset(
                          exercise.halfImagePath,
                          fit: BoxFit.contain,
                        )),
            ),
            title: Text(
              exercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              exerciseBodyPart,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
