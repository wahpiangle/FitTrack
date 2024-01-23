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
        print('About to add exercise to Firestore');
        await collectionRef.doc(uid).set({
          'addednewExercises': FieldValue.arrayUnion(
            [
              {
                'id': exercise.id,
                'name': exercise.name,
                'categoryId': exercise.category.targetId,
                'bodyPartId': exercise.bodyPart.targetId,
                // Add other exercise properties
              },
            ],
          ),
        }, SetOptions(merge: true));

        print('Exercise added to Firestore successfully!');
      } catch (error) {
        print('Error adding exercise to Firestore: $error');
      }
    }
  }

}
