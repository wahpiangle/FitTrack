import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/exercise.dart';

class FirebaseExercisesService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static void addExercise(Exercise exercise) async {
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
        print('Error adding exercise to Firestore: $error');
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
      return allCustomExercises;
    }
    return [];
  }

  // TODO: add delete exercise method
}
