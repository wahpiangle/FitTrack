import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:objectbox/objectbox.dart';
import 'package:group_project/models/exercise.dart';

@Entity()
class ExercisesSetsInfo {
  @Id()
  int id;
  final exercise = ToOne<Exercise>();
  final currentWorkoutSession = ToOne<CurrentWorkoutSession>();
  final workoutSession = ToOne<WorkoutSession>();
  final exerciseSets = ToMany<ExerciseSet>();
  final workoutTemplate = ToOne<WorkoutTemplate>();

  ExercisesSetsInfo({
    this.id = 0,
  });
}
