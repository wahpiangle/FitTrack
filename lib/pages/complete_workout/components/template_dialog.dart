import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';

class TemplateDialog extends StatelessWidget {
  final WorkoutSession workoutSession;
  const TemplateDialog({
    super.key,
    required this.workoutSession,
  });

  @override
  Widget build(BuildContext context) {
    final hasWorkoutTemplate = workoutSession.workoutTemplate.hasValue;
    return AlertDialog(
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      title: Center(
        child: Text(
          hasWorkoutTemplate ? 'Update Template?' : 'Save as Workout Template?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        hasWorkoutTemplate
            ? "You've made changes to the workout template. Would you like to update it?"
            : 'Would you like to save this workout as a template?',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        hasWorkoutTemplate
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              AppColours.secondary),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          overlayColor: WidgetStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        onPressed: () {
                          objectBox.workoutTemplateService
                              .createWorkoutTemplateFromWorkoutSession(
                            workoutSession,
                          );
                          objectBox.workoutTemplateService
                              .deleteWorkoutTemplate(
                                  workoutSession.workoutTemplate.targetId);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Update Template',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.black38),
                          overlayColor: WidgetStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.2),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Keep Original Template',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.black38),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          overlayColor: WidgetStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        onPressed: () {
                          objectBox.workoutTemplateService
                              .createWorkoutTemplateFromWorkoutSession(
                            workoutSession,
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Save Template',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.black38),
                          overlayColor: WidgetStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.2),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No Thanks',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
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
