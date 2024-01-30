import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/models/workout_session.dart';

class FirebasePostsService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final postsCollectionRef = db.collection('posts');

  static uploadImage(XFile firstImage, XFile secondImage,
      WorkoutSession workoutSession) async {
    final User user = auth.currentUser!;
    try {
      await storage
          .ref('images/${user.uid}/firstImage/${workoutSession.id}.jpg')
          .putFile(File(firstImage.path));
      await storage
          .ref('images/${user.uid}/secondImage/${workoutSession.id}.jpg')
          .putFile(File(secondImage.path));
    } catch (e) {
      print(e);
    }
  }

  // static createPost(Post post) async {
  //   final User user = auth.currentUser!;
  //   if (!user.isAnonymous) {
  //     final uid = user.uid;
  //     await postsCollectionRef.add({
  //       'uid': uid,
  //       'caption': post.caption,
  //       'workoutSession':
  //           db.doc('workotus/$uid/workoutSessions/${post.workoutSessionId}'),
  //       'createdAt': DateTime.now(),
  //     });
  //   }
  // }
}
