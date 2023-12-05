import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/objectbox.g.dart';
import 'package:group_project/services/currentWorkoutSession/currentWorkoutSession_service.dart';
import 'package:group_project/services/workoutSession/workoutSessionService.dart';
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
  late final Box<WorkoutSession> _workoutSessionBox;

  ObjectBox._create(this.store) {
    _bodyPartBox = Box<BodyPart>(store);
    _exerciseBox = Box<Exercise>(store);
    _categoryBox = Box<Category>(store);
    _currentWorkoutSessionBox = Box<CurrentWorkoutSession>(store);
    _exerciseSetBox = Box<ExerciseSet>(store);
    _exercisesSetsInfoBox = Box<ExercisesSetsInfo>(store);
    _workoutSessionBox = Box<WorkoutSession>(store);

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

  //current workout session service
  CurrentWorkoutSessionService get currentWorkoutSessionService =>
      CurrentWorkoutSessionService(
        currentWorkoutSessionBox: _currentWorkoutSessionBox,
        exercisesSetsInfoBox: _exercisesSetsInfoBox,
        exerciseSetBox: _exerciseSetBox,
        exerciseBox: _exerciseBox,
      );

  WorkoutSessionService get workoutSessionService => WorkoutSessionService(
        workoutSessionBox: _workoutSessionBox,
        exercisesSetsInfoBox: _exercisesSetsInfoBox,
        exerciseSetBox: _exerciseSetBox,
      );

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

  void addSetToExercise(ExercisesSetsInfo exercisesSetsInfo) {
    exercisesSetsInfo.exerciseSets.add(ExerciseSet(reps: 0, weight: 0));
    _exercisesSetsInfoBox.put(exercisesSetsInfo);
  }

  void removeSetFromExercise(int setId) {
    _exerciseSetBox.remove(setId);
  }

  void completeExerciseSet(int exerciseSetId) {
    ExerciseSet exerciseSet = _exerciseSetBox.get(exerciseSetId)!;
    exerciseSet.isCompleted = !exerciseSet.isCompleted;
    _exerciseSetBox.put(exerciseSet);
  }

  void updateExerciseSet(ExerciseSet exerciseSet) {
    _exerciseSetBox.put(exerciseSet);
  }

  // save to history
  void saveCurrentWorkoutSession() {
    CurrentWorkoutSession currentWorkoutSession =
        currentWorkoutSessionService.getCurrentWorkoutSession();
    WorkoutSession workoutSession = WorkoutSession(date: DateTime.now());
    workoutSession.exercisesSetsInfo
        .addAll(currentWorkoutSession.exercisesSetsInfo);
    workoutSession.note = currentWorkoutSession.note;
    workoutSession.title = currentWorkoutSession.title;
    _workoutSessionBox.put(workoutSession);
    currentWorkoutSessionService.clearCurrentWorkoutSession();
  }

// check history
  void test() {
    // _exercisesSetsInfoBox.removeAll();
    // _workoutSessionBox.removeAll();
  }
}
