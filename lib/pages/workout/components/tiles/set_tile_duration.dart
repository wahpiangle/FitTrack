import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/recent_values.dart';
import 'dart:math' as math;

class SetTileDuration extends StatefulWidget {
  final ExerciseSet set;
  final int setIndex;
  final ExercisesSetsInfo exercisesSetsInfo;
  final void Function(int exerciseSetId) removeSet;
  final void Function(ExercisesSetsInfo exercisesSetsInfo) addSet;
  final void Function(int exerciseSetId)? setIsCompleted;
  final bool isCurrentEditing;

  const SetTileDuration({
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
  State<SetTileDuration> createState() => _SetTileDurationState();
}

class _SetTileDurationState extends State<SetTileDuration> {
  int? recentTime;
  late TextEditingController timeController;
  bool isTapped = false;
  late String originalTime;

  @override
  void initState() {
    super.initState();
    fetchRecentWeightAndTime();
    timeController = TextEditingController();
    originalTime =
        widget.set.time != null ? _secondsToTimeString(widget.set.time!) : '';
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  void fetchRecentWeightAndTime() {
    final exercisesSetsInfo = widget.set.exerciseSetInfo.target;
    if (exercisesSetsInfo != null) {
      final exercise = exercisesSetsInfo.exercise.target;
      if (exercise != null) {
        final recentTimeFromDB = objectBox.exerciseService
            .getRecentTime(exercise.id, widget.setIndex);
        setState(() {
          recentTime = recentTimeFromDB;
        });
      }
    }
  }

  void onTapPreviousTab(
      ExercisesSetsInfo exercisesSetsInfo, AnimationController controller) {
    if (!widget.isCurrentEditing) {
      timeController.text = recentTime?.toString() ?? '';
      setState(() {
        widget.set.time = recentTime;
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
              recentTime: recentTime,
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  initialValue: isTapped ? null : originalTime,
                  controller: isTapped ? timeController : null,
                  inputFormatters: [
                    TimeTextInputFormatter(),
                  ],
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "0:00",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isTapped = false;
                      widget.set.time = _timeStringToSeconds(value);
                      if (widget.set.time == null) {
                        widget.set.isCompleted = false;
                      }
                      objectBox.exerciseService.updateExerciseSet(widget.set);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                          )),
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

  String _secondsToTimeString(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.padLeft(8, "0");
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp(r'^[0-9:]+$');
  TimeTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = "${value.substring(6, 7)}:${value.substring(7)}";
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk =
              "${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7)}";
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk =
              "${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7, 8)}${value.substring(8)}";
        } else {
          leftChunk = '';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7)}";
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}";
        } else {
          leftChunk = '';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7)}";
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk =
              "${value.substring(0, 1)}:${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}";
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}

int? _timeStringToSeconds(String timeString) {
  List<String> parts = timeString.split(':');
  if (parts.length == 2) {
    // If it's in the format "mm:ss"
    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  } else if (parts.length == 3) {
    // If it's in the format "hh:mm:ss"
    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1]) ?? 0;
    int seconds = int.tryParse(parts[2]) ?? 0;
    return hours * 3600 + minutes * 60 + seconds;
  } else {
    return int.tryParse(parts[0]);
  }
}
