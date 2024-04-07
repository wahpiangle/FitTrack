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
      final aReps = a.exerciseSets[0].time ??
          0; // Change this to get the reps directly from the ExerciseSet
      final bReps = b.exerciseSets[0].time ??
          0; // Change this to get the reps directly from the ExerciseSet
      return aReps > bReps ? a : b;
    });
    final bestDurationSet = bestDurationSetInfo.exerciseSets.firstOrNull;

    final bestRepsonlySetInfo = workoutSession.exercisesSetsInfo.reduce((a, b) {
      final aReps = a.exerciseSets[0].reps ??
          0; // Change this to get the reps directly from the ExerciseSet
      final bReps = b.exerciseSets[0].reps ??
          0; // Change this to get the reps directly from the ExerciseSet
      return aReps > bReps ? a : b;
    });
    final bestRepsSet = bestRepsonlySetInfo.exerciseSets.firstOrNull;

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
              getBestExerciseName(bestSet, bestRepsSet, bestDurationSet,
                  bestExerciseSetInfo.exerciseName),
              style: const TextStyle(
                color: AppColours.secondary,
                fontSize: 12,
              ),
            ),
            Text(
              getExerciseText(bestSet, bestRepsSet, bestDurationSet),
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
  if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Assisted Bodyweight') {
    return '-${bestSet.weight} kg x ${bestSet.reps}';
  } else if (bestSet
          .exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Weighted Bodyweight') {
    return '+${bestSet.weight} kg x ${bestSet.reps}';
  } else if (bestSet
          .exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Reps Only') {
    return '${bestSet.reps} reps';
  } else if (bestSet
          .exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Duration') {
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

String getDurationText(ExerciseSet? bestDurationSet) {
  if (bestDurationSet == null) {
    return ''; // No best set available
  }
  final timeString = bestDurationSet.time.toString();
  if (timeString.length == 3) {
    return '${timeString[0]}:${timeString[1]}${timeString[2]}';
  } else if (timeString.length == 4) {
    return '${timeString[0]}${timeString[1]}:${timeString[2]}${timeString[3]}';
  } else if (timeString.length == 5) {
    return '${timeString[0]}:${timeString[1]}${timeString[2]}:${timeString[3]}${timeString[4]}';
  } else {
    return '-'; // Invalid time format
  }
}

String getRepsOnlyText(ExerciseSet? bestRepsSet) {
  if (bestRepsSet == null) {
    return ''; // No best set available
  }
  if (bestRepsSet
          .exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Reps Only') {
    return '${bestRepsSet.reps} reps';
  } else {
    return '-'; // Invalid time format
  }
}

String getBestExerciseName(ExerciseSet bestSet, ExerciseSet? bestRepsSet,
    ExerciseSet? bestDurationSet, String bestExerciseName) {
  if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == 'Assisted Bodyweight' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Weighted Bodyweight' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Barbell' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Dumbbell' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Machine' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Cable' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Band' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Other') {
    return bestSet.exerciseSetInfo.target!.exercise.target!.name;
  } else if (bestRepsSet
          ?.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Reps Only') {
    return bestRepsSet!.exerciseSetInfo.target!.exercise.target!.name;
  } else if (bestDurationSet
          ?.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Duration') {
    return bestDurationSet!.exerciseSetInfo.target!.exercise.target!.name;
  } else {
    return '-';
  }
}

String getExerciseText(ExerciseSet bestSet, ExerciseSet? bestRepsSet,
    ExerciseSet? bestDurationSet) {
  if (bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == 'Assisted Bodyweight' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Weighted Bodyweight' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Barbell' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Dumbbell' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Machine' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Cable' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Band' ||
      bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
          'Other') {
    return getWeightRepsText(bestSet);
  } else if (bestRepsSet
          ?.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Reps Only') {
    return getRepsOnlyText(bestRepsSet!);
  } else if (bestDurationSet
          ?.exerciseSetInfo.target?.exercise.target?.category.target?.name ==
      'Duration') {
    return getDurationText(bestDurationSet!);
  } else {
    return "-";
  }
}
