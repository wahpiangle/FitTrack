import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
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
    final exerciseBodyPart = exercise.bodyPart.target?.name ?? '';
    final containsSearchText = exerciseName.toLowerCase().contains(searchText.toLowerCase());

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
          ),
          const Divider(
            color: AppColours.secondaryLight,
            height: 5,
            thickness: 0.2,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
