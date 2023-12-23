import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/workout_session.dart';

class FirebaseWorkoutsService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static void createWorkoutSession(WorkoutSession workoutSession) async {
    final User user = auth.currentUser!;
    final uid = user.uid;
    final collectionRef = db.collection('workouts');
    await collectionRef.doc(uid).set({
      'workoutSessions': FieldValue.arrayUnion(
        [
          {
            'id': workoutSession.id,
            'date': DateTime.now(),
            'title': workoutSession.title,
            'note': workoutSession.note,
            'exercisesSetsInfo': workoutSession.exercisesSetsInfo
                .map((exercisesSetsInfo) => {
                      'exercise': exercisesSetsInfo.exercise.targetId,
                      'exerciseSets': exercisesSetsInfo.exerciseSets
                          .map((exerciseSet) => {
                                'reps': exerciseSet.reps,
                                'weight': exerciseSet.weight,
                              })
                          .toList(),
                    })
                .toList(),
          }
        ],
      )
    }, SetOptions(merge: true));
  }

  static Future<void> deleteWorkoutSession(int workoutSessionId) async {
    final User user = auth.currentUser!;
    final uid = user.uid;
    final collectionRef = db.collection('workouts');
    final workoutSession = await collectionRef
        .doc(uid)
        .get()
        .then((value) => value.data()!['workoutSessions'])
        .then((value) => value
            .where((workoutSession) => workoutSession['id'] == workoutSessionId)
            .toList());
    await collectionRef.doc(uid).update({
      'workoutSessions': FieldValue.arrayRemove(workoutSession),
    });
  }
}
