import 'package:group_project/models/exercise_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ExerciseSet {
  @Id()
  int id;
  int weight;
  int reps;
  bool isCompleted = false;

  final exerciseSetInfo = ToOne<ExercisesSetsInfo>();

  // TODO: make nullable to certain fields as some sets don't require weight or reps, maybe add a time field also
  ExerciseSet({
    this.id = 0,
    required this.weight,
    required this.reps,
  });
}
