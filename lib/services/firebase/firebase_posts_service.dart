import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/post.dart';

class FirebasePostsService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static createPost(Post post) async {
    final User user = auth.currentUser!;
    if (!user.isAnonymous) {
      final uid = user.uid;
      final collectionRef = db.collection('posts');
      await collectionRef.doc(uid).set({
        'posts': FieldValue.arrayUnion(
          [
            {
              'id': post.id,
              'date': DateTime.now(),
              'workoutSessionId': post.workoutSessionId,
            }
          ],
        )
      }, SetOptions(merge: true));
    }
  }
}
