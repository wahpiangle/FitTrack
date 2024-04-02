import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';

class OverallBestSetInfo {
  final ExerciseSet bestSet;
  final String exerciseName;
  final bool isPersonalRecord;

  OverallBestSetInfo(this.bestSet, this.exerciseName, this.isPersonalRecord);
}


class OverallWorkoutBestSet {
  final List<FirebaseWorkoutSession> sessions;

  OverallWorkoutBestSet({required this.sessions});

  OverallBestSetInfo getOverallBestSet() {
    ExerciseSet? overallBestSet;
    String? overallBestExerciseName;
    bool overallIsPersonalRecord = false;

    for (var session in sessions) {
      for (var exercisesSetsInfo in session.exercisesSetsInfo) {
        var bestSet = exercisesSetsInfo.getBestSet();
        if (overallBestSet == null) {
          overallBestSet = bestSet;
          overallBestExerciseName = exercisesSetsInfo.exerciseName;
          overallIsPersonalRecord = bestSet.isPersonalRecord;

        } else {
          bool isCurrentBestSetBetter = objectBox.exerciseService.getOneRepMaxValue(bestSet.weight ?? 0, bestSet.reps ?? 0) >
              objectBox.exerciseService.getOneRepMaxValue(overallBestSet.weight ?? 0, overallBestSet.reps ?? 0);

          if (isCurrentBestSetBetter) {
            overallBestSet = bestSet;
            overallBestExerciseName = exercisesSetsInfo.exerciseName;
            overallIsPersonalRecord = bestSet.isPersonalRecord;

          }
        }
      }
    }

    if (overallBestSet != null && overallBestExerciseName != null) {
      return OverallBestSetInfo(overallBestSet, overallBestExerciseName, overallIsPersonalRecord);
    } else {
      throw Exception('No best set found');
    }
  }
}
