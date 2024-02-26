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

        'userId': user.uid,
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

  static Future<List<Post>> getPostsByUserId(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await postsCollectionRef
          .doc(userId)
          .collection('userPosts')
          .get();

      List<Post> posts = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        DateTime? postDate;
        if (doc.data()['date'] != null) {
          Timestamp timestamp = doc.data()['date'];
          postDate = timestamp.toDate();
        }

        Post post = Post(
          firstImageUrl: doc.data()['firstImageUrl'] ?? '',
          secondImageUrl: doc.data()['secondImageUrl'] ?? '',
          caption: doc.data()['caption'] ?? '',
          date: postDate,
        );
        posts.add(post);
      }

      return posts;
    } catch (e) {
      return []; // Return an empty list if an error occurs
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

  static Future<bool> saveCaption(int workoutSessionId, String caption) async {
    try {
      final User user = auth.currentUser!;

      // Update the caption for the specified workout session
      await postsCollectionRef
          .doc(user.uid)
          .collection('userPosts')
          .doc(workoutSessionId.toString())  // Use workoutSessionId directly
          .update({'caption': caption});

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getCaption(int workoutSessionId) async {
    try {
      final User user = auth.currentUser!;

      final docSnapshot = await postsCollectionRef
          .doc(user.uid)
          .collection('userPosts')
          .doc(workoutSessionId.toString())
          .get();

      if (docSnapshot.exists) {
        final caption = docSnapshot.data()?['caption'] ?? '';
        return caption; // Return the caption if it exists
      } else {
        return ''; // Return an empty string if the document doesn't exist
      }
    } catch (e) {
      return ''; // Return an empty string if an error occurs
    }
  }



}
