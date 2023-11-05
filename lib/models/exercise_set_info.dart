import 'package:group_project/models/exercise_set.dart';

class ExerciseSetInfo {
  String name;
  List<ExerciseSet> exerciseSets;

  ExerciseSetInfo({required this.name, required this.exerciseSets});

  factory ExerciseSetInfo.fromJson(Map<String, dynamic> json) {
    return ExerciseSetInfo(
      name: json.keys.first,
      exerciseSets: json.values.first
          .map<ExerciseSet>((exerciseSet) => ExerciseSet.fromJson(exerciseSet))
          .toList(),
    );
  }
}
