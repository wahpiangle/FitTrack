import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';

Widget menuCreatePostButton({
  required BuildContext context,
  required int workoutSessionId,
  required bool isDetailPage,
}) {
  return MenuItemButton(
    style: ButtonStyle(
      surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      backgroundColor: MaterialStateProperty.all(const Color(0xFF333333)),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.camera_alt_outlined,
          color: AppColours.secondary,
        ),
        SizedBox(width: 10),
        Text(
          'Create Post',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    ),
    onPressed: () {
      Navigator.pushNamed(
        context,
        'post_workout_prompt',
        arguments:
            objectBox.workoutSessionService.getWorkoutSession(workoutSessionId),
      );
    },
  );
}
