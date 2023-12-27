import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:group_project/objectbox.g.dart';

class WorkoutTemplateService {
  Box<WorkoutTemplate> workoutTemplateBox;
  Box<Exercise> exerciseBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;
  Box<ExerciseSet> exerciseSetsBox;

  WorkoutTemplateService({
    required this.workoutTemplateBox,
    required this.exerciseBox,
    required this.exercisesSetsInfoBox,
    required this.exerciseSetsBox,
  });

  Stream<List<WorkoutTemplate>> watchWorkoutTemplates() {
    return workoutTemplateBox
        .query(
          WorkoutTemplate_.isCurrentEditing.equals(false),
        )
        .order(WorkoutTemplate_.createdAt, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void createWorkoutTemplate(WorkoutTemplate workoutTemplate) {
    workoutTemplateBox.put(workoutTemplate);
  }

  // for editing workout template
  WorkoutTemplate getEditingWorkoutTemplate() {
    WorkoutTemplate? editingTemplate = workoutTemplateBox
        .query(
          WorkoutTemplate_.isCurrentEditing.equals(true),
        )
        .build()
        .findFirst();
    if (editingTemplate == null) {
      workoutTemplateBox.put(
          WorkoutTemplate(isCurrentEditing: true, createdAt: DateTime.now()));
      return workoutTemplateBox
          .query(
            WorkoutTemplate_.isCurrentEditing.equals(true),
          )
          .build()
          .findFirst()!;
    } else {
      return editingTemplate;
    }
  }

  void deleteEditingWorkoutTemplate() {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    // remove the exercisesSetsInfo
    exerciseSetsBox.removeMany(editingTemplate.exercisesSetsInfo
        .expand((element) => element.exerciseSets)
        .map((e) {
      return e.id;
    }).toList());
    exercisesSetsInfoBox.removeMany(editingTemplate.exercisesSetsInfo.map((e) {
      return e.id;
    }).toList());
    workoutTemplateBox.remove(editingTemplate.id);
  }

  void test() {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    print(editingTemplate.exercisesSetsInfo[0].exerciseSets[0].reps);
  }

  void addExerciseToEditingWorkoutTemplate(Exercise selectedExercise) {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    ExercisesSetsInfo exercisesSetsInfo = ExercisesSetsInfo();
    editingTemplate.exercisesSetsInfo.add(exercisesSetsInfo);
    exercisesSetsInfo.exercise.target = selectedExercise;
    ExerciseSet exerciseSet = ExerciseSet();
    exerciseSet.exerciseSetInfo.target = exercisesSetsInfo;
    exercisesSetsInfo.exerciseSets.add(exerciseSet);
    exerciseBox.put(selectedExercise);
    exercisesSetsInfoBox.put(exercisesSetsInfo);
    workoutTemplateBox.put(editingTemplate);
  }

  void saveEditingWorkoutTemplate() {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    editingTemplate.isCurrentEditing = false;
    if (editingTemplate.exercisesSetsInfo.isEmpty) {
      throw Exception("Please add at least one exercise");
    }
    editingTemplate.exercisesSetsInfo.forEach((exerciseSetsInfoElement) {
      exerciseSetsInfoElement.exerciseSets.forEach((exerciseSet) {
        if (exerciseSet.reps == null || exerciseSet.weight == null) {
          throw Exception("Please fill in all the reps and weight");
        } else {
          workoutTemplateBox.put(editingTemplate);
        }
      });
    });
  }
}
