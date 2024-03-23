import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class FirebaseUserPost {
  final Post post;
  final FirebaseUser postedBy;
  final List<Reaction> reactions;
  final List<Comment> comments;

  FirebaseUserPost(this.post, this.postedBy, this.reactions, this.comments);

  static Future<List<FirebaseUserPost>> convertStreamDataToCurrentUserPost(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) async {
    List<FirebaseUserPost> currentUserPosts = [];
    for (var doc in snapshots) {
      currentUserPosts.add(await FirebaseUserPost.fromDocument(doc));
    }
    return currentUserPosts;
  }

  static Future<FirebaseUserPost> fromDocument(doc) async {
    return FirebaseUserPost(
      Post.fromDocument(doc),
      await FirebaseUserService.getUserByUid(doc['postedBy']),
      await FirebasePostsService.getReactionsByPostId(doc.id),
      await FirebaseCommentService.getCommentsByPostId(doc.id),
    );
  }
}
