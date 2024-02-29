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

class PostStream {
  StreamController<FriendPostPair> _controller = StreamController<FriendPostPair>();

  Stream<FriendPostPair> get stream => _controller.stream;

  void addPostWithFriendName(FriendPostPair postPair) {
    _controller.add(postPair);
  }

  void dispose() {
    _controller.close();
  }
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
        Set<String> uniquePosts = Set();

        for (String friendId in friendIds) {
          List<Post> posts = await FirebasePostsService.getPostsByUserId(friendId);
          String? friendName = await FirebasePostsService.getUserName(friendId);

          for (Post post in posts) {
            // Generate a unique identifier for the post
            String postIdentifier = '${post.id}_${friendId}';

            // Check if the post is already in the set, if not, add it to the list
            if (!uniquePosts.contains(postIdentifier)) {
              uniquePosts.add(postIdentifier);
              friendPostPairs.add(FriendPostPair(post, friendName!));
            }
          }
        }

        friendsPostStream = Stream.value(friendPostPairs);
        return friendsPostStream;
      } catch (e) {
        print('Error initializing friendsPostStream: $e');
        friendsPostStream = Stream.empty();
        return friendsPostStream;
      }
    } else {
      print('Current user is null');
      friendsPostStream = Stream.empty();
      return friendsPostStream;
    }
  }


  Future<List<String>> getFriendsIds(String currentUserUid) async {
    List<String> friendIds = [];

    try {
      // Fetch the document snapshot for the current user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      // Check if the document exists and has data
      if (userDoc.exists) {
        // Retrieve the 'friends' field from the user document
        List<dynamic>? friends = userDoc.get('friends');

        if (friends != null && friends.isNotEmpty) {
          // Cast the dynamic list to a list of strings
          friendIds = friends.cast<String>().toList();
        }
      }
    } catch (e) {
      print('Error fetching friends: $e');
      // Handle the error as per your application's requirements
    }

    return friendIds;
  }
}

