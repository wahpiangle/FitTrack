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
              exerciseName: exercisesSetsInfo['exerciseName'],
              exerciseSets:
                  (exercisesSetsInfo['exerciseSets'] as List<dynamic>).map(
                (exerciseSet) {
                  return ExerciseSet(
                    reps: exerciseSet['reps'],
                    weight: exerciseSet['weight'],
                  );
                },
              ).toList(),
            );
          },
        ).toList(),
        note = json['note'],
        postId = json['postId'] ?? '',
        title = json['title'];
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
}
