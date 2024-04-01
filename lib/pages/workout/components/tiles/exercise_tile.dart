import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/add_exercise_button.dart';
import 'package:group_project/pages/workout/components/tiles/cancel_workout_button.dart';
import 'package:group_project/pages/workout/components/tiles/set_tiles.dart';
import 'package:group_project/pages/workout/components/timer/components/rest_timer_dialog.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:group_project/pages/workout/components/workout_header.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<ExercisesSetsInfo> exercisesSetsInfo;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(int exerciseSetId) removeSet;
  final TimerProvider timerProvider;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.exercisesSetsInfo,
    required this.selectExercise,
    required this.removeSet,
    required this.timerProvider,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late TimerProvider timerProvider;
  late RestTimerProvider restTimerProvider;
  late CustomTimerProvider customTimerProvider;
  bool isSetCompleted = false;
  bool displayRestTimer = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerProvider = Provider.of<TimerProvider>(context);
    restTimerProvider =
        Provider.of<RestTimerProvider>(context); // Initialize restTimerProvider
    customTimerProvider = Provider.of<CustomTimerProvider>(
        context); // Initialize restTimerProvider
  }

  void addSet(ExercisesSetsInfo exercisesSetsInfo) {
    setState(() {
      objectBox.exerciseService.addSetToExercise(exercisesSetsInfo);
    });
  }

  void setIsCompleted(int exerciseSetId) {
    objectBox.exerciseService.completeExerciseSet(exerciseSetId);
    setState(() {
      for (ExercisesSetsInfo exercisesSetsInfo in widget.exercisesSetsInfo) {
        exercisesSetsInfo.exerciseSets
            .where((exerciseSet) => exerciseSet.id == exerciseSetId)
            .toList()
            .forEach((exerciseSet) {


          if (exercisesSetsInfo.exercise.target?.category.target?.name == "Reps Only") {
            // Check if reps is null and weight is not null
            if (exerciseSet.reps != null && exerciseSet.weight == null) {
              exerciseSet.isCompleted = !exerciseSet.isCompleted;
            }
            else if (exerciseSet.reps != null && exerciseSet.weight != null){
              exerciseSet.isCompleted = !exerciseSet.isCompleted;
            }
          }

          else if (exercisesSetsInfo.exercise.target?.category.target?.name == "Duration") {
            if (exerciseSet.time != null) {
              String timeAsString = exerciseSet.time.toString();
              if (timeAsString.length == 3) {
                // Extracting the second digit from timeAsString
                int secondDigit = int.parse(timeAsString[1]);
                // Checking if the second digit is not equal to 7
                if (secondDigit != 6 && secondDigit != 7 && secondDigit != 8 &&  secondDigit != 9) {
                  exerciseSet.isCompleted = !exerciseSet.isCompleted;
                }
              }
              else if (timeAsString.length == 4) {
                // Extracting the second digit from timeAsString
                int thirdDigit = int.parse(timeAsString[2]);
                int firstDigit = int.parse(timeAsString[0]);
                // Checking if the second digit is not equal to 7
                if (thirdDigit != 6 && thirdDigit != 7 && thirdDigit != 8 &&  thirdDigit != 9) {
                  if (firstDigit != 6 && firstDigit != 7 && firstDigit != 8 &&  firstDigit != 9) {
                    exerciseSet.isCompleted = !exerciseSet.isCompleted;
                  }
                }
              }

              else if (timeAsString.length == 5) {
                // Extracting the second digit from timeAsString
                int secondDigit = int.parse(timeAsString[1]);
                int fourthDigit = int.parse(timeAsString[3]);
                // Checking if the second digit is not equal to 7
                if (secondDigit != 6 && secondDigit != 7 && secondDigit != 8 &&  secondDigit != 9) {
                  if (fourthDigit != 6 && fourthDigit != 7 && fourthDigit != 8 &&  fourthDigit != 9) {
                    exerciseSet.isCompleted = !exerciseSet.isCompleted;
                  }
                }
              }
            }
          }


          else if (exerciseSet.reps != null && exerciseSet.weight != null) {
            exerciseSet.isCompleted = !exerciseSet.isCompleted;
          }






          // if (exerciseSet.reps != null && exerciseSet.weight != null) {
          //   exerciseSet.isCompleted = !exerciseSet.isCompleted;
          // }

          if (exerciseSet.isCompleted && restTimerProvider.isRestTimerEnabled) {
            //check if the custom timer is running, if yes, stop the custom timer first
            //to prevent 2 timers run at same time
            if (customTimerProvider.isRestTimerRunning) {
              customTimerProvider.stopCustomTimer();
            }
            if (restTimerProvider.isRestTimerRunning) {
              // Stop the existing rest timer if second set is completed
              restTimerProvider.stopRestTimer();
            }
            restTimerProvider.startRestTimer(context);
            displayRestTimer = true;
            showRestTimerDetailsDialog(context);
          } else {
            restTimerProvider.stopRestTimer();
            displayRestTimer = false;
          }
        });
      }
    });
  }

  void showRestTimerDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestTimerDialog(
          restTimerProvider: restTimerProvider,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.exercisesSetsInfo.length + 1,
        itemBuilder: (context, index) {
          if (widget.exercisesSetsInfo.isEmpty) {
            return Column(
              children: [
                const WorkoutHeader(),
                AddExerciseButton(
                  selectExercise: widget.selectExercise,
                ),
                CancelWorkoutButton(
                  timerProvider: widget.timerProvider,
                ),
              ],
            );
          }
          if (index == 0) {
            ExercisesSetsInfo selectedExercise =
                widget.exercisesSetsInfo[index];
            return Column(children: [
              const WorkoutHeader(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        selectedExercise.exercise.target!.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE1F0CF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SetTiles(
                      exercisesSetsInfo: selectedExercise,
                      removeSet: widget.removeSet,
                      addSet: addSet,
                      setIsCompleted: setIsCompleted,
                      isCurrentEditing: false,

                    )
                  ],
                ),
              ),
            ]);
          }
          if (index == widget.exercisesSetsInfo.length) {
            return Column(children: [
              AddExerciseButton(
                selectExercise: widget.selectExercise,
              ),
              CancelWorkoutButton(
                timerProvider: widget.timerProvider,
              ),
            ]);
          } else {
            ExercisesSetsInfo selectedExercise =
                widget.exercisesSetsInfo[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      selectedExercise.exercise.target!.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE1F0CF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SetTiles(
                    exercisesSetsInfo: selectedExercise,
                    removeSet: widget.removeSet,
                    addSet: addSet,
                    setIsCompleted: setIsCompleted,
                    isCurrentEditing: false,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
