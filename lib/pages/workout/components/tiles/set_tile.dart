
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'dart:math';


class SetTile extends StatefulWidget {
  final ExerciseSet set;
  final int setIndex;
  final ExercisesSetsInfo exercisesSetsInfo;
  final void Function(int exerciseSetId) removeSet;
  final void Function(ExercisesSetsInfo exercisesSetsInfo) addSet;
  final void Function(int exerciseSetId)? setIsCompleted;

  const SetTile({
    super.key,
    required this.set,
    required this.setIndex,
    required this.exercisesSetsInfo,
    required this.removeSet,
    required this.addSet,
    this.setIsCompleted,
  });

  @override
  State<SetTile> createState() => _SetTileState();
}

class _SetTileState extends State<SetTile> with TickerProviderStateMixin {
  int? recentWeight;
  int? recentReps;
  late TextEditingController weightController;
  late TextEditingController repsController;
  bool isTapped = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  double shakeOffset = 1.0;



  @override
  void initState() {
    super.initState();
    fetchRecentWeightAndReps();
    weightController = TextEditingController();
    repsController = TextEditingController();
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }


  Future<void> fetchRecentWeightAndReps() async {
    final exercisesSetsInfo = widget.set.exerciseSetInfo.target;
    if (exercisesSetsInfo != null) {
      final exercise = exercisesSetsInfo.exercise.target;
      if (exercise != null) {
        final recentWeight = objectBox.exerciseService.getRecentWeight(exercise.name, widget.setIndex);
        final recentReps = objectBox.exerciseService.getRecentReps(exercise.name, widget.setIndex);
        setState(() {
          this.recentWeight = recentWeight;
          this.recentReps = recentReps;

        });
      } else {
        print('Exercise associated with the exercise set is null.');
      }
    } else {
      print('ExerciseSetsInfo associated with the exercise set is null.');
    }
  }



  void onTapPreviousTab(ExercisesSetsInfo exercisesSetsInfo) {
    weightController.text = recentWeight?.toString() ?? '';
    repsController.text = recentReps?.toString() ?? '';

    setState(() {
      widget.set.weight = recentWeight;
      widget.set.reps = recentReps;
    });

    // Update the weight and reps for exercise set
    objectBox.exerciseService.updateExerciseSet(widget.set);
  }


  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: Key(widget.set.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.removeSet(widget.set.id);
        setState(() {
          widget.exercisesSetsInfo.exerciseSets
              .removeWhere((element) => element.id == widget.set.id);
        });
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        color: widget.setIsCompleted != null
            ? widget.set.isCompleted
                ? Colors.green[300]
                : Colors.transparent
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                textAlign: TextAlign.center,
                "${widget.setIndex + 1}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  onTapPreviousTab(widget.exercisesSetsInfo);
                  _controller.forward(from: 0.0);

                  setState(() {
                    isTapped = true;
                  });
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        // Use CurveTween with SineCurve
                        CurveTween(curve: SineCurve()).transform(_controller.value) * shakeOffset,
                        0.0,
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      recentWeight != null ? '${recentWeight}kg x $recentReps' : '-',
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isTapped ? Colors.grey : Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColours.primaryBright,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.set.weight = int.tryParse(value);
                      objectBox.exerciseService.updateExerciseSet(widget.set);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColours.primaryBright,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: repsController,
                  // initialValue: "${widget.set.reps ?? ''}",
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.set.reps = int.tryParse(value);
                      objectBox.exerciseService.updateExerciseSet(widget.set);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 40,
              child: widget.setIsCompleted != null
                  ? Material(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      color: widget.set.isCompleted
                          ? Colors.green[300]
                          : AppColours.primaryBright,
                      child: InkWell(
                        onTap: () async {
                          // Update recentWeight and recentReps
                          widget.set.recentWeight = widget.set.weight;
                          widget.set.recentReps = widget.set.reps;

                          // Get the associated ExercisesSetsInfo
                          final exercisesSetsInfo = await widget.set.exerciseSetInfo.target;

                          // Update the recent weight and reps for the associated Exercise
                          if (exercisesSetsInfo != null) {
                            final exercise = await exercisesSetsInfo.exercise.target;
                            if (exercise != null) {
                              // Call method to update recent weight and reps for the Exercise
                              try {
                                objectBox.exerciseService.updateRecentWeightAndReps(
                                  exercise.id,
                                  widget.set.recentWeight!,
                                  widget.set.recentReps!,
                                  widget.setIndex
                                );

                                // Update the state after updating recentWeight and recentReps
                                setState(() {
                                  recentWeight = widget.set.recentWeight;
                                  recentReps = widget.set.recentReps;
                                  print('Updated recentWeight and recentReps for Exercise ${exercise.name}');
                                  print('Recent weight is now $recentWeight for ${exercise.name}');
                                });
                              } catch (e) {
                                print('Error updating recentWeight and recentReps: $e');
                              }
                            }
                          }

                          widget.setIsCompleted!(widget.set.id);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: const Icon(
                        Icons.horizontal_rule_rounded,
                        color: Colors.white,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  const SineCurve({this.count = 3});
  final double count;

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}



