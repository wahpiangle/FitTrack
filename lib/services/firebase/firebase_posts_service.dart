import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/firebase/CurrentUserPost.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';

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
      final DocumentReference<Map<String, dynamic>> doc =
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
      objectBox.workoutSessionService
          .attachPostToWorkoutSession(post.workoutSessionId, doc.id);
      objectBox.postService.addFirebasePostId(post.id, doc.id);
      return true;
    } catch (e) {
      uploadImageProvider.setUploadError(true);
      return false;
    }
  }

  static void deletePost(String postId) async {
    await postsCollectionRef
        .doc(postId)
        .delete()
        .then((value) => print('Post Deleted'))
        .catchError((error) => print('Failed to delete post: $error'));
  }

  static Future<bool> saveCaption(String postId, String caption) async {
    try {
      await postsCollectionRef.doc(postId).update({'caption': caption});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getCaption(String postId) async {
    try {
      final Post post = await getPostById(postId);
      return post.caption;
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

  static Future<List<CurrentUserPost>> getCurrentUserPostsInfo() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final List<Post> posts = await getPostsByUserId(currentUserUid!);
    List<CurrentUserPost> currentUserPosts = [];
    for (var post in posts) {
      final List<Reaction> reactions = await getReactionsByPostId(post.postId);
      final List<Comment> comments =
          await FirebaseCommentService.getCommentsByPostId(post.postId);
      currentUserPosts.add(CurrentUserPost(
        post: post,
        reactions: reactions,
        comments: comments,
      ));
    }
    return currentUserPosts;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getCurrentUserPostStream() {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    return postsCollectionRef
        .where('postedBy', isEqualTo: currentUserUid)
        .snapshots();
  }

  static Future<void> addReactionToPost(String imagePath, Post post) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    Reference ref =
        storage.ref('posts/${post.postId}/reactions/$currentUserUid.jpg');
    try {
      TaskSnapshot uploadImage = await ref.putFile(File(imagePath));
      uploadImage.ref.getDownloadURL().then((url) {
        postsCollectionRef
            .doc(post.postId)
            .collection('reactions')
            .doc(currentUserUid)
            .set({
          'imageUrl': url,
          'postId': post.postId,
          'date': DateTime.now(),
        });
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Reaction>> getReactionsByPostId(String postId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await postsCollectionRef.doc(postId).collection('reactions').get();
      List<Reaction> reactions = [];
      for (var doc in querySnapshot.docs) {
        Reaction reaction = Reaction.fromDocument(doc);
        await Reaction.addUserInfo(reaction);
        reactions.add(reaction);
      }
      return reactions;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<Post> getPostById(String postId) async {
    try {
      final doc = await postsCollectionRef.doc(postId).get();
      return Post.fromDocumentSnapshot(doc);
    } catch (e) {
      print(e);
      return Post(
        caption: '',
        date: DateTime.now(),
        firstImageUrl: '',
        secondImageUrl: '',
        postedBy: '',
        postId: '',
        workoutSessionId: 0,
      );
    }
  }
}
