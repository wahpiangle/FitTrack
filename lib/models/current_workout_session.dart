import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CurrentWorkoutSession {
  @Id()
  int id;
  String title;
  String note;
  int startTime;

  // 1 current workout session can have multiple exercises
  // each exercise can have multiple sets
  final exercisesSetsInfo = ToMany<ExercisesSetsInfo>();

  // TODO: add timer

  CurrentWorkoutSession({
    this.id = 0,
    this.title = 'Workout',
    this.note = '',
    this.startTime = 0,
  });

  void startTimer() {
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  // Get the duration of the workout session in seconds
  int get duration {
    if (startTime == 0) {
      return 0; // Workout session hasn't started yet
    }
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    return ((currentTime - startTime) / 1000).floor();
  }

  set duration(int newDuration) {

    startTime = DateTime.now().millisecondsSinceEpoch - (newDuration * 1000);
  }
}
