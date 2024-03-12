import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

import 'reaction.dart';

class CurrentUserPost {
  final Post post;
  final List<Reaction> reactions;
  final List<Comment> comments;
  CurrentUserPost({
    required this.post,
    required this.reactions,
    required this.comments,
  });

  static Future<CurrentUserPost> fromDocument(doc) async {
    return CurrentUserPost(
      post: Post.fromDocument(doc),
      reactions: await FirebasePostsService.getReactionsByPostId(doc.id),
      comments: await FirebaseCommentService.getCommentsByPostId(doc.id),
    );
  }

  static Future<List<CurrentUserPost>> convertStreamDataToCurrentUserPost(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) async {
    List<CurrentUserPost> currentUserPosts = [];
    for (var doc in snapshots) {
      currentUserPosts.add(await CurrentUserPost.fromDocument(doc));
    }
    return currentUserPosts;
  }
}
