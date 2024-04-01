import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';

class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);
}

class OverallWorkoutBestSet {
  final List<FirebaseWorkoutSession> sessions;

  OverallWorkoutBestSet({required this.sessions});

  Pair<ExerciseSet, String> getOverallBestSet() {
    ExerciseSet? overallBestSet;
    String? overallBestExerciseName;

    for (var session in sessions) {
      for (var exercisesSetsInfo in session.exercisesSetsInfo) {
        var bestSet = exercisesSetsInfo.getBestSet();
        if (overallBestSet == null) {
          overallBestSet = bestSet;
          overallBestExerciseName = exercisesSetsInfo.exerciseName;
        } else {
          bool isCurrentBestSetBetter = objectBox.exerciseService.getOneRepMaxValue(bestSet.weight ?? 0, bestSet.reps ?? 0) >
              objectBox.exerciseService.getOneRepMaxValue(overallBestSet.weight ?? 0, overallBestSet.reps ?? 0);

          if (isCurrentBestSetBetter) {
            overallBestSet = bestSet;
            overallBestExerciseName = exercisesSetsInfo.exerciseName;
          }
        }
      }
    }

    if (overallBestSet != null && overallBestExerciseName != null) {
      return Pair(overallBestSet, overallBestExerciseName);
    } else {
      throw Exception('No best set found');
    }
  }
}
