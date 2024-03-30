import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/home/no_workout_posted_page.dart';
import 'package:group_project/pages/home/workout_posted_page.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> currentUserPostStream;

  @override
  void initState() {
    currentUserPostStream = FirebasePostsService.getCurrentUserPostStream();
    super.initState();
    print("home hi");
  }

  @override
  void dispose() {
    currentUserPostStream.drain();super.dispose();
  }

  bool setUserHasPostedPastDay(List<FirebaseUserPost> currentUserPosts) {
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    for (FirebaseUserPost post in currentUserPosts) {
      if (post.post.date.isAfter(yesterday)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      body: StreamBuilder(
        stream: currentUserPostStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            );
          }
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            final currentUserPosts =
                FirebaseUserPost.convertStreamDataToCurrentUserPost(
              snapshot.data!.docs
            );
            return FutureBuilder(
              future: currentUserPosts,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final currentUserPosts = snapshot.data
                      as List<FirebaseUserPost>
                    ..sort((a, b) => b.post.date.compareTo(a.post.date));
                  final bool userHasPostedPastDay =
                      setUserHasPostedPastDay(currentUserPosts);
                  if (currentUserPosts.isEmpty || !userHasPostedPastDay) {
                    return const NoWorkoutPostedPage();
                  } else {
                    return WorkoutPostedPage(
                      currentUserPosts: currentUserPosts,
                    );
                  }
                }
                return const Center(
                  child: Text('An error occurred',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                );
              }),
            );
          }
          return const Center(
            child: Text('An error occurred',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          );
        },
      ),
    );
  }
}
