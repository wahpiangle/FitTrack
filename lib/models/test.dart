import 'package:objectbox/objectbox.dart';

@Entity()
class Test {
  @Id()
  int id;
  String name;

  Test({this.id = 0, required this.name});
}
