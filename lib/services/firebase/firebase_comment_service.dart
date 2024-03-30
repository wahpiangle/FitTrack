import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/firebase/comments.dart';

class FirebaseCommentService {
  static Future<List<Comment>> getCommentsByPostId(String postId) async {
    List<Comment> comments = [];

    try {
      QuerySnapshot<Map<String, dynamic>> commentsSnapshot =
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      if (commentsSnapshot.docs.isNotEmpty) {
        comments.addAll(
          commentsSnapshot.docs.map((doc) => Comment.fromDocument(doc)),
        );
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }

    return comments;
  }


  static Future<void> addCommentToPost(String postId, String comment) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUid = currentUser?.uid;
    if (comment.trim().isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'postId': postId,
        'postedBy': currentUserUid,
        'comment': comment,
        'date': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteCommentById(String postId, String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCommentStreamById(
      String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
