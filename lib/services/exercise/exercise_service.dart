import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/objectbox.g.dart';
import 'package:group_project/services/firebase/firebase_customexercise_service.dart';

class ExerciseService {
  Box<Exercise> exerciseBox;
  Box<Category> categoryBox;
  Box<BodyPart> bodyPartBox;
  Box<ExerciseSet> exerciseSetBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;
  Box<WorkoutSession> workoutSessionBox;

  ExerciseService({
    required this.exerciseBox,
    required this.categoryBox,
    required this.bodyPartBox,
    required this.exerciseSetBox,
    required this.exercisesSetsInfoBox,
    required this.workoutSessionBox
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
    return exerciseBox
        .getAll()
        .where((exercise) => exercise.isVisible)
        .toList();
  }

  void removeExercises() {
    exerciseBox.removeAll();
  }

//custom exercise
  void addExerciseToList(
      Exercise exercise, Category category, BodyPart bodyPart) {
    exercise.isCustom = true;
    exercise.category.target = category;
    exercise.bodyPart.target = bodyPart;
    exerciseBox.put(exercise);
  }

  void updateExerciseInList(
      Exercise exercise, String newName, Category category, BodyPart bodyPart) {
    exercise.name = newName;
    exercise.category.target = category;
    exercise.bodyPart.target = bodyPart;
    exerciseBox.put(exercise);
  }

  void updateExerciselist(Exercise exercise) {
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
        final category = categoryId != null
            ? Category(id: categoryId, name: categoryName)
            : null;
        final bodyPart = bodyPartId != null
            ? BodyPart(id: bodyPartId, name: bodyPartName ?? 'Chest')
            : BodyPart(
                id: bodyPartId, name: 'Chest'); // Assign default body part name

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



  void updateRecentWeightAndReps(ExerciseSet exerciseSet, int recentWeight, int recentReps) {
    exerciseSet.recentWeight = recentWeight;
    exerciseSet.recentReps = recentReps;
    exerciseSetBox.put(exerciseSet);
  }

  int? getRecentWeight(int exerciseId, int setIndex) {
    print('fetching');
    final allWorkoutSessions = workoutSessionBox.getAll();
    allWorkoutSessions.sort((a, b) => b.date.compareTo(a.date));
    final mostRecentWorkoutSession = allWorkoutSessions.first;
    final exerciseSetsInfo = mostRecentWorkoutSession.exercisesSetsInfo;
    for (final exerciseSetInfo in exerciseSetsInfo) {
      final exercise = exerciseSetInfo.exercise.target;
      if (exercise != null && exercise.id == exerciseId) {
        int counter = 0;
        for (final exerciseSet in exerciseSetInfo.exerciseSets) {
          if (counter == setIndex) {
            final recentWeight = exerciseSet.recentWeight;
            print("in exercise service recent weight is $recentWeight");
            return recentWeight;
          }
          counter++;
        }
      }
    }
    print('No match found for exerciseId: $exerciseId and setIndex: $setIndex');
  }



  int? getRecentReps(int exerciseId, int setIndex) {
    print('fetching');
    final allWorkoutSessions = workoutSessionBox.getAll();
    allWorkoutSessions.sort((a, b) => b.date.compareTo(a.date));
    final mostRecentWorkoutSession = allWorkoutSessions.first;
    final exerciseSetsInfo = mostRecentWorkoutSession.exercisesSetsInfo;

    for (final exerciseSetInfo in exerciseSetsInfo) {
      final exercise = exerciseSetInfo.exercise.target;
      if (exercise != null && exercise.id == exerciseId) {
        int counter = 0;
        for (final exerciseSet in exerciseSetInfo.exerciseSets) {
          if (counter == setIndex) {
            final recentReps = exerciseSet.recentReps;
            print("in exercise service recent reps is $recentReps");
            return recentReps;
          }
          counter++;
        }
      }
    }
    print('No match found for exerciseId: $exerciseId and setIndex: $setIndex');
  }
}
