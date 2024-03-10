import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/home/no_workout_posted_page.dart';
import 'package:group_project/pages/home/workout_posted_page.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColours.primary,
        body: FutureBuilder(
            future: FirebasePostsService.getCurrentUserPosts(),
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
              if (snapshot.data!.isEmpty) {
                return const NoWorkoutPostedPage();
              } else {
                return WorkoutPostedPage(
                  currentUserPosts: snapshot.data!,
                );
              }
            }));
  }
}
