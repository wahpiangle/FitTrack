import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/menu_anchor/workout_menu_anchor.dart';
import 'package:group_project/pages/history/post_display.dart';
import 'package:intl/intl.dart';
import '../../models/exercise_set.dart';

class HistoryDetail extends StatefulWidget {
  final WorkoutSession workoutSession;

  const HistoryDetail({
    super.key,
    required this.workoutSession,
  });

  @override
  HistoryDetailState createState() => HistoryDetailState();
}

class HistoryDetailState extends State<HistoryDetail> {
  bool _isScrollDisabled = false;

  @override
  void initState() {
    super.initState();
    // Add a delay to start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

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

  void disableScroll() {
    setState(() {
      _isScrollDisabled = true;
    });
  }

  void enableScroll() {
    setState(() {
      _isScrollDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          WorkoutMenuAnchor(
            workoutSessionId: widget.workoutSession.id,
            isDetailPage: true,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics:
              _isScrollDisabled ? const NeverScrollableScrollPhysics() : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.workoutSession.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the PostDisplay page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDisplay(
                            postId: widget.workoutSession.postId,
                            postDate: widget.workoutSession.date,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE1F0CF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo,
                          color: Colors.black,
                        ),
                        Text(
                          'View Memories',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('EEEE, dd MMMM yyyy, kk:mm a').format(
                  widget.workoutSession.date,
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
                    const SizedBox(width: 10),
                    Text(
                      formatDuration(widget.workoutSession.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              widget.workoutSession.note == ''
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        widget.workoutSession.note == ''
                            ? 'No notes'
                            : widget.workoutSession.note.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
              Column(
                children: widget.workoutSession.exercisesSetsInfo
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
                                              renderExerciseInfo(
                                                  exercisesSetInfo, setInfo),
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
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

Widget renderExerciseInfo(
    exercisesSetInfo, MapEntry<int, ExerciseSet> setInfo) {
  String category =
      exercisesSetInfo.exercise.target?.category?.target?.name ?? '';

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
      String formattedTime = formatDurationFromSeconds(setInfo.value.time ?? 0);
      return Text(
        formattedTime,
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 16,
        ),
      );
    default:
      return SizedBox();
  }
}

String formatDurationFromSeconds(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = (duration.inMinutes % 60)
      .toString()
      .padLeft(2, '0'); // Pad minutes with leading zero if necessary
  final seconds = (totalSeconds % 60)
      .toString()
      .padLeft(2, '0'); // Pad seconds with leading zero if necessary

  if (hours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}
