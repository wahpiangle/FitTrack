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
    if (exerciseSet.reps == null || exerciseSet.weight == null) {
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

  int getOneRepMaxValue(int weight, int reps) {
    return (weight * (1 + reps / 30)).toInt();
  }

  bool isPersonalRecord(ExerciseSet exerciseSet) {
    ExercisesSetsInfo exercisesSetsInfo = exerciseSet.exerciseSetInfo.target!;
    Exercise exercise = exercisesSetsInfo.exercise.target!;
    List<ExerciseSet> exerciseSets = exercise.exercisesSetsInfo
        .expand((element) => element.exerciseSets)
        .toList();
    int currentOneRepMax =
        getOneRepMaxValue(exerciseSet.weight ?? 0, exerciseSet.reps ?? 0);
    for (ExerciseSet set in exerciseSets) {
      if (set.id != exerciseSet.id) {
        int oneRepMax = getOneRepMaxValue(set.weight ?? 0, set.reps ?? 0);
        if (oneRepMax > currentOneRepMax) {
          return false;
        }
      }
    }
    return true;
  }

  ExerciseSet getBestSet(WorkoutSession workoutSession) {
    List<ExerciseSet> allSets = [];
    for (var exerciseSetInfo in workoutSession.exercisesSetsInfo) {
      allSets.addAll(exerciseSetInfo.exerciseSets);
    }
    allSets.sort((a, b) => getOneRepMaxValue(b.weight!, b.reps!)
        .compareTo(getOneRepMaxValue(a.weight!, a.reps!)));
    return allSets.first;
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

  List<Exercise> getRecentExercises(int count) {
    final recentSessions = workoutSessionBox.query()
        .order(WorkoutSession_.date, flags: Order.descending)
        .build()
        .find();

    final recentExercises = <Exercise>{};

    for (var session in recentSessions) {
      for (var setInfo in session.exercisesSetsInfo) {
        if (recentExercises.length < count) {
          recentExercises.add(setInfo.exercise.target!);
        }
      }
      if (recentExercises.length >= count) break;
    }

    return recentExercises.toList();
  }

}
