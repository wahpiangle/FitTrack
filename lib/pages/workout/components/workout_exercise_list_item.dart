import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';

class WorkoutExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final Function(Exercise) onSelectExercise;

  const WorkoutExerciseListItem({
    super.key,
    required this.exercise,
    required this.onSelectExercise,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectExercise(exercise),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: exercise.isSelected ? Colors.grey[800] : null,
            child: ListTile(
              leading: SizedBox(
                width: 50.0,
                height: 50.0,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: exercise.imagePath.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE1F0CF),
                                  borderRadius: BorderRadius.circular(300.0)),
                              child: Center(
                                child: Text(exercise.name[0].toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0)),
                              ),
                            )
                          : Image.asset(exercise.halfImagePath,
                              fit: BoxFit.cover),
                    ),
                    if (exercise.isSelected)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.black45, shape: BoxShape.circle),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
              title: Text(exercise.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16.5)),
              subtitle: Text(
                  "${exercise.bodyPart.target?.name ?? 'N/A'} (${exercise.category.target?.name ?? 'N/A'})",
                  style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ),
          ),
          Divider(
            color: Colors.grey[700],
            height: 0.1,
            thickness: 0.8,
          ),
        ],
      ),
    );
  }
}
