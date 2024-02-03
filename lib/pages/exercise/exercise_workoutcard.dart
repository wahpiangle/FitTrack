import 'package:flutter/material.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:intl/intl.dart';

import '../history/complete_workout/complete_history_detail.dart';

class ExerciseWorkoutCard extends StatelessWidget {
  final WorkoutSession workoutSession;
  const ExerciseWorkoutCard({
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
                      DateFormat('dd MMMM yyyy').format(
                        workoutSession.date,
                      ),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //   child: Row(
                    //     children: [
                    //       const Icon(
                    //         Icons.access_time_sharp,
                    //         color: Colors.white,
                    //         size: 20,
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         formatDuration(workoutSession.duration),
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

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
                                exercisesSetInfo.exercise.target!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),


                              // child: Text(
                              //   "Sets performed",
                              //   style: const TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 18,
                              //   ),
                              // ),



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
                                      Text(
                                        ('${setInfo.value.weight} kg'),
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(
                                          '×',
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        setInfo.value.reps.toString(),
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 16,
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
              // subtitle: ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: workoutSession.exercisesSetsInfo.length,
              //   itemBuilder: (context, index) {
              //     return Row(
              //       children: [
              //         Text(
              //           "${workoutSession.exercisesSetsInfo[index].exerciseSets.length} × ",
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 15,
              //           ),
              //         ),
              //         const SizedBox(width: 10),
              //         Text(
              //           workoutSession
              //               .exercisesSetsInfo[index].exercise.target!.name,
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 15,
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // ),





            ),
          ),
        ),
      ),
    );
  }
}
