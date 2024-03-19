import 'dart:ui';

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
    // weightController = TextEditingController(text: widget.set.weight?.toString() ?? '');
    // repsController = TextEditingController(text: widget.set.reps?.toString() ?? '');
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
      print('hi');
      final exercise = exercisesSetsInfo.exercise.target;
      if (exercise != null) {
        print('hi 2');
        final recentWeight = await objectBox.exerciseService.getRecentWeight(exercise.id, widget.setIndex);
        print('$recentWeight in fetchRecentWeightAndReps');
        final recentReps = await objectBox.exerciseService.getRecentReps(exercise.id, widget.setIndex);
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
          isTapped = false;
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
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  onTapPreviousTab(widget.exercisesSetsInfo);
                  _controller.forward(from: 0.0);
                  setState(() {
                    isTapped = true;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    setState(() {
                      isTapped = false;
                    });
                  });
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        CurveTween(curve: const SineCurve())
                                .transform(_controller.value) *
                            shakeOffset,
                        0.0,
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      recentWeight != null ? '${this.recentWeight}kg x ${this.recentReps}' : '-',
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isTapped ? Colors.grey : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                  initialValue: isTapped ?  null: "${widget.set.weight ?? ''}",
                  controller: isTapped ? weightController : null,
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
                      if (widget.set.weight == null)
                      {
                        widget.set.isCompleted = false,
                      },
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
                  initialValue: isTapped ?  null: "${widget.set.reps ?? ''}",
                  controller: isTapped ? repsController : null,
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
                      if (widget.set.reps == null)
                      {
                        widget.set.isCompleted = false,
                      },
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

                          // Get the associated ExercisesSetsInfo
                          final exercisesSetsInfo =
                              widget.set.exerciseSetInfo.target;

                          // Update the recent weight and reps for the associated Exercise
                          if (exercisesSetsInfo != null) {
                            final exercise = exercisesSetsInfo.exercise.target;
                            if (exercise != null) {
                              // Call method to update recent weight and reps for the Exercise
                                objectBox.exerciseService
                                    .updateRecentWeightAndReps(
                                  widget.set,
                                  widget.set.weight!,
                                  widget.set.reps!,
                                );

                                // Update the state after updating recentWeight and recentReps
                                // setState(() {
                                //   recentWeight = widget.set.recentWeight;
                                //   recentReps = widget.set.recentReps;
                                // });
                              }
                            }
                            widget.setIsCompleted!(widget.set.id);
                          },
                          child:
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          )
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
