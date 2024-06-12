import 'package:flutter/material.dart';
import 'package:group_project/pages/history/components/delete_workout_session_dialog.dart';

Widget menuDeleteWorkoutButton({
  required BuildContext context,
  required int workoutSessionId,
  required bool isDetailPage,
}) {
  return MenuItemButton(
    style: ButtonStyle(
      surfaceTintColor: WidgetStateProperty.all(
        Colors.transparent,
      ),
      backgroundColor: WidgetStateProperty.all(
        const Color(0xFF333333),
      ),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.close,
          color: Colors.red,
        ),
        SizedBox(width: 10),
        Text(
          'Delete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteWorkoutSessionDialog(
              workoutSessionId: workoutSessionId, isDetailPage: isDetailPage);
        },
      );
    },
  );
}
