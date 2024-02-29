import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/models/post.dart';
import 'firebase_posts_service.dart'; // Import FirebasePostsService

class PostStream {
  StreamController<Post> _controller = StreamController<Post>();

  Stream<Post> get stream => _controller.stream;

  void addPost(Post post) {
    _controller.add(post);
  }

  void dispose() {
    _controller.close();
  }
}

class FirebaseFriendsPost {
  late Stream<Post> friendsPostStream; // Change the type to Stream<Post>

  Future<Stream<Post>> initFriendsPostStream() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      try {
        List<String> friendIds = await getFriendsIds(currentUserUid);
        List<Post> friendPosts = [];

        for (String friendId in friendIds) {
          List<Post> posts = await FirebasePostsService.getPostsByUserId(friendId);
          friendPosts.addAll(posts);
        }

        // Create a PostStream instance
        PostStream postStream = PostStream();

        // Add each post to the stream
        for (Post post in friendPosts) {
          postStream.addPost(post);
          print('Post added to stream: ${post.id}');
        }

        // Assign the stream to friendsPostStream
        friendsPostStream = postStream.stream;

        print('Friend posts stream initialized successfully');

        // Return the stream
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