import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/models/post.dart';

class FirebasePostsService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final postsCollectionRef = db.collection('posts');

  static Future<String> uploadImage(
      XFile? firstImage, XFile? secondImage, int workoutSessionId) async {
    final User user = auth.currentUser!;
    if (firstImage != null && secondImage == null) {
      final uploadFirstImageTask = await storage
          .ref('images/${user.uid}/firstImage/$workoutSessionId.jpg')
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
          .ref('images/${user.uid}/secondImage/$workoutSessionId.jpg')
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

  static Future<bool> createPost(Post post) async {
    final User user = auth.currentUser!;
    try {
      final String firstImageUrl = await uploadImage(XFile(post.firstImageUrl),
          XFile(post.secondImageUrl), post.workoutSessionId);
      final String secondImageUrl = await uploadImage(
          XFile(post.secondImageUrl),
          XFile(post.firstImageUrl),
          post.workoutSessionId);
      await postsCollectionRef.doc(user.uid).collection('userPosts').add({
        'caption': '',
        'firstImageUrl': firstImageUrl,
        'secondImageUrl': secondImageUrl,
        'workoutSessionId': post.workoutSessionId,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
