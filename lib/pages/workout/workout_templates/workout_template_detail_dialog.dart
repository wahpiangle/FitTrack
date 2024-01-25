import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/pages/workout/workout_templates/edit_template_page.dart';

class WorkoutTemplateDetails extends StatelessWidget {
  final WorkoutTemplate workoutTemplateData;

  const WorkoutTemplateDetails({
    super.key,
    required this.workoutTemplateData,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(30),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                workoutTemplateData.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black45),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    objectBox.workoutTemplateService
                        .createEditingWorkoutTemplateCopy(workoutTemplateData);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditTemplatePage(
                          workoutTemplateId: workoutTemplateData.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: AppColours.secondary,
                    size: 16,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: AppColours.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            bottomNavigationBar: TextButton(
              onPressed: () async {
                objectBox.currentWorkoutSessionService
                    .startCurrentWorkoutFromTemplate(workoutTemplateData);
                Navigator.of(context).pop();
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => StartNewWorkout(
                    exerciseData: objectBox.exerciseService.getAllExercises(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColours.secondary),
              ),
              child: const Text(
                'Start workout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutTemplateData.note == ''
                          ? 'No notes'
                          : workoutTemplateData.note,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: workoutTemplateData.exercisesSetsInfo
                          .map(
                            (exercisesSetInfo) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(300.0),
                                  child: exercisesSetInfo
                                              .exercise.target!.imagePath ==
                                          ''
                                      ? Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE1F0CF),
                                            borderRadius:
                                                BorderRadius.circular(300.0),
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 20,
                                          ),
                                          child: Center(
                                            child: Text(
                                              exercisesSetInfo
                                                  .exercise.target!.name[0]
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(
                                            right: 20,
                                          ),
                                          child: Image.asset(
                                            exercisesSetInfo
                                                .exercise.target!.halfImagePath,
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${exercisesSetInfo.exerciseSets.length} × ${exercisesSetInfo.exercise.target!.name}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        exercisesSetInfo.exercise.target!
                                            .bodyPart.target!.name,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
