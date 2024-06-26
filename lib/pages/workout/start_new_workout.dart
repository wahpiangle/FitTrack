import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';
import 'package:group_project/pages/workout/components/timer/components/finish_workout_dialog.dart';
import 'package:group_project/pages/workout/components/timer/components/rest_timer_dialog.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'components/timer/custom_timer_picker_dialog.dart';

class StartNewWorkout extends StatefulWidget {
  final List<Exercise> exerciseData;

  const StartNewWorkout({super.key, required this.exerciseData});

  @override
  State<StartNewWorkout> createState() => _StartNewWorkoutState();
}

class _StartNewWorkoutState extends State<StartNewWorkout> {
  bool _isSetTimeVisible = true;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    if (!_isTimerRunning) {
      timerProvider.startTimer();
      setState(() {
        _isTimerRunning = true;
      });
    }
  }

  void selectExercise(Exercise selectedExercise) {
    objectBox.currentWorkoutSessionService
        .addExerciseToCurrentWorkoutSession(selectedExercise);
  }

  void removeSet(int exerciseSetId) {
    setState(() {
      objectBox.exerciseService.removeSetFromExercise(exerciseSetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final restTimerProvider = Provider.of<RestTimerProvider>(context);
    final customTimerProvider = Provider.of<CustomTimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  bool everySetCompleted = objectBox
                      .currentWorkoutSessionService
                      .getCurrentWorkoutSession()
                      .exercisesSetsInfo
                      .every((exercisesSetsInfo) {
                    return exercisesSetsInfo.exerciseSets.every((exerciseSet) {
                      return exerciseSet.isCompleted;
                    });
                  });
                  bool isNotEmpty = objectBox.currentWorkoutSessionService
                      .getCurrentWorkoutSession()
                      .exercisesSetsInfo
                      .isNotEmpty;
                  if (isNotEmpty) {
                    if (everySetCompleted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return const FinishWorkoutDialog();
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please complete all sets",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Color(0xFF1A1A1A),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please add at least one exercise",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xFF1A1A1A),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Finish",
                    style: TextStyle(
                      color: Color(0xFFE1F0CF),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        title: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: GestureDetector(
            onTap: () {
              if (restTimerProvider.isRestTimerRunning) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RestTimerDialog(
                      restTimerProvider: restTimerProvider,
                    );
                  },
                );
              }
              if (customTimerProvider.isRestTimerRunning) {
                showCustomTimerDetailsDialog(customTimerProvider);
              }
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.18,
                    child: LinearProgressIndicator(
                      value: restTimerProvider.currentRestTimerDuration > 0
                          ? restTimerProvider.currentRestTimerDuration /
                              restTimerProvider.restTimerDuration
                          : 0.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColours.secondaryDark,
                      ),
                      backgroundColor: Colors.grey[800],
                      minHeight: 40,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                ),
                if (restTimerProvider.isRestTimerEnabled &&
                    restTimerProvider.isRestTimerRunning)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.40,
                      child: LinearProgressIndicator(
                        value: restTimerProvider.currentRestTimerDuration > 0
                            ? restTimerProvider.currentRestTimerDuration /
                                restTimerProvider.restTimerDuration
                            : 0.0,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColours.secondaryDark,
                        ),
                        backgroundColor: Colors.grey[800],
                        minHeight: 40,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                  ),
                if (customTimerProvider.isRestTimerRunning)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.40,
                      child: LinearProgressIndicator(
                        value: customTimerProvider.customCurrentTimerDuration >
                                0
                            ? customTimerProvider.customCurrentTimerDuration /
                                customTimerProvider.customTimerDuration
                            : 0.0,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColours.secondaryDark,
                        ),
                        backgroundColor: Colors.grey[800],
                        minHeight: 40,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                  ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: restTimerProvider.isRestTimerEnabled &&
                          restTimerProvider.isRestTimerRunning
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 24),
                        const SizedBox(width: 2),
                        Text(
                          " ${RestTimerProvider.formatDuration(restTimerProvider.currentRestTimerDuration)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () async {
                      await _showScrollCustomPicker(
                          context, customTimerProvider);
                      setState(() {
                        _isSetTimeVisible = !_isSetTimeVisible;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: customTimerProvider.isRestTimerRunning
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 24),
                        const SizedBox(width: 2),
                        Text(
                          " ${RestTimerProvider.formatDuration(customTimerProvider.customCurrentTimerDuration)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondChild: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColours.primary,
      body: StreamBuilder<CurrentWorkoutSession>(
        stream:
            objectBox.currentWorkoutSessionService.watchCurrentWorkoutSession(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ExerciseTile(
                    exerciseData: widget.exerciseData,
                    exercisesSetsInfo:
                        snapshot.data!.exercisesSetsInfo.toList(),
                    selectExercise: selectExercise,
                    removeSet: removeSet,
                    timerProvider: timerProvider,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> showCustomTimerDetailsDialog(
      CustomTimerProvider customTimerProvider) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestTimerDialog(
          customTimerProvider: customTimerProvider,
        );
      },
    );
  }

  Future<void> _showScrollCustomPicker(
      BuildContext context, CustomTimerProvider customTimerProvider) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomTimerPickerDialog(
          customTimerProvider: customTimerProvider,
          showCustomTimerDetailsDialog: (BuildContext context) {
            showCustomTimerDetailsDialog(customTimerProvider);
          },
        );
      },
    );
  }
}
