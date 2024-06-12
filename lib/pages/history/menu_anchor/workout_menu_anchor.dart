import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/menu_anchor/menu_items/menu_create_post_button.dart';
import 'package:group_project/pages/history/menu_anchor/menu_items/menu_delete_workout_button.dart';
import 'package:group_project/pages/history/menu_anchor/menu_items/menu_edit_button.dart';
import 'package:group_project/pages/history/menu_anchor/menu_items/menu_save_template_button.dart';

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
    WorkoutSession workoutSession =
        objectBox.workoutSessionService.getWorkoutSession(workoutSessionId)!;
    bool workoutCanBePosted = workoutSession.postId.isEmpty &&
        workoutSession.date
            .isAfter(DateTime.now().subtract(const Duration(days: 1)));
    return MenuAnchor(
      alignmentOffset: const Offset(-120, 0),
      style: MenuStyle(
        backgroundColor: WidgetStateColor.resolveWith(
          (states) => const Color(0xFF333333),
        ),
        surfaceTintColor: WidgetStateColor.resolveWith(
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
      menuChildren: workoutCanBePosted
          ? List<Widget>.generate(
              4,
              (index) {
                switch (index) {
                  case 0:
                    return createMenuEditButton(
                        context: context,
                        workoutSessionId: workoutSessionId,
                        isDetailPage: isDetailPage);
                  case 1:
                    return menuSaveTemplateButton(
                        context: context, workoutSessionId: workoutSessionId);
                  case 2:
                    return menuCreatePostButton(
                        context: context,
                        workoutSessionId: workoutSessionId,
                        isDetailPage: isDetailPage);
                  case 3:
                    return menuDeleteWorkoutButton(
                        context: context,
                        workoutSessionId: workoutSessionId,
                        isDetailPage: isDetailPage);
                  default:
                    throw Exception('Invalid menu item index');
                }
              },
            )
          : List<Widget>.generate(
              3,
              (index) {
                switch (index) {
                  case 0:
                    return createMenuEditButton(
                        context: context,
                        workoutSessionId: workoutSessionId,
                        isDetailPage: isDetailPage);
                  case 1:
                    return menuSaveTemplateButton(
                        context: context, workoutSessionId: workoutSessionId);
                  case 2:
                    return menuDeleteWorkoutButton(
                        context: context,
                        workoutSessionId: workoutSessionId,
                        isDetailPage: isDetailPage);
                  default:
                    throw Exception('Invalid menu item index');
                }
              },
            ),
    );
  }
}
