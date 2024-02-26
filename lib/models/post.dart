import 'package:group_project/models/workout_session.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Post {
  @Id()
  int id;
  final String caption;
  final String firstImageUrl;
  final String secondImageUrl;
  final DateTime? date;

  final workoutSession = ToOne<WorkoutSession>();

  Post({
    this.id = 0,
    required this.caption,
    required this.firstImageUrl,
    required this.secondImageUrl,
    required this.date,
  });
}
