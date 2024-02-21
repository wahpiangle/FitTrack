import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CurrentWorkoutSession {
  @Id()
  int id;
  String title;
  String note;

  // 1 current workout session can have multiple exercises
  // each exercise can have multiple sets
  final exercisesSetsInfo = ToMany<ExercisesSetsInfo>();

  final workoutTemplate = ToOne<WorkoutTemplate>();

  CurrentWorkoutSession({
    this.id = 0,
    this.title = 'Workout',
    this.note = '',
  });
}
