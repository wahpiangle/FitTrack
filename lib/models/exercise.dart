import 'package:group_project/models/category.dart';
import 'package:objectbox/objectbox.dart';
import 'body_part.dart';
import 'exercise_set.dart';

@Entity()
class Exercise {
  @Id()
  int id;
  String name;
  String imagePath = '';

  final bodyPart = ToOne<BodyPart>();
  final category = ToOne<Category>();

  final exerciseSets = ToMany<ExerciseSet>();

  Exercise({this.id = 0, required this.name, this.imagePath = '',});

  get sets => null;

  get reps => null;
}
