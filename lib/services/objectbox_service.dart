import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:group_project/objectbox.g.dart';
import 'package:group_project/services/currentWorkoutSession/currentWorkoutSession_service.dart';
import 'package:group_project/services/exercise/exercise_service.dart';
import 'package:group_project/services/post/post_service.dart';
import 'package:group_project/services/workoutSession/workout_session_service.dart';
import 'package:group_project/services/workoutTemplate/workout_template_service.dart';
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
  late final Box<WorkoutTemplate> _workoutTemplateBox;
  late final Box<Post> _postBox;

  ObjectBox._create(this.store) {
    _bodyPartBox = Box<BodyPart>(store);
    _exerciseBox = Box<Exercise>(store);
    _categoryBox = Box<Category>(store);
    _currentWorkoutSessionBox = Box<CurrentWorkoutSession>(store);
    _exerciseSetBox = Box<ExerciseSet>(store);
    _exercisesSetsInfoBox = Box<ExercisesSetsInfo>(store);
    _workoutSessionBox = Box<WorkoutSession>(store);
    _workoutTemplateBox = Box<WorkoutTemplate>(store);
    _postBox = Box<Post>(store);

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

  CurrentWorkoutSessionService get currentWorkoutSessionService =>
      CurrentWorkoutSessionService(
        currentWorkoutSessionBox: _currentWorkoutSessionBox,
        workoutSessionBox: _workoutSessionBox,
        exercisesSetsInfoBox: _exercisesSetsInfoBox,
        exerciseSetBox: _exerciseSetBox,
        exerciseBox: _exerciseBox,
      );

  WorkoutSessionService get workoutSessionService => WorkoutSessionService(
        workoutSessionBox: _workoutSessionBox,
        exercisesSetsInfoBox: _exercisesSetsInfoBox,
        exerciseSetBox: _exerciseSetBox,
        exerciseBox: _exerciseBox,
        postBox: _postBox,
      );

  WorkoutTemplateService get workoutTemplateService => WorkoutTemplateService(
        workoutTemplateBox: _workoutTemplateBox,
        exerciseBox: _exerciseBox,
        exerciseSetsBox: _exerciseSetBox,
        exercisesSetsInfoBox: _exercisesSetsInfoBox,
      );

  ExerciseService get exerciseService => ExerciseService(
        exerciseBox: _exerciseBox,
        categoryBox: _categoryBox,
        bodyPartBox: _bodyPartBox,
        exerciseSetBox: _exerciseSetBox,
        exercisesSetsInfoBox: _exercisesSetsInfoBox,
      );

  PostService get postService => PostService(
        postBox: _postBox,
      );

  void clearAll() async {
    _bodyPartBox.removeAll();
    _exerciseBox.removeAll();
    _categoryBox.removeAll();
    _currentWorkoutSessionBox.removeAll();
    _exerciseSetBox.removeAll();
    _exercisesSetsInfoBox.removeAll();
    _workoutSessionBox.removeAll();
    _workoutTemplateBox.removeAll();
    _postBox.removeAll();
  }

  void initializeObjectBoxUponLogin() {
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
}
