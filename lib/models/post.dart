import 'package:objectbox/objectbox.dart';

@Entity()
class Post {
  @Id()
  int id;
  final int workoutSessionId;
  final String caption;
  final String firstImageUrl;
  final String secondImageUrl;
  final DateTime date;

  Post({
    this.id = 0,
    required this.workoutSessionId,
    required this.caption,
    required this.firstImageUrl,
    required this.secondImageUrl,
    required this.date,
  });
}
