import 'package:group_project/models/exercise_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CurrentWorkoutSession {
  @Id()
  int id;
  String title;

  // List<Map<Exercise, List<ExerciseSet>>> exercises;
  // 1 current workout session can have multiple exercises
  // each exercise can have multiple sets
  final exercisesSetsInfo = ToMany<ExercisesSetsInfo>();

  CurrentWorkoutSession({
    this.id = 0,
    this.title = 'Workout',
  });
}
