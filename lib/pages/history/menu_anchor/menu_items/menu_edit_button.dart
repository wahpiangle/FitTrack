import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/history/edit_workout/edit_workout_screen.dart';

Widget createMenuEditButton({
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
          Icons.edit,
          color: AppColours.secondary,
        ),
        SizedBox(width: 10),
        Text(
          'Edit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    ),
    onPressed: () {
      objectBox.workoutSessionService.createEditingWorkoutSessionCopy(
          objectBox.workoutSessionService.getWorkoutSession(workoutSessionId)!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditWorkoutScreen(
            workoutSessionId: workoutSessionId,
            fromDetailPage: isDetailPage,
          ),
        ),
      );
    },
  );
}
