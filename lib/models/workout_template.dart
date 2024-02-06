import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class WorkoutTemplate {
  @Id()
  int id;
  String title;
  String note;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime? lastPerformedAt;

  bool isCurrentEditing;

  final exercisesSetsInfo = ToMany<ExercisesSetsInfo>();

  WorkoutTemplate({
    this.id = 0,
    this.title = 'Workout',
    this.note = '',
    required this.createdAt,
    this.lastPerformedAt,
    this.isCurrentEditing = false,
  });
}
