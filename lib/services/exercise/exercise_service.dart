import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

class ExerciseService {
  Box<Exercise> exerciseBox;
  Box<Category> categoryBox;
  Box<BodyPart> bodyPartBox;
  Box<ExerciseSet> exerciseSetBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;

  ExerciseService({
    required this.exerciseBox,
    required this.categoryBox,
    required this.bodyPartBox,
    required this.exerciseSetBox,
    required this.exercisesSetsInfoBox,
  });

  //exercises
  Stream<List<Exercise>> watchAllExercise() {
    return exerciseBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void addExercises() {
    exerciseBox.putMany(generateExerciseData());
  }

  List<Exercise> getAllExercises() {
    return exerciseBox.getAll();
  }

  void removeExercises() {
    exerciseBox.removeAll();
  }

//custom exercise
  void addExerciseToList(
      Exercise exercise, Category category, BodyPart bodyPart) {
    exercise.category.target = category;
    exercise.bodyPart.target = bodyPart;
    exerciseBox.put(exercise);
  }

//categories & bodyParts
  List<Category> getCategories() {
    return categoryBox.getAll();
  }

  void addSetToExercise(ExercisesSetsInfo exercisesSetsInfo) {
    ExerciseSet exerciseSet = ExerciseSet();
    exerciseSet.exerciseSetInfo.target = exercisesSetsInfo;
    exercisesSetsInfo.exerciseSets.add(exerciseSet);
    exercisesSetsInfoBox.put(exercisesSetsInfo);
  }

  void removeSetFromExercise(int setId) {
    ExerciseSet exerciseSet = exerciseSetBox.get(setId)!;
    ExercisesSetsInfo? exerciseSetInfo = exerciseSet.exerciseSetInfo.target;
    if (exerciseSetInfo?.exerciseSets.length == 1) {
      exercisesSetsInfoBox.remove(exerciseSetInfo!.id);
    }
    exerciseSetBox.remove(setId);
  }

  void completeExerciseSet(int exerciseSetId) {
    ExerciseSet exerciseSet = exerciseSetBox.get(exerciseSetId)!;
    if (exerciseSet.reps == null || exerciseSet.weight == null) {
      return;
    }
    exerciseSet.isCompleted = !exerciseSet.isCompleted;
    exerciseSetBox.put(exerciseSet);
  }

  void updateExerciseSet(ExerciseSet exerciseSet) {
    exerciseSetBox.put(exerciseSet);
  }

  void deselectExercise(Exercise exercise) {
    exercise.isSelected = false;
    exerciseBox.put(exercise);
  }
}
