import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/models/post.dart';
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
    Reference firstRef = storage
        .ref('images/${user.uid}/firstImage/${post.workoutSessionId}.jpg');
    Reference secondRef = storage
        .ref('images/${user.uid}/secondImage/${post.workoutSessionId}.jpg');
    Future.delayed(const Duration(seconds: 3));
    final uploadFirstImageTask = firstRef.putFile(File(post.firstImageUrl));
    uploadFirstImageTask.snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.success:
          uploadImageProvider.setUploadError(false);
          uploadImageProvider.setIsUploading(false);
          break;
        case TaskState.error:
          uploadImageProvider.setUploadError(true);
          uploadImageProvider.setIsUploading(false);
          break;
        default:
          uploadImageProvider.setUploadError(false);
          uploadImageProvider.setIsUploading(true);
      }
    });

    final uploadSecondImageTask = secondRef.putFile(File(post.secondImageUrl));
    uploadSecondImageTask.snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.success:
          uploadImageProvider.setUploadError(false);
          uploadImageProvider.setIsUploading(false);
          break;
        case TaskState.error:
          uploadImageProvider.setUploadError(true);
          uploadImageProvider.setIsUploading(false);
          break;
        default:
          uploadImageProvider.setUploadError(false);
          uploadImageProvider.setIsUploading(true);
      }
    });
    final firstImageUrl = await firstRef.getDownloadURL();
    final secondImageUrl = await secondRef.getDownloadURL();
    await postsCollectionRef
        .doc(user.uid)
        .collection('userPosts')
        .doc(post.workoutSessionId.toString())
        .set({
      'firstImageUrl': firstImageUrl,
      'secondImageUrl': secondImageUrl,
      'workoutSessionId': post.workoutSessionId,
    });
    return true;
  }
}
