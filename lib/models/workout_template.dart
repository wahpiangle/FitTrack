import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class WorkoutTemplate {
  @Id()
  int id;
  String title;
  String note;
  DateTime createdAt;
  DateTime? lastPerformedAt;

  final exercisesSetsInfo = ToMany<ExercisesSetsInfo>();

  WorkoutTemplate({
    this.id = 0,
    this.title = 'Workout',
    this.note = '',
    required this.createdAt,
    this.lastPerformedAt,
  });
}
