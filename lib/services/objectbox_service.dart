import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:group_project/constants/data/bodypart_data.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  late final Box<BodyPart> _bodyPartBox;
  late final Box<Exercise> _exerciseBox;
  late final Box<Category> _categoryBox;
  late final Box<CurrentWorkoutSession> _currentWorkoutSessionBox;
  late final Box<ExerciseSet> _exerciseSetBox;
  late final Box<ExercisesSetsInfo> _exercisesSetsInfoBox;

  ObjectBox._create(this.store) {
    _bodyPartBox = Box<BodyPart>(store);
    _exerciseBox = Box<Exercise>(store);
    _categoryBox = Box<Category>(store);
    _currentWorkoutSessionBox = Box<CurrentWorkoutSession>(store);
    _exerciseSetBox = Box<ExerciseSet>(store);
    _exercisesSetsInfoBox = Box<ExercisesSetsInfo>(store);

    //initialization of data into the device
    if (_bodyPartBox.isEmpty()) {
      _bodyPartBox.putMany(bodyPartData);
    }
    if (_exerciseBox.isEmpty()) {
      _exerciseBox.putMany(generateExerciseData());
    }
    if (_categoryBox.isEmpty()) {
      _categoryBox.putMany(categoryData);
    }
    if (_currentWorkoutSessionBox.isEmpty()) {
      _currentWorkoutSessionBox.put(CurrentWorkoutSession());
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }

//exercises
  Stream<List<Exercise>> watchAllExercise() {
    return _exerciseBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void addExercises() {
    _exerciseBox.putMany(generateExerciseData());
  }

  List<Exercise> getAllExercises() {
    return _exerciseBox.getAll();
  }

  void removeExercises() {
    _exerciseBox.removeAll();
  }

//categories & bodyParts
  List<Category> getCategories() {
    return _categoryBox.getAll();
  }

//workout session
  void createWorkoutSession() {
    if (_currentWorkoutSessionBox.isEmpty()) {
      _currentWorkoutSessionBox.put(CurrentWorkoutSession());
    }
  }

  Stream<CurrentWorkoutSession> watchCurrentWorkoutSession() {
    return _currentWorkoutSessionBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find().first);
  }

  CurrentWorkoutSession getCurrentWorkoutSession() {
    return _currentWorkoutSessionBox.getAll().first;
  }

  void addExerciseToCurrentWorkoutSession(Exercise exercise) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    final exercisesSetInfo = ExercisesSetsInfo();
    exercisesSetInfo.exercise.target = exercise;

    // TODO: Change this to only 1 set
    exercisesSetInfo.exerciseSets.add(ExerciseSet(reps: 1, weight: 1));
    exercisesSetInfo.exerciseSets.add(ExerciseSet(reps: 2, weight: 2));
    currentWorkoutSession.exercisesSetsInfo.add(exercisesSetInfo);
    _exercisesSetsInfoBox.put(exercisesSetInfo);
    _currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  void removeExerciseFromCurrentWorkoutSession(Exercise selectedExercise) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.exercisesSetsInfo
        .toList()
        .forEach((exercisesSetsInfo) {
      if (exercisesSetsInfo.exercise.target!.id == selectedExercise.id) {
        currentWorkoutSession.exercisesSetsInfo.remove(exercisesSetsInfo);
      }
    });
    _currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  void addSetToExercise(ExercisesSetsInfo exercisesSetsInfo) {
    exercisesSetsInfo.exerciseSets.add(ExerciseSet(reps: 1, weight: 1));
    _exercisesSetsInfoBox.put(exercisesSetsInfo);
  }

  void clearCurrentWorkoutSession() {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();

    // delete all exercise sets of the current workout session
    for (var exercisesSetsInfo in currentWorkoutSession.exercisesSetsInfo) {
      exercisesSetsInfo.exerciseSets.toList().forEach((exerciseSet) {
        _exerciseSetBox.remove(exerciseSet.id);
      });
    }

    // delete all exercise set info of the current workout session
    currentWorkoutSession.exercisesSetsInfo
        .toList()
        .forEach((exercisesSetsInfo) {
      _exercisesSetsInfoBox.remove(exercisesSetsInfo.id);
    });
    _currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  void removeSetFromExercise(int setId) {
    _exerciseSetBox.remove(setId);
  }

  void test() {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    for (ExercisesSetsInfo exercisesSetsInfo
        in currentWorkoutSession.exercisesSetsInfo) {
      print(exercisesSetsInfo.exercise.target!.name);
      print(exercisesSetsInfo.exerciseSets.length);
    }
  }

  void updateCurrentWorkoutSessionNote(String newText) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.note = newText;
    _currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  String getCurrentWorkoutSessionNote() {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    return currentWorkoutSession.note;
  }

  void completeExerciseSet(int exerciseSetId) {
    ExerciseSet exerciseSet = _exerciseSetBox.get(exerciseSetId)!;
    exerciseSet.isCompleted = !exerciseSet.isCompleted;
    _exerciseSetBox.put(exerciseSet);
  }
}
