import 'package:group_project/models/category.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

import 'body_part.dart';

@Entity()
class Exercise {
  @Id()
  int id;
  String name;
  String imagePath;
  String halfImagePath;
  bool isSelected;
  bool isVisible;
  final bodyPart = ToOne<BodyPart>();
  final category = ToOne<Category>();
  final exercisesSetsInfo = ToMany<ExercisesSetsInfo>();

  Exercise({
    this.id = 0,
    required this.name,
    this.imagePath = '',
    this.halfImagePath = '',
    this.isSelected = false,
    this.isVisible = true, required categoryId, required bodyPartId,
  });
}