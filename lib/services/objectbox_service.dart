import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
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

  ObjectBox._create(this.store) {
    _bodyPartBox = Box<BodyPart>(store);
    _exerciseBox = Box<Exercise>(store);
    _categoryBox = Box<Category>(store);
    _currentWorkoutSessionBox = Box<CurrentWorkoutSession>(store);

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
    //! There should only be one current workout session at all times
    if (!_currentWorkoutSessionBox.isEmpty()) {
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
  CurrentWorkoutSession getCurrentWorkoutSession() {
    return _currentWorkoutSessionBox.getAll().first;
  }

  void addExerciseToCurrentWorkoutSession(Exercise exercise) {
    final currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.exercises!.add({
      exercise: [
        ExerciseSet(
          reps: 0,
          weight: 0,
        )
      ]
    });
  }

  void removeCurrentWorkoutSession() {
    _currentWorkoutSessionBox.removeAll();
  }
}
