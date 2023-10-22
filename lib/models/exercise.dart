import 'package:group_project/models/category.dart';
import 'package:objectbox/objectbox.dart';

import 'body_part.dart';

@Entity()
class Exercise {
  @Id()
  int id;
  String name;
  String imagePath = '';

  final bodyPart = ToOne<BodyPart>();
  final category = ToOne<Category>();

  Exercise({this.id = 0, required this.name, this.imagePath = ''});
}
