import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'firebase_posts_service.dart';

class FirebaseFriendsPost {
  Future<Stream<Map<FirebaseUser, List<FirebaseUserPost>>>>
      initFriendsPostStream() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    var friendsPostMap = <FirebaseUser, List<FirebaseUserPost>>{};
    try {
      List<String> friendIds = await getFriendsIds(currentUserUid);

      Set<String> uniquePosts = {};
      List<FirebaseUserPost> friendPosts = [];

      for (String friendId in friendIds) {
        List<Post> posts =
            await FirebasePostsService.getPostsByUserId(friendId);
        FirebaseUser friend = await FirebaseUserService.getUserByUid(friendId);

        for (Post post in posts) {
          if (!uniquePosts.contains(post.postId)) {
            uniquePosts.add(post.postId);
            List<Reaction> postReactions =
                await FirebasePostsService.getReactionsByPostId(post.postId);
            List<Comment> postComments =
                await FirebaseCommentService.getCommentsByPostId(post.postId);
            FirebaseUserPost friendsPost =
                FirebaseUserPost(post, friend, postReactions, postComments);
            friendPosts.add(friendsPost);

            if (friendsPostMap.containsKey(friend)) {
              friendsPostMap[friend]!.add(friendsPost);
            } else {
              friendsPostMap[friend] = [friendsPost];
            }
          }
        }
      }
      final friendsPostStream = Stream.value(friendsPostMap);
      return friendsPostStream;
    } catch (e) {
      print('Error initializing friends post stream: $e');
      rethrow;
    }
  }

  Future<List<String>> getFriendsIds(String currentUserUid) async {
    List<String> friendIds = [];

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (userDoc.exists) {
        List<dynamic>? friends = userDoc.get('friends');

        if (friends != null && friends.isNotEmpty) {
          friendIds = friends.cast<String>().toList();
        }
      }
    } catch (e) {
      print('Error fetching friends: $e');
    }

    return friendIds;
  }
}
