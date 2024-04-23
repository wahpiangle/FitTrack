import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';


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

    final bestDurationSetInfo = workoutSession.exercisesSetsInfo.reduce((a, b) {
      final aTime = a.exerciseSets[0].time ?? 0; // Get the time from ExerciseSet
      final bTime = b.exerciseSets[0].time ?? 0; // Get the time from ExerciseSet
      return aTime > bTime ? a : b;
    });
    final bestDurationSet = bestDurationSetInfo.exerciseSets[0]; // Get the first ExerciseSet with the highest time


    final bestRepsonlySetInfo = workoutSession.exercisesSetsInfo.reduce((a, b) {
      final aReps = a.exerciseSets[0].reps ?? 0; // Get the reps directly from ExerciseSet
      final bReps = b.exerciseSets[0].reps ?? 0; // Get the reps directly from ExerciseSet
      return aReps > bReps ? a : b;
    });
    final bestRepsSet = bestRepsonlySetInfo.exerciseSets[0]; // Get the first ExerciseSet with the highest reps



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
              getExerciseText(bestSet, bestDurationSet!, bestRepsSet!),
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



String getExerciseText(ExerciseSet bestSet, ExerciseSet bestDurationSet, ExerciseSet bestRepsSet) {
  final category = bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;
  final categoryDuration = bestDurationSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;
  final categoryReps = bestRepsSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;

  if (category == "Assisted Bodyweight") {
    return '-${bestSet.weight} kg x ${bestSet.reps} reps';
  } else if (category == "Weighted Bodyweight") {
    return '+${bestSet.weight} kg x ${bestSet.reps} reps';
  } else if (categoryDuration == "Duration") {
    return '${bestDurationSet.duration}';
  } else if (categoryReps == "Reps Only") {
    return '${bestSet.reps} reps';
  } else {
    return '${bestSet.weight} kg x ${bestSet.reps}';
  }
}






