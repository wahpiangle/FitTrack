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
  static final usersCollectionRef = db.collection('users');

  static Future<bool> createPost(
      Post post, UploadImageProvider uploadImageProvider) async {
    final User user = auth.currentUser!;
    uploadImageProvider.setIsUploading(true);
    Reference firstRef = storage
        .ref('images/${user.uid}/firstImage/${post.workoutSessionId}.jpg');
    Reference secondRef = storage
        .ref('images/${user.uid}/secondImage/${post.workoutSessionId}.jpg');
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
              uploadImageProvider.setUploadError(false);
              uploadImageProvider.setIsUploading(true);
            case TaskState.canceled:
              uploadImageProvider.setUploadError(true);
              uploadImageProvider.setIsUploading(false);
            default:
              uploadImageProvider.setUploadError(false);
              uploadImageProvider.setIsUploading(true);
          }
        });
      }
      final firstImageUrl = await uploadFirstImageTask.then((res) {
        return res.ref.getDownloadURL();
      });
      final secondImageUrl = await uploadSecondImageTask.then((res) {
        return res.ref.getDownloadURL();
      });
      await postsCollectionRef.add(
        {
          'postedBy': user.uid,
          'firstImageUrl': firstImageUrl,
          'secondImageUrl': secondImageUrl,
          'workoutSessionId': post.workoutSessionId,
          'date': post.date,
          'caption': post.caption,
        },
      );
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

  static Future<bool> saveCaption(int workoutSessionId, String caption) async {
    try {
      final User user = auth.currentUser!;

      await postsCollectionRef
          .doc(user.uid)
          .collection('userPosts')
          .doc(workoutSessionId.toString()) // Use workoutSessionId directly
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
        return caption;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  static Future<List<Post>> getPostsByUserId(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await postsCollectionRef.where('postedBy', isEqualTo: userId).get();
      List<Post> posts = [];
      for (var doc in querySnapshot.docs) {
        posts.add(Post.fromDocument(doc));
      }
      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Post>> getCurrentUserPosts() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    return await FirebasePostsService.getPostsByUserId(currentUserUid!);
  }

  static Future<void> addReactionToPost(String imagePath, Post post) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    Reference ref =
        storage.ref('images/${post.id}/reactions/$currentUserUid.jpg');
    try {
      TaskSnapshot uploadImage = await ref.putFile(File(imagePath));
      uploadImage.ref.getDownloadURL().then((url) {
        postsCollectionRef.doc(post.postId).collection('reactions').add({
          'imageUrl': url,
          'postedByUserId': currentUserUid,
          'postId': post.postId,
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
