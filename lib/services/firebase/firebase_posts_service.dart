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

  static Future<String> uploadImage(XFile? firstImage, XFile? secondImage,
      WorkoutSession workoutSession) async {
    final User user = auth.currentUser!;
    if (firstImage != null && secondImage == null) {
      final uploadFirstImageTask = await storage
          .ref('images/${user.uid}/firstImage/${workoutSession.id}.jpg')
          .putFile(File(firstImage.path));
      if (uploadFirstImageTask.state == TaskState.success) {
        final String firstImageUrl =
            await uploadFirstImageTask.ref.getDownloadURL();
        return firstImageUrl;
      } else {
        throw Exception('First image upload failed');
      }
    } else if (firstImage == null && secondImage != null) {
      final uploadSecondImageTask = await storage
          .ref('images/${user.uid}/secondImage/${workoutSession.id}.jpg')
          .putFile(File(secondImage.path));
      if (uploadSecondImageTask.state == TaskState.success) {
        final String secondImageUrl =
            await uploadSecondImageTask.ref.getDownloadURL();
        return secondImageUrl;
      } else {
        throw Exception('Second image upload failed');
      }
    }
    throw Exception('Image upload failed');
  }

  static Future<bool> createPost(XFile firstImage, XFile secondImage,
      WorkoutSession workoutSession) async {
    final User user = auth.currentUser!;
    try {
      final String firstImageUrl =
          await uploadImage(firstImage, secondImage, workoutSession);
      final String secondImageUrl =
          await uploadImage(firstImage, secondImage, workoutSession);
      await postsCollectionRef.doc(user.uid).collection('userPosts').add({
        'caption': '',
        'firstImageUrl': firstImageUrl,
        'secondImageUrl': secondImageUrl,
        'workoutSessionId': workoutSession.id,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
