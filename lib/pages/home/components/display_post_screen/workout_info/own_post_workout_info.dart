import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/layout/user_profile_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../models/exercise_set.dart';

class OwnPostWorkoutInfo extends StatelessWidget {
  final Post post;
  const OwnPostWorkoutInfo({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final WorkoutSession? workoutSession = objectBox.workoutSessionService
        .getWorkoutSession(post.workoutSessionId);
    final UserProfileProvider userProfileProvider =
        context.watch<UserProfileProvider>();
    final bestSet = objectBox.exerciseService.getBestSet(workoutSession!);

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
                        imageUrl: userProfileProvider.profileImage,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/icons/defaultimage.jpg'),
                      ),
                    );
                  });
            },
            child: userProfileProvider.profileImage.isNotEmpty
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(
                      userProfileProvider.profileImage,
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
            userProfileProvider.displayName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            DateFormat('EEEE, dd MMMM yyyy, hh:mm:ss a')
                .format(workoutSession.date),
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
            Row(
              children: [
                const Icon(
                  Icons.emoji_events_sharp,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Best',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      bestSet.exerciseSetInfo.target!.exercise.target!.name,
                      style: const TextStyle(
                        color: AppColours.secondary,
                        fontSize: 12,
                      ),
                    ),

                    Text(
                      getWeightRepsText(bestSet),
                      style: const TextStyle(
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
                          child:
                              exercisesSetInfo.exercise.target?.imagePath == ''
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
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                            itemCount: exercisesSetInfo.exerciseSets.length,
                            itemBuilder: (context, index) {
                              final set = exercisesSetInfo.exerciseSets[index];
                              String weightrepsText = '';
                              if (exercisesSetInfo.exercise.target?.category.target?.name == 'Weighted Bodyweight') {
                                weightrepsText = '+${set.weight} kg x ${set.reps}';
                              } else if (exercisesSetInfo.exercise.target?.category.target?.name == 'Assisted Bodyweight') {
                                weightrepsText = '-${set.weight} kg x ${set.reps}';
                              } else if (exercisesSetInfo.exercise.target?.category.target?.name == 'Reps Only') {
                                weightrepsText = '${set.reps} reps';
                              }else if (exercisesSetInfo.exercise.target?.category.target?.name == 'Duration') {
                                final timeString = bestSet.time.toString();
                                if (timeString.length == 3) {
                                  weightrepsText = '${set.time.toString()[0]}:${set.time.toString()[1]}${set.time.toString()[2]}';
                                } else if (timeString.length == 4) {
                                  weightrepsText = '${set.time.toString()[0]}${set.time.toString()[1]}:${set.time.toString()[2]}${set.time.toString()[3]}';
                                } else if (timeString.length == 5) {
                                  weightrepsText = '${set.time.toString()[0]}:${set.time.toString()[1]}${set.time.toString()[2]}:${set.time.toString()[3]}${set.time.toString()[3]}';
                                }

                              }else {
                                weightrepsText = '${set.weight} kg x ${set.reps}';
                              }
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
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          weightrepsText, // Using the modified weightrepsText here
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
              }),
        ),
      ],
    );
  }
}


enum ExerciseCategory {
  AssistedBodyweight,
  WeightedBodyweight,
  RepsOnly,
  Duration,
  Other,
}

String getTimeString(String timeString) {
  if (timeString.length == 3) {
    return '${timeString[0]}:${timeString[1]}${timeString[2]}';
  } else if (timeString.length == 4) {
    return '${timeString[0]}${timeString[1]}:${timeString[2]}${timeString[3]}';
  } else if (timeString.length == 5) {
    return '${timeString[0]}:${timeString[1]}${timeString[2]}:${timeString[3]}${timeString[4]}';
  }
  return '-';
}

String getWeightRepsText(ExerciseSet bestSet) {
  final category = bestSet.exerciseSetInfo.target?.exercise.target?.category.target?.name;
  final weight = bestSet.weight;
  final reps = bestSet.reps;
  final timeString = bestSet.time.toString();

  switch (category) {
    case 'Assisted Bodyweight':
      return '-$weight kg x $reps';
    case 'Weighted Bodyweight':
      return '+$weight kg x $reps';
    case 'Reps Only':
      return '$reps reps';
    case 'Duration':
      return getTimeString(timeString);
    default:
      return '$weight kg x $reps';
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
