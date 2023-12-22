import 'package:group_project/models/workout_template.dart';
import 'package:group_project/objectbox.g.dart';

class WorkoutTemplateService {
  Box<WorkoutTemplate> workoutTemplateBox;

  WorkoutTemplateService({
    required this.workoutTemplateBox,
  });

  Stream<List<WorkoutTemplate>> watchWorkoutTemplates() {
    return workoutTemplateBox
        .query()
        .order(WorkoutTemplate_.createdAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void createWorkoutTemplate(WorkoutTemplate workoutTemplate) {
    workoutTemplateBox.put(workoutTemplate);
  }
}
