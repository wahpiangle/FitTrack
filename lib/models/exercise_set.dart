import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ExerciseSet {
  @Id()
  int id;
  int? weight;
  int? reps;
  bool isCompleted = false;
  bool isPersonalRecord = false;

  final exerciseSetInfo = ToOne<ExercisesSetsInfo>();

  ExerciseSet({
    this.id = 0,
    this.weight,
    this.reps,
  });
}
