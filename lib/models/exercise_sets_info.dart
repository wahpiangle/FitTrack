import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ExercisesSetsInfo {
  @Id()
  int id;
  String name; //TODO: Convert this to a ToOne<Exercise> relationships

  final currentWorkoutSession = ToOne<CurrentWorkoutSession>();
  final exerciseSets = ToMany<ExerciseSet>();

  ExercisesSetsInfo({
    this.id = 0,
    required this.name,
  });
}
