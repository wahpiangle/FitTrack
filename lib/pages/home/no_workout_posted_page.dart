import 'package:flutter/material.dart';
import 'package:group_project/constants/page_enums.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/home/components/dialog/workout_not_posted_dialog.dart';
import 'package:group_project/pages/layout/app_layout.dart';

class NoWorkoutPostedPage extends StatefulWidget {
  const NoWorkoutPostedPage({super.key});

  @override
  State<NoWorkoutPostedPage> createState() => _NoWorkoutPostedPageState();
}

class _NoWorkoutPostedPageState extends State<NoWorkoutPostedPage> {
  bool userHasWorkoutSessionWithoutPost = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _checkIfUserHasWorkoutSessionWithoutPost(),
    );
  }

  void _checkIfUserHasWorkoutSessionWithoutPost() {
    final List<WorkoutSession> workoutSessions =
        objectBox.workoutSessionService.getAllWorkoutSessions();
    for (WorkoutSession workoutSession in workoutSessions) {
      if (workoutSession.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 1),
        ),
      )) {
        setState(() {
          userHasWorkoutSessionWithoutPost = true;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              WorkoutNotPostedDialog(workoutSession: workoutSession),
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userHasWorkoutSessionWithoutPost
                  ? 'You have not posted your workout!'
                  : 'Start a Workout & Add a Post!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            userHasWorkoutSessionWithoutPost
                ? const Text(
                    'Post your workout to see your friends\' posts!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: AppColours.secondary,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => userHasWorkoutSessionWithoutPost
                          ? const AppLayout(
                              currentIndex: Pages.HistoryPage,
                            )
                          : const AppLayout(
                              currentIndex: Pages.NewWorkoutPage,
                            ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                label: Text(
                  userHasWorkoutSessionWithoutPost
                      ? 'Post Workout'
                      : 'Start a Workout',
                  style: const TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
