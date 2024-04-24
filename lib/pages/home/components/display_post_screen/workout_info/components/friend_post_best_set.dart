import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';


class FriendPostBestSet extends StatelessWidget {
  final FirebaseWorkoutSession workoutSession;
  const FriendPostBestSet({super.key, required this.workoutSession});


  String getCategory(List<ExerciseSet> exerciseSets) {
    // For other categories, check ExerciseSet properties
    for (var exerciseSet in exerciseSets) {
      if (exerciseSet.weight != null && exerciseSet.reps != null) {
        return "WeightAndReps";
      } else if (exerciseSet.reps != null) {
        return "Reps Only";
      } else if (exerciseSet.time != null) {
        return "Duration";
      }
    }

    // Default category if no specific criteria match
    return "Unknown";
  }


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

    final bestSet = bestExerciseSetInfo.exerciseSets.reduce((ExerciseSet a, ExerciseSet b) {
      // Get one-rep max values for comparison
      final aOneRepMax = (a.weight != null && a.reps != null)
          ? objectBox.exerciseService.getOneRepMaxValue(a.weight!, a.reps!, a)
          : (a.reps ?? 0); // If it's reps-only, consider reps as one-rep max
      final bOneRepMax = (b.weight != null && b.reps != null)
          ? objectBox.exerciseService.getOneRepMaxValue(b.weight!, b.reps!, b)
          : (b.reps ?? 0);

      // Compare based on the type of sets
      if (a.time != null && b.time != null) {
        return a.time! > b.time! ? a : b; // For duration sets, compare times
      } else if (a.weight != null && a.reps != null && b.weight != null && b.reps != null) {
        return aOneRepMax > bOneRepMax ? a : b; // For weight and reps sets, compare one-rep max
      } else {
        return aOneRepMax > bOneRepMax ? a : b; // For reps-only sets, compare reps
      }
    });

    String getExerciseText(ExerciseSet bestSet) {
      final category = getCategory(bestExerciseSetInfo.exerciseSets);
      if (category == "WeightAndReps") {
        return '${bestSet.weight} kg x ${bestSet.reps}';
      } else if (category == "Reps Only") {
        return '${bestSet.reps} reps';
      } else if (category == "Duration") {
        return formatDurationFromSeconds(bestSet.time ?? 0);
      } else {
        return '${bestSet.weight} kg x ${bestSet.reps}';
      }
    }

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


String formatDurationFromSeconds(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0'); // Pad minutes with leading zero if necessary
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0'); // Pad seconds with leading zero if necessary

  if (hours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}





