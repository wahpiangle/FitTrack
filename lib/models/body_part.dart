import 'package:objectbox/objectbox.dart';

@Entity()
class BodyPart {
  @Id()
  int id;
  String name;

  BodyPart({this.id = 0, required this.name});
}
