import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ExerciseSet {
  @Id()
  int id;
  int? weight;
  int? reps;
  int? setNumber;
  bool isCompleted = false;
  int? recentWeight;
  int? recentReps;

  final exerciseSetInfo = ToOne<ExercisesSetsInfo>();
  final exercise = ToOne<Exercise>();

  ExerciseSet({
    this.id = 0,
    this.weight,
    this.reps,
    this.setNumber,
    this.recentReps,
    this.recentWeight,
  });
}
