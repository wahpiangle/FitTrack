import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/own_post_workout_info.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';

class DisplayPostWorkoutInfoScreen extends StatelessWidget {
  final Post post;
  const DisplayPostWorkoutInfoScreen({
    super.key,
    required this.post,
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
        child: AuthService().getCurrentUser()!.uid == post.postedBy
            // is own post
            ? OwnPostWorkoutInfo(
                post: post,
              )
            : FutureBuilder(
                future: Future.wait(
                  [
                    FirebaseUserService.getUserByUid(post.postedBy),
                    FirebaseWorkoutsService.getWorkoutSessionByUser(
                        post.workoutSessionId, post.postedBy),
                  ],
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'An error occurred',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final user = snapshot.data?[0] as FirebaseUser;
                    final workoutSession =
                        snapshot.data?[1] as FirebaseWorkoutSession;
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TODO: Display workout session info
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
      ),
    );
  }
}
