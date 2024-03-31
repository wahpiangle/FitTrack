import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/history/components/store_workout_template_dialog.dart';

Widget menuSaveTemplateButton(
    {required BuildContext context, required int workoutSessionId}) {
  return MenuItemButton(
    style: ButtonStyle(
      surfaceTintColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      backgroundColor: MaterialStateProperty.all(
        const Color(0xFF333333),
      ),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.add,
          color: AppColours.secondary,
        ),
        SizedBox(width: 10),
        Text(
          'Save as Template',
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
          return StoreWorkoutTemplateDialog(workoutSessionId: workoutSessionId);
        },
      );
    },
  );
}
