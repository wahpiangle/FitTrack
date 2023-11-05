import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CurrentWorkoutSession {
  @Id()
  int id;
  String title;

  // List<Map<Exercise, List<ExerciseSet>>> exercises;
  List<String> exercises;

  CurrentWorkoutSession({
    this.id = 0,
    this.title = 'Workout',
    this.exercises = const [],
  });
}
