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
          print('Exercise $exerciseName already exists. Skipping...');
          continue;
        }

        final newCustomExercise = Exercise(
          name: exerciseName,
        );

        final categoryId = exerciseData['categoryId'];
        final bodyPartId = exerciseData['bodyPartId'];
        final categoryName = exerciseData['categoryName'];
        final bodyPartName = exerciseData['bodyPartName'];

        print(
            'Category ID: $categoryId, CategoryName:$categoryName, Body Part ID: $bodyPartId, BP Name:$bodyPartName');

        // Fetch the category and body part directly from Firebase data
        final category =
        categoryId != null ? Category(id: categoryId, name: categoryName) : null;
        final bodyPart =
        bodyPartId != null ? BodyPart(id: bodyPartId, name: bodyPartName) : null;

        // Associate Category and BodyPart with the exercise
        newCustomExercise.category.target = category;
        newCustomExercise.bodyPart.target = bodyPart;

        // Add exercise to ObjectBox using addExerciseToList method
        addExerciseToList(newCustomExercise, category!, bodyPart!);

        // Update existingExerciseNames list
        existingExerciseNames.add(exerciseName);
      }

      print('Data population from Firebase successful.');
    } catch (error) {
      print('Error populating data from Firebase: $error');
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

  // void updateRecentWeightAndReps(int exerciseSetId, int recentWeight, int recentReps) {
  //   final exerciseSet = exerciseSetBox.get(exerciseSetId);
  //   if (exerciseSet != null) {
  //     exerciseSet.recentWeight = recentWeight;
  //     exerciseSet.recentReps = recentReps;
  //     exerciseSetBox.put(exerciseSet);
  //   } else {
  //     throw Exception('Exercise set with ID $exerciseSetId not found.');
  //   }
  //   }
  ////////////
  // void updateRecentWeightAndReps(int exerciseId, int? recentWeight, int? recentReps) {
  //   final exercise = exerciseBox.get(exerciseId);
  //   if (exercise != null) {
  //     exercise.recentWeight = recentWeight;
  //     exercise.recentReps = recentReps;
  //     exerciseBox.put(exercise);
  //   } else {
  //     throw Exception('update/ Exercise with ID $exerciseId not found.');
  //   }
  // }

  // ExerciseService
  void updateRecentWeightAndReps(String exerciseName, int recentWeight, int recentReps) {
    final exercises = exerciseBox.getAll();
    final exercise = exercises.firstWhere((exercise) =>
    exercise.name == exerciseName);
    if (exercise != null) {
      exercise.recentWeight = recentWeight;
      exercise.recentReps = recentReps;
      exerciseBox.put(exercise);
    } else {
      throw Exception('Exercise with name $exerciseName not found.');
    }
  }

    // Future<ExerciseSet?> getExerciseSetForExercise(int exerciseId) async {
    //   try {
    //     // Fetch all ExerciseSet entities from box
    //     final exerciseSets = exerciseSetBox.getAll();
    //
    //     // Find ExerciseSet with the given exerciseId
    //     final exerciseSet = exerciseSets.firstWhere(
    //           (exerciseSet) => exerciseSet.id == exerciseId, // Adjust the condition as needed
    //
    //     );
    //
    //     return exerciseSet;
    //   } catch (error) {
    //     print('Error fetching ExerciseSet: $error');
    //     return null;
    //   }
    // }

    int? getRecentWeight(String exerciseName) {
      try {
        final exerciseQuery = exerciseBox.query(
            Exercise_.name.equals(exerciseName)).build();
        final exercise = exerciseQuery.findFirst();
        if (exercise != null) {
          return exercise.recentWeight;
        }
      } catch (error) {
        print('Error fetching recent weight for exercise: $error');
      }
      return null;
    }

    int? getRecentReps(String exerciseName) {
      try {
        final exerciseQuery = exerciseBox.query(
            Exercise_.name.equals(exerciseName)).build();
        final exercise = exerciseQuery.findFirst();
        if (exercise != null) {
          return exercise.recentReps;
        }
      } catch (error) {
        print('Error fetching recent reps for exercise: $error');
      }
      return null;
    }
}


