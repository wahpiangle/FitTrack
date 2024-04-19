import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/objectbox.g.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';

class WorkoutSessionService {
  Box<WorkoutSession> workoutSessionBox;
  Box<ExercisesSetsInfo> exercisesSetsInfoBox;
  Box<ExerciseSet> exerciseSetBox;
  Box<Exercise> exerciseBox;
  Box<Post> postBox;

  WorkoutSessionService({
    required this.workoutSessionBox,
    required this.exercisesSetsInfoBox,
    required this.exerciseSetBox,
    required this.exerciseBox,
    required this.postBox,
  });

  Stream<List<WorkoutSession>> watchWorkoutSession() {
    return workoutSessionBox
        .query(
          WorkoutSession_.isCurrentEditing.equals(false),
        )
        .order(WorkoutSession_.date, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  WorkoutSession? getWorkoutSession(int workoutSessionId) {
    return workoutSessionBox.get(workoutSessionId);
  }

  List<WorkoutSession> getAllWorkoutSessions() {
    return workoutSessionBox.getAll();
  }

  void removeWorkoutSession(int workoutSessionId) {
    WorkoutSession workoutSession = getWorkoutSession(workoutSessionId)!;
    for (var exercisesSetsInfo in workoutSession.exercisesSetsInfo) {
      for (var exerciseSet in exercisesSetsInfo.exerciseSets) {
        exerciseSetBox.remove(exerciseSet.id);
      }
      exercisesSetsInfoBox.remove(exercisesSetsInfo.id);
    }
    workoutSessionBox.remove(workoutSessionId);
  }

  WorkoutSession? getEditingWorkoutSession() {
    return workoutSessionBox
        .query(
          WorkoutSession_.isCurrentEditing.equals(true),
        )
        .build()
        .findFirst();
  }

  void createEditingWorkoutSessionCopy(WorkoutSession workoutSession) {
    final newWorkoutSession = WorkoutSession(
      date: workoutSession.date,
      note: workoutSession.note,
      title: workoutSession.title,
      isCurrentEditing: true,
    );
    for (var exercisesSetsInfo in workoutSession.exercisesSetsInfo) {
      final newExercisesSetsInfo = ExercisesSetsInfo();
      newExercisesSetsInfo.exercise.target = exercisesSetsInfo.exercise.target;
      for (var exerciseSet in exercisesSetsInfo.exerciseSets) {
        final newExerciseSet = ExerciseSet();
        newExerciseSet.reps = exerciseSet.reps;
        newExerciseSet.weight = exerciseSet.weight;
        // newExerciseSet.time = exerciseSet.time;
        newExerciseSet.duration = exerciseSet.duration;
        newExerciseSet.exerciseSetInfo.target = newExercisesSetsInfo;
        newExercisesSetsInfo.exerciseSets.add(newExerciseSet);
      }
      newWorkoutSession.exercisesSetsInfo.add(newExercisesSetsInfo);
    }
    workoutSessionBox.put(newWorkoutSession);
  }

  void addExerciseToEditingWorkoutSession(Exercise selectedExercise) {
    WorkoutSession editingWorkoutSession = getEditingWorkoutSession()!;
    ExercisesSetsInfo exercisesSetsInfo = ExercisesSetsInfo();
    editingWorkoutSession.exercisesSetsInfo.add(exercisesSetsInfo);
    exercisesSetsInfo.exercise.target = selectedExercise;
    ExerciseSet exerciseSet = ExerciseSet();
    exerciseSet.exerciseSetInfo.target = exercisesSetsInfo;
    exercisesSetsInfo.exerciseSets.add(exerciseSet);
    exerciseBox.put(selectedExercise);
    exercisesSetsInfoBox.put(exercisesSetsInfo);
    workoutSessionBox.put(editingWorkoutSession);
  }

  void deleteEditingWorkoutSession() {
    WorkoutSession? editingWorkoutSession = getEditingWorkoutSession();
    if (editingWorkoutSession == null) {
      return;
    }
    exerciseSetBox.removeMany(editingWorkoutSession.exercisesSetsInfo
        .expand((element) => element.exerciseSets)
        .map((e) {
      return e.id;
    }).toList());
    exercisesSetsInfoBox
        .removeMany(editingWorkoutSession.exercisesSetsInfo.map((e) {
      return e.id;
    }).toList());
    workoutSessionBox.remove(editingWorkoutSession.id);
  }

  bool editingWorkoutSessionHasChanges(int workoutSessionId) {
    WorkoutSession editingWorkoutSession = getEditingWorkoutSession()!;
    WorkoutSession workoutSession = getWorkoutSession(workoutSessionId)!;
    if (editingWorkoutSession.date != workoutSession.date) {
      return true;
    }
    if (editingWorkoutSession.note != workoutSession.note) {
      return true;
    }
    if (editingWorkoutSession.exercisesSetsInfo.length !=
        workoutSession.exercisesSetsInfo.length) {
      return true;
    }
    for (int i = 0; i < editingWorkoutSession.exercisesSetsInfo.length; i++) {
      if (editingWorkoutSession.exercisesSetsInfo[i].exercise.target!.id !=
          workoutSession.exercisesSetsInfo[i].exercise.target!.id) {
        return true;
      }
      if (editingWorkoutSession.exercisesSetsInfo[i].exerciseSets.length !=
          workoutSession.exercisesSetsInfo[i].exerciseSets.length) {
        return true;
      }
      for (int j = 0;
          j < editingWorkoutSession.exercisesSetsInfo[i].exerciseSets.length;
          j++) {
        if (editingWorkoutSession.exercisesSetsInfo[i].exerciseSets[j].reps !=
            workoutSession.exercisesSetsInfo[i].exerciseSets[j].reps) {
          return true;
        }
        if (editingWorkoutSession.exercisesSetsInfo[i].exerciseSets[j].weight !=
            workoutSession.exercisesSetsInfo[i].exerciseSets[j].weight) {
          return true;
        }
        // if (editingWorkoutSession.exercisesSetsInfo[i].exerciseSets[j].time !=
        //     workoutSession.exercisesSetsInfo[i].exerciseSets[j].time) {
        //   return true;
        // }
        if (editingWorkoutSession.exercisesSetsInfo[i].exerciseSets[j].duration !=
            workoutSession.exercisesSetsInfo[i].exerciseSets[j].duration) {
          return true;
        }
      }
    }
    return false;
  }

  void updateSession(int workoutSessionId) {
    WorkoutSession editingWorkoutSession = getEditingWorkoutSession()!;
    WorkoutSession workoutSession = getWorkoutSession(workoutSessionId)!;
    workoutSession.date = editingWorkoutSession.date;
    workoutSession.note = editingWorkoutSession.note;
    for (var exercisesSetsInfo in workoutSession.exercisesSetsInfo) {
      exerciseSetBox.removeMany(exercisesSetsInfo.exerciseSets.map((e) {
        return e.id;
      }).toList());
      exercisesSetsInfo.exerciseSets.clear();
    }
    exercisesSetsInfoBox.removeMany(workoutSession.exercisesSetsInfo.map((e) {
      return e.id;
    }).toList());
    for (var exercisesSetsInfo in editingWorkoutSession.exercisesSetsInfo) {
      final newExercisesSetsInfo = ExercisesSetsInfo();
      newExercisesSetsInfo.exercise.target = exercisesSetsInfo.exercise.target;
      for (var exerciseSet in exercisesSetsInfo.exerciseSets) {
        final newExerciseSet = ExerciseSet();
        newExerciseSet.reps = exerciseSet.reps;
        newExerciseSet.weight = exerciseSet.weight;
        // newExerciseSet.time = exerciseSet.time;
        newExerciseSet.duration = exerciseSet.duration;
        newExerciseSet.exerciseSetInfo.target = newExercisesSetsInfo;
        newExercisesSetsInfo.exerciseSets.add(newExerciseSet);
      }
      workoutSession.exercisesSetsInfo.add(newExercisesSetsInfo);
    }

    workoutSessionBox.put(workoutSession);

    // set personal records for sets
    workoutSession.exercisesSetsInfo.forEach((exerciseSetInfo) {
      exerciseSetInfo.exerciseSets.forEach((exerciseSet) {
        if (objectBox.exerciseService.isPersonalRecord(exerciseSet)) {
          exerciseSet.isPersonalRecord = true;
          objectBox.exerciseService
              .setOtherSetsAsNotPersonalRecord(exerciseSet);
          exerciseSetBox.put(exerciseSet);
        }
      });
    });
    deleteEditingWorkoutSession();
  }

  void updateEditingWorkoutSessionTitle(int workoutSessionId, String value) {
    WorkoutSession editingWorkoutSession = getEditingWorkoutSession()!;
    editingWorkoutSession.title = value;
    workoutSessionBox.put(editingWorkoutSession);
  }

  void updateEditingWorkoutSessionNote(int workoutSessionId, String value) {
    WorkoutSession editingWorkoutSession = getEditingWorkoutSession()!;
    editingWorkoutSession.note = value;
    workoutSessionBox.put(editingWorkoutSession);
  }

  Future<void> populateDataFromFirebase() async {
    if (workoutSessionBox.isEmpty()) {
      final List<dynamic> workoutSessions =
          await FirebaseWorkoutsService.getWorkoutSessionsOfUser();
      for (var workoutSession in workoutSessions) {
        final newWorkoutSession = WorkoutSession(
          id: int.parse(workoutSession['id']),
          date: workoutSession['date'].toDate(),
          note: workoutSession['note'],
          title: workoutSession['title'],
          duration: workoutSession['duration'],
          postId: workoutSession['post'],
          isCurrentEditing: false,
        );

        for (var exercisesSetsInfo in workoutSession['exercisesSetsInfo']) {
          final newExercisesSetsInfo = ExercisesSetsInfo();
          final Exercise? exercise = exerciseBox.get(
            (exercisesSetsInfo['exercise']),
          );
          exercise?.exercisesSetsInfo.add(newExercisesSetsInfo);
          newExercisesSetsInfo.exercise.target = exercise;
          for (var exerciseSet in exercisesSetsInfo['exerciseSets']) {
            final newExerciseSet = ExerciseSet();
            newExerciseSet.reps = exerciseSet['reps'];
            newExerciseSet.weight = exerciseSet['weight'];
            // newExerciseSet.time = exerciseSet['time'];
            newExerciseSet.duration = exerciseSet['duration'];
            newExerciseSet.isPersonalRecord =
                exerciseSet['isPersonalRecord'] ?? false;
            newExerciseSet.exerciseSetInfo.target = newExercisesSetsInfo;
            newExercisesSetsInfo.exerciseSets.add(newExerciseSet);
          }
          exerciseBox.put(exercise!);
          newWorkoutSession.exercisesSetsInfo.add(newExercisesSetsInfo);
        }

        workoutSessionBox.put(newWorkoutSession);
      }
    }
  }

  void attachPostToWorkoutSession(int workoutSessionId, String postId) {
    WorkoutSession workoutSession = getWorkoutSession(workoutSessionId)!;
    workoutSession.postId = postId;
    workoutSessionBox.put(workoutSession);
  }

  bool checkWorkoutSessionTemplateChanges(WorkoutSession workoutSession) {
    if (workoutSession.workoutTemplate.hasValue) {
      final workoutTemplate = workoutSession.workoutTemplate.target!;
      if (workoutTemplate.title != workoutSession.title) {
        return true;
      }
      if (workoutTemplate.note != workoutSession.note) {
        return true;
      }
      if (workoutTemplate.exercisesSetsInfo.length !=
          workoutSession.exercisesSetsInfo.length) {
        return true;
      }
      for (int i = 0; i < workoutTemplate.exercisesSetsInfo.length; i++) {
        if (workoutTemplate.exercisesSetsInfo[i].exercise.target!.id !=
            workoutSession.exercisesSetsInfo[i].exercise.target!.id) {
          return true;
        }
        if (workoutTemplate.exercisesSetsInfo[i].exerciseSets.length !=
            workoutSession.exercisesSetsInfo[i].exerciseSets.length) {
          return true;
        }
        for (int j = 0;
            j < workoutTemplate.exercisesSetsInfo[i].exerciseSets.length;
            j++) {
          if (workoutTemplate.exercisesSetsInfo[i].exerciseSets[j].reps !=
              workoutSession.exercisesSetsInfo[i].exerciseSets[j].reps) {
            return true;
          }
          if (workoutTemplate.exercisesSetsInfo[i].exerciseSets[j].weight !=
              workoutSession.exercisesSetsInfo[i].exerciseSets[j].weight) {
            return true;
          }
          // if (workoutTemplate.exercisesSetsInfo[i].exerciseSets[j].time !=
          //     workoutSession.exercisesSetsInfo[i].exerciseSets[j].time) {
          //   return true;
          // }
          if (workoutTemplate.exercisesSetsInfo[i].exerciseSets[j].duration !=
              workoutSession.exercisesSetsInfo[i].exerciseSets[j].duration) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
