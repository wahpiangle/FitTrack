import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/services/firebase/firebase_customexercise_service.dart';
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
    // Filter out exercises based on visibility
    return exerciseBox.getAll().where((exercise) => exercise.isVisible).toList();
  }

  void removeExercises() {
    exerciseBox.removeAll();
  }

//custom exercise
  void addExerciseToList(Exercise exercise, Category category, BodyPart bodyPart) {
    exercise.category.target = category;
    exercise.bodyPart.target = bodyPart;
    exerciseBox.put(exercise);
  }

  void updateExerciseInList(Exercise exercise, String newName, Category category, BodyPart bodyPart) {
    exercise.name = newName;
    exercise.category.target = category;
    exercise.bodyPart.target = bodyPart;
    exerciseBox.put(exercise);
  }

  void updateExerciselist( Exercise exercise){

    exerciseBox.put(exercise);

  }

//categories & bodyParts
  List<Category> getCategories() {
    return categoryBox.getAll();
  }

  Future<void> populateDataFromFirebase() async {
    try {
      final List<dynamic> addednewExercises =
      await FirebaseExercisesService.getAllCustomExercises();

      // Proceed with data population from Firebase
      for (var exerciseData in addednewExercises) {
        final newCustomExercise = Exercise(
          name: exerciseData['name'],
        );

        final categoryId = exerciseData['categoryId'];
        final bodyPartId = exerciseData['bodyPartId'];
        final categoryName =exerciseData['categoryName'];
        final bodyPartName =exerciseData['bodyPartName'];

        print('Category ID: $categoryId, CategoryName:$categoryName, Body Part ID: $bodyPartId, BP Name:$bodyPartName');

        // Fetch the category and body part directly from Firebase data
        final category = categoryId != null ? Category(id: categoryId, name: categoryName) : null;
        final bodyPart = bodyPartId != null ? BodyPart(id: bodyPartId, name: bodyPartName) : null;

        // Associate Category and BodyPart with the exercise
        newCustomExercise.category.target = category;
        newCustomExercise.bodyPart.target = bodyPart;

        // Add exercise to ObjectBox using addExerciseToList method
        addExerciseToList(newCustomExercise, category!, bodyPart!);
      }

      print('Data population from Firebase successful.');
    } catch (error) {
      print('Error populating data from Firebase: $error');
      // Handle the error further based on your application's requirements.
    }
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
