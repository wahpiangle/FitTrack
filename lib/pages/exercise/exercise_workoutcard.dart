import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/complete_workout/complete_history_detail.dart';
import 'package:intl/intl.dart';

class ExerciseWorkoutCard extends StatelessWidget {
  final WorkoutSession workoutSession;
  final String exerciseName; // New property to hold exercise name
  const ExerciseWorkoutCard({
    super.key,
    required this.workoutSession,
    required this.exerciseName, // Initialize the exerciseName property
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
    final filteredSetsInfo = workoutSession.exercisesSetsInfo
        .where((info) => info.exercise.target?.name == exerciseName)
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFFE1F0CF),
            width: 1,
          ),
        ),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => CompleteHistoryDetail(
                  workoutSession: workoutSession,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: ListTile(
              tileColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutSession.title.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy, kk:mm a').format(
                        workoutSession.date,
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
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
                      children: filteredSetsInfo
                          .map(
                            (exercisesSetInfo) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(
                                    "Sets Performed",
                                    style: TextStyle(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: Text(
                                                      (setInfo.key + 1)
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.grey[300],
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ('${setInfo.value.weight} kg'),
                                                    style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Text(
                                                      '×',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[300],
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Text(
                                                    setInfo.value.reps
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                          .toList(),
                    )
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
