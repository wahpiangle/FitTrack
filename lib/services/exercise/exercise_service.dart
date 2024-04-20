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

  ExerciseService(
      {required this.exerciseBox,
      required this.categoryBox,
      required this.bodyPartBox,
      required this.exerciseSetBox,
      required this.exercisesSetsInfoBox,
      required this.workoutSessionBox});

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

      final List<String> existingExerciseNames = getExistingExerciseNames();

      for (var exerciseData in addednewExercises) {
        final exerciseName = exerciseData['name'];

        if (existingExerciseNames.contains(exerciseName)) {
          continue;
        }

        final newCustomExercise = Exercise(
          id: exerciseData['id'],
          name: exerciseName,
          isCustom: true,
          isVisible: exerciseData['isVisible'] ?? true,
        );

        final categoryId = exerciseData['categoryId'];
        final bodyPartId = exerciseData['bodyPartId'];
        final categoryName = exerciseData['categoryName'];
        final bodyPartName = exerciseData['bodyPartName'];

        final category = categoryId != null
            ? Category(id: categoryId, name: categoryName)
            : null;
        final bodyPart = bodyPartId != null
            ? BodyPart(id: bodyPartId, name: bodyPartName ?? 'Chest')
            : BodyPart(id: bodyPartId, name: 'Chest');

        newCustomExercise.category.target = category;
        newCustomExercise.bodyPart.target = bodyPart;

        addExerciseToList(newCustomExercise, category!, bodyPart);
      }
    } catch (error) {
      print(error);
    }
  }

  List<String> getExistingExerciseNames() {
    final List<Exercise> existingExercises = exerciseBox.getAll();

    final List<String> existingExerciseNames =
        existingExercises.map((exercise) => exercise.name).toList();

    return existingExerciseNames;
  }

  Exercise? getExerciseById(int id) {
    return exerciseBox.get(id);
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
    ExercisesSetsInfo? exercisesSetsInfo = exerciseSet.exerciseSetInfo.target;
    if (exercisesSetsInfo?.exercise.target?.category.target?.name == "Reps Only") {
      if (exerciseSet.reps == null) {
        return;
      }
    }
    else if (exercisesSetsInfo?.exercise.target?.category.target?.name == "Duration") {
      String timeString = exerciseSet.time.toString();
      if (exerciseSet.time == null) {
        return;
      }
      else if (exerciseSet.time.toString().length == 3 && ['6', '7', '8', '9'].contains(timeString[1])) {
        return;
      }
      else if (exerciseSet.time.toString().length == 4  ) {

        if (['6', '7', '8', '9'].contains(timeString[0])) {

          return;
        }
        else if (['6', '7', '8', '9'].contains(timeString[2])) {
          return;
        }
      }
      else if (exerciseSet.time.toString().length == 5  ) {
        if (['6', '7', '8', '9'].contains(timeString[1])) {
          return;
        }
        else if (['6', '7', '8', '9'].contains(timeString[3])) {
          return;
        }
      }
    }

    else if (exerciseSet.reps == null || exerciseSet.weight == null) {
      return;
    }
    exerciseSet.isCompleted = !exerciseSet.isCompleted;
    if (isPersonalRecord(exerciseSet) == true) {
      exerciseSet.isPersonalRecord = true;
      setOtherSetsAsNotPersonalRecord(exerciseSet);
    }

    exerciseSetBox.put(exerciseSet);
  }

  void setOtherSetsAsNotPersonalRecord(ExerciseSet exerciseSet) {
    ExercisesSetsInfo exercisesSetsInfo = exerciseSet.exerciseSetInfo.target!;
    List<ExerciseSet> exerciseSets = exercisesSetsInfo.exerciseSets;
    for (ExerciseSet set in exerciseSets) {
      if (set.id != exerciseSet.id) {
        set.isPersonalRecord = false;
        exerciseSetBox.put(set);
      }
    }
  }

  void updateExerciseSet(ExerciseSet exerciseSet) {
    exerciseSetBox.put(exerciseSet);
  }

  void deselectExercise(Exercise exercise) {
    exercise.isSelected = false;
    exerciseBox.put(exercise);
  }

  int getOneRepMaxValue(int weight, int reps, ExerciseSet exerciseSet) {
    final category = exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;

    if (category != "Reps Only" && category != "Duration") {
      return (weight * (1 + reps / 30)).toInt();
    } else {
      return 0; // Return some default value if category is not "Dumbbell"
    }
  }


  bool isPersonalRecord(ExerciseSet exerciseSet) {
    final category = exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;
    if (category == "Duration") {
      // If the category is "Duration", we'll determine personal records based on time
      ExercisesSetsInfo exercisesSetsInfo = exerciseSet.exerciseSetInfo.target!;
      Exercise exercise = exercisesSetsInfo.exercise.target!;
      List<ExerciseSet> exerciseSets = exercise.exercisesSetsInfo
          .expand((element) => element.exerciseSets)
          .toList();

      // Get the current duration value for the exercise set
      int currentTime = exerciseSet.time ?? 0;

      // Check if the current duration is the best among all other sets
      for (ExerciseSet set in exerciseSets) {
        if (set.id != exerciseSet.id) {
          int otherTime = set.time ?? 0;
          if (otherTime > currentTime) {
            // If any other set has a higher duration, it's not a personal record
            return false;
          }
        }
      }
      // If no other set has a higher duration, it's a personal record
      return true;
    }
    else if (category == "Reps Only") {
      // If the category is "Reps Only", we'll determine personal records based on reps
      ExercisesSetsInfo exercisesSetsInfo = exerciseSet.exerciseSetInfo.target!;
      Exercise exercise = exercisesSetsInfo.exercise.target!;
      List<ExerciseSet> exerciseSets = exercise.exercisesSetsInfo
          .expand((element) => element.exerciseSets)
          .toList();
      // Get the current reps value for the exercise set
      int currentReps = exerciseSet.reps ?? 0;
      // Check if the current reps is the best among all other sets
      for (ExerciseSet set in exerciseSets) {
        if (set.id != exerciseSet.id) {
          int otherReps = set.reps ?? 0;
          if (otherReps > currentReps) {
            // If any other set has a higher reps, it's not a personal record
            return false;
          }
        }
      }
      // If no other set has a higher reps, it's a personal record
      return true;
    } else if (category != "Reps Only" && category != "Duration") {
      // For categories other than "Reps Only" and "Duration", check one-rep max
      ExercisesSetsInfo exercisesSetsInfo = exerciseSet.exerciseSetInfo.target!;
      Exercise exercise = exercisesSetsInfo.exercise.target!;
      List<ExerciseSet> exerciseSets = exercise.exercisesSetsInfo
          .expand((element) => element.exerciseSets)
          .toList();
      int currentOneRepMax =
      getOneRepMaxValue(exerciseSet.weight ?? 0, exerciseSet.reps ?? 0, exerciseSet);
      for (ExerciseSet set in exerciseSets) {
        if (set.id != exerciseSet.id) {
          int oneRepMax = getOneRepMaxValue(set.weight ?? 0, set.reps ?? 0, set);
          if (oneRepMax > currentOneRepMax) {
            return false;
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }




  ExerciseSet getBestSet(WorkoutSession workoutSession) {
    List<ExerciseSet> allSets = [];
    for (var exerciseSetInfo in workoutSession.exercisesSetsInfo) {
      allSets.addAll(exerciseSetInfo.exerciseSets);
    }
    List<ExerciseSet> dumbbellSets = allSets.where((exerciseSet) =>
    exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name != "Reps Only" &&
        exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name != "Duration"
    ).toList();
    if (dumbbellSets.isNotEmpty) {
      dumbbellSets.sort((a, b) => getOneRepMaxValue(b.weight!, b.reps!, b)
          .compareTo(getOneRepMaxValue(a.weight!, a.reps!, a)));
      return dumbbellSets.first;
    } else {
      return ExerciseSet(); // Return some default value if no "Dumbbell" sets found
    }
  }

  int getDurationMaxValue(int timeInSeconds, ExerciseSet exerciseSet) {
    final category = exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;

    if (category == "Duration") {
      // If the category is "Duration", simply return the timeInSeconds
      return timeInSeconds;
    } else {
      return 0; // Return some default value if the category is not "Duration"
    }
  }

  ExerciseSet getBestDurationSet(WorkoutSession workoutSession) {
    List<ExerciseSet> allSets = [];
    for (var exerciseSetInfo in workoutSession.exercisesSetsInfo) {
      allSets.addAll(exerciseSetInfo.exerciseSets);
    }
    List<ExerciseSet> durationSets = allSets.where((exerciseSet) =>
    exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == "Duration"
    ).toList();
    if (durationSets.isNotEmpty) {
      // There are "Duration" sets available
      durationSets.sort((a, b) => getDurationMaxValue(b.time!, b)
          .compareTo(getDurationMaxValue(a.time!, a)));
      return durationSets.first;
    } else {
      return ExerciseSet(); // Return some default value if no "Duration" sets found
    }
  }

  int getOneRepMaxValueRepsOnly(int reps, ExerciseSet exerciseSet) {
    final category = exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;

    if (category == "Reps Only") {
      // If the category is "Duration", simply return the timeInSeconds
      return reps;
    } else {
      return 0; // Return some default value if the category is not "Duration"
    }
  }

  ExerciseSet getBestSetRepsOnly(WorkoutSession workoutSession) {
    List<ExerciseSet> allSets = [];
    for (var exerciseSetInfo in workoutSession.exercisesSetsInfo) {
      allSets.addAll(exerciseSetInfo.exerciseSets);
    }
    List<ExerciseSet> repsOnlySets = allSets.where((exerciseSet) =>
    exerciseSet.exerciseSetInfo.target?.exercise.target?.category.target?.name == "Reps Only"
    ).toList();
    if (repsOnlySets.isNotEmpty) {
      repsOnlySets.sort((a, b) => (b.reps ?? 0).compareTo(a.reps ?? 0));
      return repsOnlySets.first;
    } else {
      return ExerciseSet(); // Return some default value if no "Reps Only" sets found
    }
  }

  int? getRecentWeight(int exerciseId, int setIndex) {
    final allWorkoutSessions = workoutSessionBox.getAll();
    allWorkoutSessions.sort((a, b) => b.date.compareTo(a.date));
    final mostRecentWorkoutSession = allWorkoutSessions.firstOrNull;
    if (mostRecentWorkoutSession == null) {
      return null;
    }
    final exerciseSetsInfo = mostRecentWorkoutSession.exercisesSetsInfo;
    for (final exerciseSetInfo in exerciseSetsInfo) {
      final exercise = exerciseSetInfo.exercise.target;
      if (exercise != null && exercise.id == exerciseId) {
        int counter = 0;
        for (final exerciseSet in exerciseSetInfo.exerciseSets) {
          if (counter == setIndex) {
            final recentWeight = exerciseSet.weight;
            return recentWeight;
          }
          counter++;
        }
      }
    }
    return null;
  }

  int? getRecentReps(int exerciseId, int setIndex) {
    final allWorkoutSessions = workoutSessionBox.getAll();
    allWorkoutSessions.sort((a, b) => b.date.compareTo(a.date));
    final mostRecentWorkoutSession = allWorkoutSessions.firstOrNull;
    if (mostRecentWorkoutSession == null) {
      return null;
    }
    final exerciseSetsInfo = mostRecentWorkoutSession.exercisesSetsInfo;

    for (final exerciseSetInfo in exerciseSetsInfo) {
      final exercise = exerciseSetInfo.exercise.target;
      if (exercise != null && exercise.id == exerciseId) {
        int counter = 0;
        for (final exerciseSet in exerciseSetInfo.exerciseSets) {
          if (counter == setIndex) {
            final recentReps = exerciseSet.reps;
            return recentReps;
          }
          counter++;
        }
      }
    }
    return null;
  }

  int? getRecentTime(int exerciseId, int setIndex) {
    final allWorkoutSessions = workoutSessionBox.getAll();
    allWorkoutSessions.sort((a, b) => b.date.compareTo(a.date));
    final mostRecentWorkoutSession = allWorkoutSessions.firstOrNull;
    if (mostRecentWorkoutSession == null) {
      return null;
    }
    final exerciseSetsInfo = mostRecentWorkoutSession.exercisesSetsInfo;

    for (final exerciseSetInfo in exerciseSetsInfo) {
      final exercise = exerciseSetInfo.exercise.target;
      if (exercise != null && exercise.id == exerciseId) {
        int counter = 0;
        for (final exerciseSet in exerciseSetInfo.exerciseSets) {
          if (counter == setIndex) {
            final recentTime = exerciseSet.time;
            return recentTime;
          }
          counter++;
        }
      }
    }
    return null;
  }

  // String? getRecentDuration(int exerciseId, int setIndex) {
  //   final allWorkoutSessions = workoutSessionBox.getAll();
  //   allWorkoutSessions.sort((a, b) => b.date.compareTo(a.date));
  //   final mostRecentWorkoutSession = allWorkoutSessions.firstOrNull;
  //   if (mostRecentWorkoutSession == null) {
  //     return null;
  //   }
  //   final exerciseSetsInfo = mostRecentWorkoutSession.exercisesSetsInfo;
  //
  //   for (final exerciseSetInfo in exerciseSetsInfo) {
  //     final exercise = exerciseSetInfo.exercise.target;
  //     if (exercise != null && exercise.id == exerciseId) {
  //       int counter = 0;
  //       for (final exerciseSet in exerciseSetInfo.exerciseSets) {
  //         if (counter == setIndex) {
  //           final recentDuration = exerciseSet.duration;
  //           return recentDuration;
  //         }
  //         counter++;
  //       }
  //     }
  //   }
  //   return null;
  // }

}
