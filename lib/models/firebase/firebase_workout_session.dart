import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';

class FirebaseWorkoutSession {
  DateTime date;
  int duration;
  List<FirebaseExercisesSetsInfo> exercisesSetsInfo;
  String note;
  String postId;
  String title;

  FirebaseWorkoutSession({
    required this.date,
    required this.duration,
    required this.exercisesSetsInfo,
    required this.note,
    required this.postId,
    required this.title,
  });

  FirebaseWorkoutSession.fromJson(Map<String, dynamic> json)
      : date = json['date'].toDate(),
        duration = json['duration'],
        exercisesSetsInfo = (json['exercisesSetsInfo'] as List<dynamic>).map(
          (exercisesSetsInfo) {
            return FirebaseExercisesSetsInfo(
              exerciseId: exercisesSetsInfo['exercise'],
              exerciseName: exercisesSetsInfo['exerciseName'] ?? '',
              exerciseSets:
                  (exercisesSetsInfo['exerciseSets'] as List<dynamic>).map(
                (exerciseSet) {
                  return ExerciseSet(
                    reps: exerciseSet['reps'],
                    weight: exerciseSet['weight'],
                    isPersonalRecord: exerciseSet['isPersonalRecord'],
                  );
                },
              ).toList(),
            );
          },
        ).toList(),
        note = json['note'] ?? '',
        postId = json['postId'] ?? '',
        title = json['title'] ?? '';
}

class FirebaseExercisesSetsInfo {
  int exerciseId;
  String exerciseName;
  List<ExerciseSet> exerciseSets;

  FirebaseExercisesSetsInfo({
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseSets,
  });

  ExerciseSet getBestSet() {
    return exerciseSets.reduce((a, b) => objectBox.exerciseService
                .getOneRepMaxValue(a.weight ?? 0, a.reps ?? 0) >
            objectBox.exerciseService
                .getOneRepMaxValue(b.weight ?? 0, b.reps ?? 0)
        ? a
        : b);
  }
}
