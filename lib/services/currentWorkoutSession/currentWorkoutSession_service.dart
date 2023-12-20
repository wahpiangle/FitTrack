import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:objectbox/objectbox.dart';

class CurrentWorkoutSessionService {
  Box<CurrentWorkoutSession> currentWorkoutSessionBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;
  Box<ExerciseSet> exerciseSetBox;
  Box<Exercise> exerciseBox;

  CurrentWorkoutSessionService({
    required this.currentWorkoutSessionBox,
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
    currentWorkoutSession.isActive = true;
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
}
