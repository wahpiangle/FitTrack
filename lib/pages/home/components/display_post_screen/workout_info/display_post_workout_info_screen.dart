import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/workout_info/friend_post_workout_info.dart';
import 'package:group_project/pages/home/components/display_post_screen/workout_info/own_post_workout_info.dart';
import 'package:group_project/services/firebase/auth_service.dart';

class DisplayPostWorkoutInfoScreen extends StatelessWidget {
  final Post post;
  final FirebaseUser? posterInfo;
  const DisplayPostWorkoutInfoScreen({
    super.key,
    required this.post,
    this.posterInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColours.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AuthService().getCurrentUser()!.uid == post.postedBy &&
                posterInfo == null
            ? OwnPostWorkoutInfo(
                post: post,
              )
            : FriendPostWorkoutInfo(
                post: post,
                posterInfo: posterInfo!,
              ),
      ),
    );
  }
}
