import 'package:flutter/material.dart';
import 'package:group_project/main.dart';

class WorkoutMenuAnchor extends StatelessWidget {
  final int workoutSessionId;

  const WorkoutMenuAnchor({
    super.key,
    required this.workoutSessionId,
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
                objectBox.workoutSessionService
                    .removeWorkoutSession(workoutSessionId);
                Navigator.of(context).pop();
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
      menuChildren: List<MenuItemButton>.generate(
        1,
        (index) => MenuItemButton(
          style: ButtonStyle(
            surfaceTintColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFF333333),
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
        ),
      ),
    );
  }
}
