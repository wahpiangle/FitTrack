import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/objectbox.g.dart';
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
    exercise.isCustom = true;
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

      // Retrieve existing exercise names from ObjectBox or another storage solution
      final List<String> existingExerciseNames = getExistingExerciseNames();

      // Proceed with data population from Firebase
      for (var exerciseData in addednewExercises) {
        final exerciseName = exerciseData['name'];

        // Check if exercise name already exists, if so, skip
        if (existingExerciseNames.contains(exerciseName)) {
          continue;
        }

        final newCustomExercise = Exercise(
          name: exerciseName,
          isCustom: true,
        );

        final categoryId = exerciseData['categoryId'];
        final bodyPartId = exerciseData['bodyPartId'];
        final categoryName = exerciseData['categoryName'];
        final bodyPartName = exerciseData['bodyPartName'];


        // Fetch the category and body part directly from Firebase data
        final category =
        categoryId != null ? Category(id: categoryId, name: categoryName) : null;
        final bodyPart = bodyPartId != null
            ? BodyPart(id: bodyPartId, name: bodyPartName ?? 'Chest')
            : BodyPart(id: bodyPartId, name:'Chest'); // Assign default body part name

        // Associate Category and BodyPart with the exercise
        newCustomExercise.category.target = category;
        newCustomExercise.bodyPart.target = bodyPart;

        // Add exercise to ObjectBox using addExerciseToList method
        addExerciseToList(newCustomExercise, category!, bodyPart);

        // Update existingExerciseNames list
        existingExerciseNames.add(exerciseName);
      }

    } catch (error) {
      // Handle the error further based on your application's requirements.
    }
  }



  List<String> getExistingExerciseNames() {
    // Retrieve existing exercises from ObjectBox
    final List<Exercise> existingExercises = exerciseBox.getAll();

    // Extract exercise names from existing exercises
    final List<String> existingExerciseNames =
    existingExercises.map((exercise) => exercise.name).toList();

    return existingExerciseNames;
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



  // ExerciseService
//   void updateRecentWeightAndReps(int exerciseId, int recentWeight, int recentReps, int setIndex) {
//     final exercises = exerciseBox.getAll();
//     final exerciseSets = exerciseSetBox.getAll();
// print('hey');
//     final exercise = exercises.firstWhere((exercise) => exercise.id == exerciseId);
//     final exerciseSet = exerciseSets.firstWhere((exerciseSet) =>
//     exerciseSet.exercise.target?.id == exercise.id && exerciseSet.setNumber == setIndex);
//
//     print('name we are matching: ${exercise.id}');
//     print('set number we are matching: ${exerciseSet.setNumber}');
//
//     if (exerciseSet != null) {
//       exerciseSet.recentWeight = recentWeight;
//       exerciseSet.recentReps = recentReps;
//       exerciseSetBox.put(exerciseSet);
//     } else {
//       throw Exception('ExerciseSet with name $exerciseId and setIndex $setIndex not found.');
//     }
//   }

  void updateRecentWeightAndRepsForSet1(int exerciseId, int recentWeight, int recentReps, int setIndex) {
    // Retrieve the ExercisesSetsInfo object for the given exerciseId
    final exercisesSetsInfo = exercisesSetsInfoBox.query().equal(ExercisesSetsInfo_.exerciseId, exerciseId).build().findFirst();

    // Check if the ExercisesSetsInfo object exists
    if (exercisesSetsInfo != null) {
      // Retrieve the ExerciseSet object with setIndex = 1
      final exerciseSet = exercisesSetsInfo.exerciseSets.firstWhere((set) => set.setIndex == setIndex, orElse: () => null);

      // Check if the ExerciseSet object exists
      if (exerciseSet != null) {
        // Update the recentWeight and recentReps properties
        exerciseSet.recentWeight = recentWeight;
        exerciseSet.recentReps = recentReps;

        // Save the updated ExerciseSet object back to the database
        exerciseSetBox.put(exerciseSet);
      } else {
        print('ExerciseSet with setIndex $setIndex not found for exerciseId: $exerciseId');
      }
    } else {
      print('ExercisesSetsInfo not found for exerciseId: $exerciseId');
    }
  }



  int? getRecentWeight(String exerciseName, int setIndex) {
    final exercises = exerciseBox.getAll();
    final exerciseSets = exerciseSetBox.getAll();

    final exercise = exercises.firstWhere((exercise) => exercise.name == exerciseName);
    final exerciseSet = exerciseSets.firstWhere((exerciseSet) =>
    exerciseSet.exercise.target?.name == exercise.name && exerciseSet.setIndex == setIndex);

    if (exerciseSet != null) {
      final recentWeight = exerciseSet.recentWeight;
      return recentWeight;
    } else {
      throw Exception('Exercise with name $exerciseName not found.');
    }
  }

  int? getRecentReps(String exerciseName, int setIndex) {
    final exercises = exerciseBox.getAll();
    final exerciseSets = exerciseSetBox.getAll();

    final exercise = exercises.firstWhere((exercise) => exercise.name == exerciseName);
    final exerciseSet = exerciseSets.firstWhere((exerciseSet) =>
    exerciseSet.exercise.target?.name == exercise.name && exerciseSet.setIndex == setIndex);

    if (exerciseSet != null) {
      final recentReps = exerciseSet.recentReps;
      return recentReps;
    } else {
      throw Exception('Exercise with name $exerciseName not found.');
    }
  }

}


