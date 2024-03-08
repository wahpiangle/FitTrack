import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/home/no_workout_posted_page.dart';
import 'package:group_project/pages/home/workout_posted_page.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> imageList = [];

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  void fetchUserPosts() async {
    List<Post> userPosts = await FirebasePostsService.getCurrentUserPosts();

    setState(() {
      imageList = userPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      body: imageList.isEmpty
          ? const NoWorkoutPostedPage()
          : WorkoutPostedPage(
              imageList: imageList,
            ),
    );
  }
}
