import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/set_tile_components/recent_values.dart';

class SetTileDurationn extends StatefulWidget {
  final ExerciseSet set;
  final int setIndex;
  final ExercisesSetsInfo exercisesSetsInfo;
  final void Function(int exerciseSetId) removeSet;
  final void Function(ExercisesSetsInfo exercisesSetsInfo) addSet;
  final void Function(int exerciseSetId)? setIsCompleted;
  final bool isCurrentEditing;

  const SetTileDurationn({
    super.key,
    required this.set,
    required this.setIndex,
    required this.exercisesSetsInfo,
    required this.removeSet,
    required this.addSet,
    this.setIsCompleted,
    required this.isCurrentEditing,
  });

  @override
  State<SetTileDurationn> createState() => _SetTileDurationnState();
}

class _SetTileDurationnState extends State<SetTileDurationn> {
  int? recentWeight;
  int? recentReps;
  int? recentTime;
  String? recentDuration;
  late TextEditingController weightController;
  late TextEditingController repsController;
  late TextEditingController timeController;
  late TextEditingController durationController;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    fetchRecentWeightAndTime();
    weightController = TextEditingController();
    timeController = TextEditingController();

    durationController = TextEditingController();
  }

  @override
  void dispose() {
    weightController.dispose();
    timeController.dispose();

    durationController.dispose();
    super.dispose();
  }

  void fetchRecentWeightAndTime() {
    final exercisesSetsInfo = widget.set.exerciseSetInfo.target;
    if (exercisesSetsInfo != null) {
      final exercise = exercisesSetsInfo.exercise.target;
      if (exercise != null) {
        final recentWeight = objectBox.exerciseService
            .getRecentWeight(exercise.id, widget.setIndex);
        final recentReps = objectBox.exerciseService
            .getRecentReps(exercise.id, widget.setIndex);
        final recentTime = objectBox.exerciseService
            .getRecentTime(exercise.id, widget.setIndex);

        final recentDuration = objectBox.exerciseService
            .getRecentDuration(exercise.id, widget.setIndex);

        setState(() {
          this.recentWeight = recentWeight;
          this.recentReps = recentReps;
          this.recentTime = recentTime;
          this.recentDuration = recentDuration;
        });
      }
    }
  }

  void onTapPreviousTab(
      ExercisesSetsInfo exercisesSetsInfo, AnimationController controller) {
    if (!widget.isCurrentEditing) {
      weightController.text = recentWeight?.toString() ?? '';
      repsController.text = recentReps?.toString() ?? '';
      timeController.text = recentTime?.toString() ?? '';
      durationController.text = recentDuration?.toString() ?? '';

      setState(() {
        widget.set.weight = recentWeight;
        widget.set.reps = recentReps;
        widget.set.time = recentTime;

        widget.set.duration = recentDuration;
        isTapped = true;
      });
      objectBox.exerciseService.updateExerciseSet(widget.set);
      controller.forward(from: 0.0);
    }
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
            RecentValues(
                isCurrentEditing: widget.isCurrentEditing,
                exercisesSetsInfo: widget.exercisesSetsInfo,
                isTapped: isTapped,
                onTapPreviousTab: onTapPreviousTab,
                recentWeight: recentWeight,
                recentReps: recentReps,
                recentTime: recentTime,
                recentDuration: recentDuration),
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
                  keyboardType: TextInputType.number,
                  initialValue: isTapped ? null : "${widget.set.duration ?? ''}",
                  controller: isTapped ? durationController : null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "0:00",
                    hintStyle: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isTapped = false;
                      widget.set.duration = value;
                      if (widget.set.duration == null
                          || widget.set.duration.toString().length < 4
                          || widget.set.duration.toString().length > 7
                          || widget.set.duration.toString().length == 6) {
                        widget.set.isCompleted = false;
                      }
                      else if (widget.set.duration.toString().length == 4) {
                        if ([':'].contains(value[0])
                            || [':'].contains(value[2])
                            || [':'].contains(value[3])
                            || ![':'].contains(value[1])) { //return false if string is not in M:SS format
                          widget.set.isCompleted = false;
                        }
                      }
                      else if (widget.set.duration.toString().length == 5 ) {
                        if ( [':'].contains(value[0])
                            || [':'].contains(value[1])
                            || [':'].contains(value[3])
                            || [':'].contains(value[4])
                            || ![':'].contains(value[2])) { //return false if string is not in MM:SS format
                          widget.set.isCompleted = false;
                        }
                      }
                      else if (widget.set.duration.toString().length == 7 ) {
                        if ( [':'].contains(value[0])
                            || [':'].contains(value[2])
                            || [':'].contains(value[3])
                            || [':'].contains(value[5])
                            || [':'].contains(value[6])
                            || ![':'].contains(value[1])
                            || ![':'].contains(value[4])) { //return false if string is not in H:MM:SS format
                          widget.set.isCompleted = false;
                        }
                      }
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
                    onTap: () {
                      widget.setIsCompleted!(widget.set.id);
                    },
                    child: const Padding(
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
