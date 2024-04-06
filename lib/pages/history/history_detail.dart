import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/menu_anchor/workout_menu_anchor.dart';
import 'package:intl/intl.dart';
import '../../models/exercise_set.dart';

class HistoryDetail extends StatelessWidget {
  final WorkoutSession workoutSession;

  const HistoryDetail({
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
        actions: [
          WorkoutMenuAnchor(
              workoutSessionId: workoutSession.id, isDetailPage: true)
        ],
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
                      size: 20,
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
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              exercisesSetInfo.exercise.target?.name ?? '',
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
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            (setInfo.key + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              renderExerciseInfo(exercisesSetInfo, setInfo),
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
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              )
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
        setInfo.value.time != null
            ? (setInfo.value.time.toString().length == 3
            ? '${setInfo.value.time.toString()[0]}:${setInfo.value.time.toString()[1]}${setInfo.value.time.toString()[2]}'
            : (setInfo.value.time.toString().length == 4)
            ? '${setInfo.value.time.toString()[0]}${setInfo.value.time.toString()[1]}:${setInfo.value.time.toString()[2]}${setInfo.value.time.toString()[3]}'
            : (setInfo.value.time.toString().length == 5)
            ? '${setInfo.value.time.toString()[0]}:${setInfo.value.time.toString()[1]}${setInfo.value.time.toString()[2]}:${setInfo.value.time.toString()[3]}${setInfo.value.time.toString()[4]}'
            : '-')
            : '-',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    default:
      return SizedBox();
  }
}
