import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/exercise.dart';

class FirebaseExercisesService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> addExercise(Exercise exercise) async {
    final User user = auth.currentUser!;
    if (!user.isAnonymous) {
      final uid = user.uid;
      final collectionRef = db.collection('exercises');

      try {
        await collectionRef.doc(uid).set({
          'addednewExercises': FieldValue.arrayUnion(
            [
              {
                'id': exercise.id,
                'name': exercise.name,
                'categoryId': exercise.category.targetId,
                'bodyPartId': exercise.bodyPart.targetId,
              },
            ],
          ),
        }, SetOptions(merge: true));
      } catch (error) {
        rethrow;
      }
    }
  }

  static Future<void> updateExercise(Exercise exercise) async {
    final User user = auth.currentUser!;
    if (!user.isAnonymous) {
      final uid = user.uid;
      final collectionRef = db.collection('exercises');

      try {
        final docSnapshot = await collectionRef.doc(uid).get();
        final exercises = docSnapshot.data()?['addednewExercises'] ?? [];

        // Find the index of the exercise to update
        final index = exercises.indexWhere((ex) => ex['id'] == exercise.id);
        if (index != -1) {
          // Update the exercise details
          exercises[index]['name'] = exercise.name;
          exercises[index]['categoryId'] = exercise.category.targetId;
          exercises[index]['bodyPartId'] = exercise.bodyPart.targetId;

          // Rewrite the entire array with the updated exercise
          await collectionRef.doc(uid).update({'addednewExercises': exercises});
        } else {
          print('Exercise not found for update');
        }
      } catch (error) {
        print('Error updating exercise in Firestore: $error');
        throw error;
      }
    }
  }


  static Future<List<dynamic>> getAllCustomExercises() async {
    final User user = auth.currentUser!;
    if (!user.isAnonymous) {
      final uid = user.uid;
      final collectionRef = db.collection('exercises');

      final allCustomExercises = await collectionRef
          .doc(uid)
          .get()
          .then((value) => value.data()!['addednewExercises']);
      return allCustomExercises ?? [];
    }
    return [];
  }

// TODO: add delete exercise method
}
