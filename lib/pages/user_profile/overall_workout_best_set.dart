import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';

class OverallBestSetInfo {
  final ExerciseSet bestSet;
  final String exerciseName;

  OverallBestSetInfo(this.bestSet, this.exerciseName);
}


class OverallWorkoutBestSet {
  final List<FirebaseWorkoutSession> sessions;

  OverallWorkoutBestSet({required this.sessions});

  OverallBestSetInfo getOverallBestSet() {
    ExerciseSet? overallBestSet;
    String? overallBestExerciseName;

    for (var session in sessions) {
      for (var exercisesSetsInfo in session.exercisesSetsInfo) {
        var bestSet = exercisesSetsInfo.getBestSet();
        if (overallBestSet == null) {
          overallBestSet = bestSet;
          overallBestExerciseName = exercisesSetsInfo.exerciseName;

        } else {
          bool isCurrentBestSetBetter = objectBox.exerciseService.getOneRepMaxValue(bestSet.weight ?? 0, bestSet.reps ?? 0, bestSet ) >
              objectBox.exerciseService.getOneRepMaxValue(overallBestSet.weight ?? 0, overallBestSet.reps ?? 0, overallBestSet );

          if (isCurrentBestSetBetter) {
            overallBestSet = bestSet;
            overallBestExerciseName = exercisesSetsInfo.exerciseName;

          }
        }
      }
    }

    if (overallBestSet != null && overallBestExerciseName != null) {
      return OverallBestSetInfo(overallBestSet, overallBestExerciseName);
    } else {
      throw Exception('No best set found');
    }
  }
}
