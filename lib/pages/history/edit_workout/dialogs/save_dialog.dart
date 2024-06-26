import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';

class SaveDialog extends StatelessWidget {
  final int workoutSessionId;
  final bool isWorkoutSession;
  final bool fromDetailPage;
  const SaveDialog({
    super.key,
    required this.workoutSessionId,
    required this.fromDetailPage,
    this.isWorkoutSession = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      title: Center(
        child: Text(
          'Save ${isWorkoutSession ? 'Workout Session' : 'Template'}?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        'Are you sure you want to save this ${isWorkoutSession ? 'workout session' : 'template'}?',
        style: TextStyle(
          color: Colors.grey[500],
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
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.black38,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
                      objectBox.workoutSessionService
                          .updateSession(workoutSessionId);
                      FirebaseWorkoutsService.updateWorkoutSession(
                          workoutSessionId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      if (fromDetailPage) {
                        Navigator.pop(context);
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppColours.primary,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColours.secondary,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
