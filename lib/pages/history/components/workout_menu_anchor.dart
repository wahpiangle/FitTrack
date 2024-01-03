import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/history/edit_workout/edit_workout_screen.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';

class WorkoutMenuAnchor extends StatelessWidget {
  final int workoutSessionId;
  final bool isDetailPage;

  const WorkoutMenuAnchor({
    super.key,
    required this.workoutSessionId,
    this.isDetailPage = false,
  });

  void _deleteWorkoutSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Delete workout session?',
            style: TextStyle(color: Color(0xFFE1F0CF)),
          ),
          content: const Text(
            'This action cannot be undone.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                FirebaseWorkoutsService.deleteWorkoutSession(workoutSessionId);
                objectBox.workoutSessionService
                    .removeWorkoutSession(workoutSessionId);
                Navigator.of(context).pop();
                if (isDetailPage) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
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
      menuChildren: List<MenuItemButton>.generate(2, (index) {
        switch (index) {
          case 0:
            return MenuItemButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                ),
                surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF333333)),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                objectBox.workoutSessionService.setEditingWorkoutSession(
                  workoutSessionId,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditWorkoutScreen(
                      workoutSessionId: workoutSessionId,
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
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                _deleteWorkoutSessionDialog(context);
              },
            );
          default:
            throw Exception('Invalid menu item index');
        }
      }),
    );
  }
}
