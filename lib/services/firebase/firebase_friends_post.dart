import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/post.dart';
import 'firebase_posts_service.dart'; // Import FirebasePostsService

class FriendPostPair {
  final Post post;
  final String friendName;

  FriendPostPair(this.post, this.friendName);
}

class FirebaseFriendsPost {
  late Stream<List<FriendPostPair>> friendsPostStream;

  Future<Stream<List<FriendPostPair>>> initFriendsPostStream() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      try {
        List<String> friendIds = await getFriendsIds(currentUserUid);
        List<FriendPostPair> friendPostPairs = [];

        // Use a set to track unique posts
        Set<String> uniquePosts = {};

        for (String friendId in friendIds) {
          List<Post> posts =
              await FirebasePostsService.getPostsByUserId(friendId);
          String? friendName = await FirebasePostsService.getUserName(friendId);

          for (Post post in posts) {
            String postIdentifier = '${post.id}_$friendId';

            if (!uniquePosts.contains(postIdentifier)) {
              uniquePosts.add(postIdentifier);
              friendPostPairs.add(FriendPostPair(post, friendName!));
            }
          }
        }

        friendsPostStream = Stream.value(friendPostPairs);
        return friendsPostStream;
      } catch (e) {
        friendsPostStream = const Stream.empty();
        return friendsPostStream;
      }
    } else {
      friendsPostStream = const Stream.empty();
      return friendsPostStream;
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
