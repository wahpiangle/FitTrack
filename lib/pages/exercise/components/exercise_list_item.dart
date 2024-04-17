import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final String searchText;
  final VoidCallback onToggleVisibility;
  final bool isCustom;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    required this.searchText,
    required this.onToggleVisibility,
    required this.isCustom,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseName = exercise.name;
    final exerciseBodyPart = exercise.bodyPart.target?.name ?? ' ';
    final exerciseCategory = exercise.category.target?.name ?? ' ';
    final containsSearchText = exerciseName.toLowerCase().contains(searchText.toLowerCase());

    // Style for the subtitle to display body part and category as 'Body Part (Category)'
    final subtitleText = '$exerciseBodyPart ($exerciseCategory)';

    if (searchText.isEmpty || containsSearchText) {
      return Column(
        children: [
          Material(
            color: const Color(0xFF1A1A1A),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailScreen(exercise),
                  ),
                );
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
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
                    ),
                  ),
                ),
                title: Text(
                  exerciseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(
                  subtitleText,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
           Divider(
            color: Colors.grey[700], height: 0.1, thickness: 0.8,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
