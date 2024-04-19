import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';

import '../../../../../../models/workout_session.dart';
import '../../../../../layout/user_profile_provider.dart';

class FriendPostBestSet extends StatelessWidget {
  final FirebaseWorkoutSession workoutSession;
  const FriendPostBestSet({super.key, required this.workoutSession});



  @override
  Widget build(BuildContext context) {
    final bestExerciseSetInfo = workoutSession.exercisesSetsInfo.reduce((a, b) {
      final aOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        a.exerciseSets[0].weight ?? 0,
        a.exerciseSets[0].reps ?? 0,
        a.exerciseSets[0], // Pass the ExerciseSet object
      );
      final bOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        b.exerciseSets[0].weight ?? 0,
        b.exerciseSets[0].reps ?? 0,
        b.exerciseSets[0], // Pass the ExerciseSet object
      );
      return aOneRepMax > bOneRepMax ? a : b;
    });
    final bestSet = bestExerciseSetInfo.exerciseSets.reduce((a, b) {
      final aOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        a.weight ?? 0,
        a.reps ?? 0,
        a, // Pass the ExerciseSet object
      );
      final bOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        b.weight ?? 0,
        b.reps ?? 0,
        b, // Pass the ExerciseSet object
      );
      return aOneRepMax > bOneRepMax ? a : b;
    });


    return Row(
      children: [
        const Icon(
          Icons.emoji_events_sharp,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Best',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              bestExerciseSetInfo.exerciseName,
              style: const TextStyle(
                color: AppColours.secondary,
                fontSize: 12,
              ),
            ),
            Text(
              getExerciseText(bestSet),
              style: const TextStyle(
                color: AppColours.secondary,
                fontSize: 12,
              ),
            ),
          ],
        )
      ],
    );
  }
}



String getExerciseText(ExerciseSet exerciseSet) {
  final category = exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;

  if (category == "Assisted Bodyweight") {
    return '-${exerciseSet.weight} kg x ${exerciseSet.reps} reps';
  } else if (category == "Weighted Bodyweight") {
    return '+${exerciseSet.weight} kg x ${exerciseSet.reps} reps';
  } else if (category == "Duration") {
    return '${exerciseSet.duration}';
  } else if (category == "Reps Only") {
    return '${exerciseSet.reps} reps';
  } else {
    return '${exerciseSet.weight} kg x ${exerciseSet.reps}';
  }
}






