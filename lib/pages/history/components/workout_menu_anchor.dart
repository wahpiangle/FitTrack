import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/history/components/delete_workout_session_dialog.dart';
import 'package:group_project/pages/history/components/store_workout_template_dialog.dart';
import 'package:group_project/pages/history/edit_workout/edit_workout_screen.dart';

class WorkoutMenuAnchor extends StatelessWidget {
  final int workoutSessionId;
  final bool isDetailPage;

  const WorkoutMenuAnchor({
    super.key,
    required this.workoutSessionId,
    this.isDetailPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(-120, 0),
      style: MenuStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => const Color(0xFF333333),
        ),
        surfaceTintColor: MaterialStateColor.resolveWith(
          (states) => const Color(0xFF333333),
        ),
      ),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFFE1F0CF),
          ),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: List<Widget>.generate(3, (index) {
        switch (index) {
          case 0:
            return MenuItemButton(
              style: ButtonStyle(
                surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF333333)),
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
                    objectBox.workoutSessionService
                        .getWorkoutSession(workoutSessionId)!);
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
          case 1:
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
                    return StoreWorkoutTemplateDialog(
                        workoutSessionId: workoutSessionId);
                  },
                );
              },
            );
          case 2:
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
                        workoutSessionId: workoutSessionId,
                        isDetailPage: isDetailPage);
                  },
                );
              },
            );
          default:
            throw Exception('Invalid menu item index');
        }
      }),
    );
  }
}
