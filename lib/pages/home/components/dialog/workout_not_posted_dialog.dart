import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:intl/intl.dart';

class WorkoutNotPostedDialog extends StatelessWidget {
  final WorkoutSession workoutSession;
  const WorkoutNotPostedDialog({super.key, required this.workoutSession});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Post your workout?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColours.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
          'Your workout session ${workoutSession.title} at ${DateFormat('hh:mm a').format(workoutSession.date)} on ${DateFormat('dd/MM/yyyy').format(workoutSession.date)} does not have a post, post it now?',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white)),
      actions: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'post_workout_prompt',
                  arguments: workoutSession,
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(AppColours.secondary),
              ),
              child: const Text(
                'Post Workout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black38),
              ),
              child: const Text(
                'No',
                style: TextStyle(color: AppColours.secondary),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
