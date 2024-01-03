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

  void createEditingWorkoutTemplateCopy(WorkoutTemplate workoutTemplate) {
    workoutTemplateBox
        .query(WorkoutTemplate_.isCurrentEditing.equals(true))
        .build()
        .remove();
    final newWorkoutTemplate = WorkoutTemplate(
      title: workoutTemplate.title,
      note: workoutTemplate.note,
      createdAt: DateTime.now(),
      isCurrentEditing: true,
    );
    workoutTemplate.exercisesSetsInfo.forEach((exercisesSetsInfo) {
      final newExercisesSetsInfo = ExercisesSetsInfo();
      newExercisesSetsInfo.exercise.target = exercisesSetsInfo.exercise.target;
      exercisesSetsInfo.exerciseSets.forEach((exerciseSet) {
        final newExerciseSet = ExerciseSet();
        newExerciseSet.reps = exerciseSet.reps;
        newExerciseSet.weight = exerciseSet.weight;
        newExerciseSet.exerciseSetInfo.target = newExercisesSetsInfo;
        newExercisesSetsInfo.exerciseSets.add(newExerciseSet);
      });
      newWorkoutTemplate.exercisesSetsInfo.add(newExercisesSetsInfo);
    });
    workoutTemplateBox.put(newWorkoutTemplate);
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

  void updateEditingWorkoutTemplateTitle(String title) {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    editingTemplate.title = title;
    workoutTemplateBox.put(editingTemplate);
  }

  void updateEditingWorkoutTemplateNote(String note) {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    editingTemplate.note = note;
    workoutTemplateBox.put(editingTemplate);
  }

  void deleteEditingWorkoutTemplate() {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
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
    workoutTemplateBox.put(editingTemplate);
  }

  WorkoutTemplate? getWorkoutTemplate(int workoutTemplateId) {
    return workoutTemplateBox.get(workoutTemplateId);
  }

  void deleteWorkoutTemplate(int workoutTemplateId) {
    WorkoutTemplate workoutTemplate = getWorkoutTemplate(workoutTemplateId)!;
    exerciseSetsBox.removeMany(workoutTemplate.exercisesSetsInfo
        .expand((element) => element.exerciseSets)
        .map((e) {
      return e.id;
    }).toList());
    exercisesSetsInfoBox.removeMany(workoutTemplate.exercisesSetsInfo.map((e) {
      return e.id;
    }).toList());
    workoutTemplateBox.remove(workoutTemplateId);
  }

  void updateTemplate(int workoutTemplateId) {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    WorkoutTemplate workoutTemplate = getWorkoutTemplate(workoutTemplateId)!;
    workoutTemplate.title = editingTemplate.title;
    workoutTemplate.note = editingTemplate.note;
    workoutTemplate.exercisesSetsInfo.forEach((exerciseSetsInfo) {
      exerciseSetsBox.removeMany(exerciseSetsInfo.exerciseSets.map((e) {
        return e.id;
      }).toList());
      exerciseSetsInfo.exerciseSets.clear();
    });
    workoutTemplate.exercisesSetsInfo.clear();
    exercisesSetsInfoBox.removeMany(workoutTemplate.exercisesSetsInfo.map((e) {
      return e.id;
    }).toList());
    editingTemplate.exercisesSetsInfo.forEach((exercisesSetsInfo) {
      final newExercisesSetsInfo = ExercisesSetsInfo();
      newExercisesSetsInfo.exercise.target = exercisesSetsInfo.exercise.target;
      exercisesSetsInfo.exerciseSets.forEach((exerciseSet) {
        final newExerciseSet = ExerciseSet();
        newExerciseSet.reps = exerciseSet.reps;
        newExerciseSet.weight = exerciseSet.weight;
        newExerciseSet.exerciseSetInfo.target = newExercisesSetsInfo;
        newExercisesSetsInfo.exerciseSets.add(newExerciseSet);
      });
      workoutTemplate.exercisesSetsInfo.add(newExercisesSetsInfo);
    });
    workoutTemplateBox.put(workoutTemplate);
    deleteEditingWorkoutTemplate();
  }

  bool editingWorkoutTemplateHasChanges(int workoutTemplateId) {
    WorkoutTemplate editingTemplate = getEditingWorkoutTemplate();
    WorkoutTemplate workoutTemplate = getWorkoutTemplate(workoutTemplateId)!;
    if (editingTemplate.title != workoutTemplate.title) {
      return true;
    }
    if (editingTemplate.note != workoutTemplate.note) {
      return true;
    }
    if (editingTemplate.exercisesSetsInfo.length !=
        workoutTemplate.exercisesSetsInfo.length) {
      return true;
    }
    for (int i = 0; i < editingTemplate.exercisesSetsInfo.length; i++) {
      if (editingTemplate.exercisesSetsInfo[i].exercise.target!.id !=
          workoutTemplate.exercisesSetsInfo[i].exercise.target!.id) {
        return true;
      }
      if (editingTemplate.exercisesSetsInfo[i].exerciseSets.length !=
          workoutTemplate.exercisesSetsInfo[i].exerciseSets.length) {
        return true;
      }
      for (int j = 0;
          j < editingTemplate.exercisesSetsInfo[i].exerciseSets.length;
          j++) {
        if (editingTemplate.exercisesSetsInfo[i].exerciseSets[j].reps !=
            workoutTemplate.exercisesSetsInfo[i].exerciseSets[j].reps) {
          return true;
        }
        if (editingTemplate.exercisesSetsInfo[i].exerciseSets[j].weight !=
            workoutTemplate.exercisesSetsInfo[i].exerciseSets[j].weight) {
          return true;
        }
      }
    }
    return false;
  }
}
