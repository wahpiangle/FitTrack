import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:intl/intl.dart';

import '../../models/exercise_set.dart';

class CompleteHistoryDetail extends StatelessWidget {
  final WorkoutSession workoutSession;

  const CompleteHistoryDetail({
    super.key,
    required this.workoutSession,
  });

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;
    final hoursString = '$hours'.padLeft(2, '0');
    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$hoursString:$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  workoutSession.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Text(
                DateFormat('EEEE, dd MMMM yyyy, kk:mm a').format(
                  workoutSession.date,
                ),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      formatDuration(workoutSession.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              workoutSession.note == ''
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        workoutSession.note == ''
                            ? 'No notes'
                            : workoutSession.note.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
              Column(
                  children: workoutSession.exercisesSetsInfo
                      .map(
                        (exercisesSetInfo) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                exercisesSetInfo.exercise.target!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Column(
                              children: exercisesSetInfo.exerciseSets
                                  .asMap()
                                  .entries
                                  .map(
                                    (setInfo) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Text(
                                              (setInfo.key + 1).toString(),
                                              style: TextStyle(
                                                color: Colors.grey[300],
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          renderExerciseInfo(exercisesSetInfo, setInfo),
                                          const SizedBox(width: 10),
                                          setInfo.value.isPersonalRecord
                                              ? Container(
                                            padding:
                                            const EdgeInsets.all(
                                                5),
                                            decoration:
                                            const BoxDecoration(
                                              color: AppColours
                                                  .secondary,
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                            child: Text(
                                              '🏆 PR',
                                              style: TextStyle(
                                                color:
                                                Colors.green[900],
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      )
                      .toList())
            ],
          ),
        ),
      ),
    );
  }
}

Widget renderExerciseInfo(exercisesSetInfo, MapEntry<int, ExerciseSet> setInfo) {
  String category = exercisesSetInfo.exercise.target?.category?.target?.name ?? '';

  switch (category) {
    case "Barbell":
    case "Dumbbell":
    case "Machine":
    case "Cable":
    case "Band":
    case "Other":
      return Text(
        '${setInfo.value.weight} kg  × ${setInfo.value.reps}',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    case "Assisted Bodyweight":
      return Text(
        '-${setInfo.value.weight} kg × ${setInfo.value.reps}',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    case "Weighted Bodyweight":
      return Text(
        '+${setInfo.value.weight} kg  × ${setInfo.value.reps}',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    case "Reps Only":
      return Text(
        '${setInfo.value.reps} reps',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    case "Duration":
      return Text(
        '${setInfo.value.duration}',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    default:
      return SizedBox();
  }
}
