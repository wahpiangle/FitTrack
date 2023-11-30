import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/objectbox.g.dart';

class WorkoutSessionService {
  Box<WorkoutSession> workoutSessionBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;
  Box<ExerciseSet> exerciseSetBox;

  WorkoutSessionService({
    required this.workoutSessionBox,
    required this.exercisesSetsInfoBox,
    required this.exerciseSetBox,
  });

  Stream<List<WorkoutSession>> watchWorkoutSession() {
    return workoutSessionBox
        .query()
        // order by date in descending order
        .order(WorkoutSession_.date, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void removeWorkoutSession(int workoutSessionId) {
    workoutSessionBox.remove(workoutSessionId);
  }

  // void createCurrentWorkoutSession() {
  //   if (currentWorkoutSessionBox.isEmpty()) {
  //     currentWorkoutSessionBox.put(CurrentWorkoutSession());
  //   }
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
  //   currentWorkoutSession.isActive = true;
  //   currentWorkoutSessionBox.put(currentWorkoutSession);
  // }

  // CurrentWorkoutSession getCurrentWorkoutSession() {
  //   return currentWorkoutSessionBox.getAll().first;
  // }

  // void addExerciseToCurrentWorkoutSession(Exercise exercise) {
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
  //   final exercisesSetInfo = ExercisesSetsInfo();
  //   exercisesSetInfo.exercise.target = exercise;
  //   exercisesSetInfo.exerciseSets.add(ExerciseSet(reps: 0, weight: 0));
  //   currentWorkoutSession.exercisesSetsInfo.add(exercisesSetInfo);
  //   exercisesSetsInfoBox.put(exercisesSetInfo);
  //   currentWorkoutSessionBox.put(currentWorkoutSession);
  // }

  // void removeExerciseFromCurrentWorkoutSession(int exercisesSetsInfoId) {
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
  //   currentWorkoutSession.exercisesSetsInfo.removeWhere(
  //       (exercisesSetsInfo) => exercisesSetsInfo.id == exercisesSetsInfoId);
  //   currentWorkoutSessionBox.put(currentWorkoutSession);
  // }

  // // for cancel workout
  // void cancelWorkout() {
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();

  //   for (var exercisesSetsInfo in currentWorkoutSession.exercisesSetsInfo) {
  //     exercisesSetsInfo.exerciseSets.toList().forEach((exerciseSet) {
  //       exerciseSetBox.remove(exerciseSet.id);
  //     });
  //   }

  //   currentWorkoutSession.exercisesSetsInfo
  //       .toList()
  //       .forEach((exercisesSetsInfo) {
  //     exercisesSetsInfoBox.remove(exercisesSetsInfo.id);
  //   });
  //   currentWorkoutSessionBox.put(currentWorkoutSession);
  // }

  // void updateCurrentWorkoutSessionNote(String newText) {
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
  //   currentWorkoutSession.note = newText;
  //   currentWorkoutSessionBox.put(currentWorkoutSession);
  // }

  // String getCurrentWorkoutSessionNote() {
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
  //   return currentWorkoutSession.note;
  // }

  // void clearCurrentWorkoutSession() {
  //   CurrentWorkoutSession currentWorkoutSession = getCurrentWorkoutSession();
  //   currentWorkoutSession.exercisesSetsInfo.clear();
  //   currentWorkoutSessionBox.put(currentWorkoutSession);
  // }
}
