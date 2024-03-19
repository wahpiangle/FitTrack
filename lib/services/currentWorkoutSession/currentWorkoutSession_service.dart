import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:objectbox/objectbox.dart';

class CurrentWorkoutSessionService {
  Box<CurrentWorkoutSession> currentWorkoutSessionBox;
  Box<WorkoutSession> workoutSessionBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;
  Box<ExerciseSet> exerciseSetBox;
  Box<Exercise> exerciseBox;

  CurrentWorkoutSessionService({
    required this.currentWorkoutSessionBox,
    required this.workoutSessionBox,
    required this.exercisesSetsInfoBox,
    required this.exerciseSetBox,
    required this.exerciseBox,
  });

  Stream<CurrentWorkoutSession> watchCurrentWorkoutSession() {
    return currentWorkoutSessionBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find().first);
  }

  void createCurrentWorkoutSession() {
    if (currentWorkoutSessionBox.isEmpty()) {
      currentWorkoutSessionBox.put(CurrentWorkoutSession());
    }
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.workoutTemplate.target = null;
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  CurrentWorkoutSession getCurrentWorkoutSession() {
    return currentWorkoutSessionBox.getAll().first;
  }

  void addExerciseToCurrentWorkoutSession(Exercise exercise) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    final exercisesSetInfo = ExercisesSetsInfo();
    exercise.exercisesSetsInfo.add(exercisesSetInfo);
    exercisesSetInfo.exercise.target = exercise;
    ExerciseSet exerciseSet = ExerciseSet();
    exerciseSet.exerciseSetInfo.target = exercisesSetInfo;
    exercisesSetInfo.exerciseSets.add(exerciseSet);
    currentWorkoutSession.exercisesSetsInfo.add(exercisesSetInfo);
    exerciseBox.put(exercise);
    exercisesSetsInfoBox.put(exercisesSetInfo);
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  void removeExerciseFromCurrentWorkoutSession(int exercisesSetsInfoId) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.exercisesSetsInfo.removeWhere(
        (exercisesSetsInfo) => exercisesSetsInfo.id == exercisesSetsInfoId);
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  // for cancel workout
  void cancelWorkout() {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();

    for (var exercisesSetsInfo in currentWorkoutSession.exercisesSetsInfo) {
      exercisesSetsInfo.exerciseSets.toList().forEach((exerciseSet) {
        exerciseSetBox.remove(exerciseSet.id);
      });
    }

    currentWorkoutSession.exercisesSetsInfo
        .toList()
        .forEach((exercisesSetsInfo) {
      exercisesSetsInfoBox.remove(exercisesSetsInfo.id);
    });

    currentWorkoutSession.note = '';
    currentWorkoutSession.title = 'Workout';
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  void updateCurrentWorkoutSessionNote(String newText) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.note = newText;
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  String getCurrentWorkoutSessionNote() {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    return currentWorkoutSession.note;
  }

  void clearCurrentWorkoutSession() {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.title = 'Workout';
    currentWorkoutSession.note = '';
    currentWorkoutSession.exercisesSetsInfo.clear();
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  String getCurrentWorkoutSessionTitle() {
    return getCurrentWorkoutSession().title;
  }

  void updateCurrentWorkoutSessionTitle(String newText) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.title = newText;
    currentWorkoutSessionBox.put(currentWorkoutSession);
  }

  // save to history
  WorkoutSession saveCurrentWorkoutSession({required int timeInSeconds}) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();

    WorkoutSession workoutSession = WorkoutSession(
      date: DateTime.now(),
      duration: timeInSeconds,
    );
    workoutSession.exercisesSetsInfo
        .addAll(currentWorkoutSession.exercisesSetsInfo);
    workoutSession.note = currentWorkoutSession.note;
    workoutSession.title = currentWorkoutSession.title;
    workoutSession.workoutTemplate.targetId =
        currentWorkoutSession.workoutTemplate.targetId;
    workoutSessionBox.put(workoutSession);
    clearCurrentWorkoutSession();
    return workoutSession;
  }

  void startCurrentWorkoutFromTemplate(WorkoutTemplate workoutTemplate) {
    CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
    currentWorkoutSession.title = workoutTemplate.title;
    currentWorkoutSession.note = workoutTemplate.note;
    currentWorkoutSession.workoutTemplate.targetId = workoutTemplate.id;

    // create copy of exercisesSetsInfo from workoutTemplate and add to workoutTemplate
    workoutTemplate.exercisesSetsInfo.forEach((exercisesSetsInfo) {
      final exercisesSetsInfoCopy = ExercisesSetsInfo();
      exercisesSetsInfo.exerciseSets.forEach((exerciseSet) {
        final exerciseSetCopy = ExerciseSet();
        exercisesSetsInfoCopy.exerciseSets.add(exerciseSetCopy);
        exerciseSetCopy.exerciseSetInfo.target = exercisesSetsInfoCopy;
        exerciseSetCopy.reps = exerciseSet.reps;
        exerciseSetCopy.weight = exerciseSet.weight;
        exerciseSetBox.put(exerciseSetCopy);
      });
      exercisesSetsInfoCopy.exercise.target = exercisesSetsInfo.exercise.target;
      currentWorkoutSession.exercisesSetsInfo.add(exercisesSetsInfoCopy);
      exercisesSetsInfoBox.put(exercisesSetsInfoCopy);
    });

    currentWorkoutSessionBox.put(currentWorkoutSession);
  }
}
