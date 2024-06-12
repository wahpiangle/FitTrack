import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';

class DeleteWorkoutSessionDialog extends StatelessWidget {
  final int workoutSessionId;
  final bool isDetailPage;
  const DeleteWorkoutSessionDialog({
    super.key,
    required this.workoutSessionId,
    required this.isDetailPage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Delete workout session?',
        style: TextStyle(
          color: Color(0xFFE1F0CF),
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'This action cannot be undone.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.black38,
                    ),
                    overlayColor: WidgetStateProperty.all(
                      Colors.grey[900],
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    try {
                      FirebasePostsService.deletePost(objectBox
                          .workoutSessionService
                          .getWorkoutSession(workoutSessionId)!
                          .postId);
                      FirebaseWorkoutsService.deleteWorkoutSession(
                          workoutSessionId);
                    } catch (e) {
                      print(e);
                    } finally {
                      objectBox.workoutSessionService
                          .removeWorkoutSession(workoutSessionId);
                      Navigator.of(context).pop();
                      if (isDetailPage) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.red,
                    ),
                    overlayColor: WidgetStateProperty.all(
                      Colors.red[900],
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
