import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:objectbox/objectbox.dart';
import 'package:group_project/models/exercise.dart';

@Entity()
class ExercisesSetsInfo {
  @Id()
  int id;
  final exercise = ToOne<Exercise>();
  final currentWorkoutSession = ToOne<CurrentWorkoutSession>();
  final exerciseSets = ToMany<ExerciseSet>();

  ExercisesSetsInfo({
    this.id = 0,
  });
}
