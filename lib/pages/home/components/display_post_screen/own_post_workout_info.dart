import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'package:intl/intl.dart';

class OwnPostWorkoutInfo extends StatelessWidget {
  final Post post;
  const OwnPostWorkoutInfo({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseUserService.getUserByUid(post.postedBy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
            child: Text(
              'An error occurred',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final WorkoutSession? workoutSession = objectBox.workoutSessionService
              .getWorkoutSession(post.workoutSessionId);
          final user = snapshot.data as FirebaseUser;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                title: Text(
                  user.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  DateFormat('EEEE, hh:mm:ss a').format(post.date),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                workoutSession!.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatDuration(workoutSession.duration),
                            style: const TextStyle(
                              color: AppColours.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.emoji_events_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Best',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            // TODO: Display best exercise name
                            'Best Exercise Name',
                            style: TextStyle(
                              color: AppColours.secondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            // TODO: Display best exercise value
                            'Best Exercise Weight & Reps',
                            style: TextStyle(
                              color: AppColours.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              workoutSession.note == ''
                  ? const SizedBox()
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        workoutSession.note,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workoutSession.exercisesSetsInfo.length,
                    itemBuilder: (context, index) {
                      final exercisesSetInfo =
                          workoutSession.exercisesSetsInfo[index];
                      return Row(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(300.0),
                                child: exercisesSetInfo
                                            .exercise.target?.imagePath ==
                                        ''
                                    ? const Icon(
                                        Icons.fitness_center_sharp,
                                        color: Colors.white,
                                        size: 40,
                                      )
                                    : Image.asset(
                                        exercisesSetInfo
                                            .exercise.target!.halfImagePath,
                                        fit: BoxFit.contain,
                                      )),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(
                                    exercisesSetInfo.exercise.target!.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      exercisesSetInfo.exerciseSets.length,
                                  itemBuilder: (context, index) {
                                    final set =
                                        exercisesSetInfo.exerciseSets[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${set.weight} kg',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'x  ${set.reps}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          set.isPersonalRecord
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColours.secondary,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '🏆 PR',
                                                    style: TextStyle(
                                                      color: Colors.green[900],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes;
  final seconds = totalSeconds % 60;
  final hoursString = hours == 0 ? '' : '$hours hours';
  final minutesString = minutes == 0 ? '' : '$minutes minutes';
  final secondsString = '$seconds seconds';
  if (hoursString.isNotEmpty) {
    return '$hoursString $minutesString $secondsString';
  }
  if (minutesString.isNotEmpty) {
    return '$minutesString $secondsString';
  }
  return secondsString;
}
