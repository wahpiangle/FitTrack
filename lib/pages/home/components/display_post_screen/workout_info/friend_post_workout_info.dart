import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/workout_info/components/friend_post_best_set.dart';
import 'package:group_project/pages/home/components/display_post_screen/workout_info/own_post_workout_info.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';
import 'package:intl/intl.dart';

import '../../../../../models/exercise.dart';
import '../../../../../models/exercise_set.dart';

class FriendPostWorkoutInfo extends StatefulWidget {
  final Post post;
  final FirebaseUser posterInfo;
  const FriendPostWorkoutInfo({
    super.key,
    required this.post,
    required this.posterInfo,
  });

  @override
  State<FriendPostWorkoutInfo> createState() => _FriendPostWorkoutInfoState();
}

class _FriendPostWorkoutInfoState extends State<FriendPostWorkoutInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseWorkoutsService.getWorkoutSessionByUser(
          widget.post.workoutSessionId, widget.post.postedBy),
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
          final workoutSession = snapshot.data as FirebaseWorkoutSession;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: CachedNetworkImage(
                              imageUrl: widget.posterInfo.photoUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/icons/defaultimage.jpg'),
                            ),
                          );
                        });
                  },
                  child: widget.posterInfo.photoUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.posterInfo.photoUrl,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            size: 30,
                          ),
                        ),
                ),
                title: Text(
                  widget.posterInfo.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  DateFormat('EEEE, hh:mm:ss a').format(widget.post.date),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                workoutSession.title,
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
                  FriendPostBestSet(workoutSession: workoutSession),
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
                itemCount: workoutSession.exercisesSetsInfo.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final exercisesSetInfo =
                      workoutSession.exercisesSetsInfo[index];
                  final exercise = objectBox.exerciseService
                      .getExerciseById(exercisesSetInfo.exerciseId);
                  return Row(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            child: exercise?.halfImagePath == null
                                ? const Icon(
                                    Icons.fitness_center_sharp,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : Image.asset(
                                    exercise!.halfImagePath,
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
                                exercisesSetInfo.exerciseName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: exercisesSetInfo.exerciseSets.length,
                              itemBuilder: (context, index) {
                                final set =
                                    exercisesSetInfo.exerciseSets[index];
                                final weightrepsText = getWeightRepsText(set, exercise);

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
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
                                            weightrepsText,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      set.isPersonalRecord
                                          ? Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: AppColours.secondary,
                                                borderRadius: BorderRadius.all(
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
                },
              )),
            ],
          );
        }
        return Container();
      },
    );
  }
}
String getWeightRepsText(ExerciseSet set, Exercise? exercise) {
  if (exercise?.category.target?.name == 'Assisted Bodyweight') {
    return '-${set.weight} kg x ${set.reps}';
  } else if (exercise?.category.target?.name == 'Weighted Bodyweight') {
    return '+${set.weight} kg x ${set.reps}';
  } else if (exercise?.category.target?.name == 'Reps Only') {
    return '+${set.reps} reps';
  } else if (exercise?.category.target?.name == 'Duration') {
    final timeString = set.time.toString();
    if (timeString.length == 3) {
      return '${timeString[0]}:${timeString[1]}${timeString[2]}';
    } else if (timeString.length == 4) {
      return '${timeString[0]}${timeString[1]}:${timeString[2]}${timeString[3]}';
    } else if (timeString.length == 5) {
      return '${timeString[0]}:${timeString[1]}${timeString[2]}:${timeString[3]}${timeString[4]}';
    }
    return '-';
  } else {
    return '${set.weight} kg x ${set.reps}';
  }
}
