import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id(assignable: true)
  int id;
  String name;

  Category({this.id = 0, required this.name});
}
