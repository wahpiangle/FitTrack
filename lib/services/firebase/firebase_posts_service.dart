import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';

class FirebasePostsService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final postsCollectionRef = db.collection('posts');

  static Future<bool> createPost(
      Post post, UploadImageProvider uploadImageProvider) async {
    final User user = auth.currentUser!;
    uploadImageProvider.setIsUploading(true);
    Reference firstRef = storage.ref(
        'images/${user.uid}/firstImage/${post.workoutSession.targetId}.jpg');
    Reference secondRef = storage.ref(
        'images/${user.uid}/secondImage/${post.workoutSession.targetId}.jpg');
    uploadImageProvider.setUploadError(true);
    try {
      final uploadFirstImageTask = firstRef.putFile(File(post.firstImageUrl));
      final uploadSecondImageTask =
          secondRef.putFile(File(post.secondImageUrl));

      for (UploadTask task in [uploadFirstImageTask, uploadSecondImageTask]) {
        Timer(const Duration(seconds: 20), () {
          if (task.snapshot.state == TaskState.running) {
            task.cancel();
            uploadImageProvider.setUploadError(true);
          }
        });
        task.snapshotEvents.listen((event) {
          switch (event.state) {
            case TaskState.success:
              uploadImageProvider.setUploadError(false);
              uploadImageProvider.setIsUploading(false);
            case TaskState.error:
              uploadImageProvider.setUploadError(true);
              uploadImageProvider.setIsUploading(false);
            case TaskState.running:
              uploadImageProvider.setUploadError(false);
              uploadImageProvider.setIsUploading(true);
            case TaskState.paused:
              uploadImageProvider.setUploadError(true);
              uploadImageProvider.setIsUploading(false);
            case TaskState.canceled:
              uploadImageProvider.setUploadError(true);
              uploadImageProvider.setIsUploading(false);
            default:
              uploadImageProvider.setUploadError(true);
              uploadImageProvider.setIsUploading(false);
          }
        });
      }
      final firstImageUrl = await uploadFirstImageTask.then((res) {
        return res.ref.getDownloadURL();
      });
      final secondImageUrl = await uploadSecondImageTask.then((res) {
        return res.ref.getDownloadURL();
      });
      await postsCollectionRef
          .doc(user.uid)
          .collection('userPosts')
          .doc(post.workoutSession.targetId.toString())
          .set({
        'firstImageUrl': firstImageUrl,
        'secondImageUrl': secondImageUrl,
        'workoutSessionId': post.workoutSession.targetId,
      });
      return true;
    } catch (e) {
      uploadImageProvider.setUploadError(true);
      return false;
    }
  }

  static void deletePost(int workoutSessionId) async {
    final WorkoutSession workoutSession =
        objectBox.workoutSessionService.getWorkoutSession(workoutSessionId)!;
    final User user = auth.currentUser!;
    await postsCollectionRef
        .doc(user.uid)
        .collection('userPosts')
        .doc(workoutSession.post.targetId.toString())
        .delete();
  }
}
