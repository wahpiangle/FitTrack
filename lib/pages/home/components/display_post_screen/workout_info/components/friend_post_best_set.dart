import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';

import '../../../../../../models/exercise_set.dart';

class FriendPostBestSet extends StatelessWidget {
  final FirebaseWorkoutSession workoutSession;
  const FriendPostBestSet({super.key, required this.workoutSession});

  @override
  Widget build(BuildContext context) {
    final bestExerciseSetInfo = workoutSession.exercisesSetsInfo.reduce((a, b) {
      final aOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        a.exerciseSets[0].weight ?? 0,
        a.exerciseSets[0].reps ?? 0,
      );
      final bOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        b.exerciseSets[0].weight ?? 0,
        b.exerciseSets[0].reps ?? 0,
      );
      return aOneRepMax > bOneRepMax ? a : b;
    });
    final bestSet = bestExerciseSetInfo.exerciseSets.reduce((a, b) {
      final aOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        a.weight ?? 0,
        a.reps ?? 0,
      );
      final bOneRepMax = objectBox.exerciseService.getOneRepMaxValue(
        b.weight ?? 0,
        b.reps ?? 0,
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
              getWeightRepsText(bestSet),
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

String getWeightRepsText(ExerciseSet bestSet) {
  if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == 'Assisted Bodyweight') {
    return '-${bestSet.weight} kg x ${bestSet.reps}';
  } else if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == 'Weighted Bodyweight') {
    return '+${bestSet.weight} kg x ${bestSet.reps}';
  } else if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == 'Reps Only') {
    return '${bestSet.reps} reps';
  } else if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == 'Duration') {
    final timeString = bestSet.time.toString();
    if (timeString.length == 3) {
      return '${timeString[0]}:${timeString[1]}${timeString[2]}';
    } else if (timeString.length == 4) {
      return '${timeString[0]}${timeString[1]}:${timeString[2]}${timeString[3]}';
    } else if (timeString.length == 5) {
      return '${timeString[0]}:${timeString[1]}${timeString[2]}:${timeString[3]}${timeString[4]}';
    }
    return '-';

  } else {
    return '${bestSet.weight} kg x ${bestSet.reps}';
  }
}
