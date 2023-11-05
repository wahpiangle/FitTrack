import 'package:group_project/models/exercise_set.dart';

class ExerciseSetInfo {
  String name;
  List<ExerciseSet> exerciseSet;

  ExerciseSetInfo({required this.name, required this.exerciseSet});

  factory ExerciseSetInfo.fromJson(Map<String, dynamic> json) {
    return ExerciseSetInfo(
      name: json.keys.first,
      exerciseSet: json.values.first
          .map<ExerciseSet>((exerciseSet) => ExerciseSet.fromJson(exerciseSet))
          .toList(),
    );
  }
}
