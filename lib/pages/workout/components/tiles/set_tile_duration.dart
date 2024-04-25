import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/recent_values.dart';

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
  int? recentWeight;
  int? recentReps;
  int? recentTime;
  late TextEditingController weightController;
  late TextEditingController repsController;
  late TextEditingController timeController;
  bool isTapped = false;
  late String originalTime;

  @override
  void initState() {
    super.initState();
    fetchRecentWeightAndTime();
    weightController = TextEditingController();
    timeController = TextEditingController();
    originalTime =
        widget.set.time != null ? _secondsToTimeString(widget.set.time!) : '';
  }

  @override
  void dispose() {
    weightController.dispose();
    timeController.dispose();
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
        setState(() {
          this.recentWeight = recentWeight;
          this.recentReps = recentReps;
          this.recentTime = recentTime;
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
      setState(() {
        widget.set.weight = recentWeight;
        widget.set.reps = recentReps;
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
                recentWeight: recentWeight,
                recentReps: recentReps,
                recentTime: recentTime),
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
                  initialValue: isTapped ? null : originalTime,
                  controller: isTapped ? timeController : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d{0,4}(:\d{0,4})?$')),
                    CustomTimeInputFormatter(),
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
                      // Convert the formatted time string into seconds
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

class CustomTimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    // Check if a character is deleted
    if (newText.length < oldText.length) {
      return TextEditingValue.empty;
    }

    if (newText.length == 1) {
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else if (newText.length == 2) {
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else if (oldText.length == 2) {
      // If 3 digits are typed, insert ":" between the second and third digits
      final updatedText = "${newText.substring(0, 1)}:${newText.substring(1)}";
      return TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    } else if (oldText.length == 3) {
      // If 4 digits are typed, insert ":" between the second and third digits
      final updatedText = "${newText.substring(0, 2)}:${newText.substring(2)}";
      return TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    } else if (oldText.length == 4) {
      // If 5 digits are typed, append the fifth digit after the colon
      final updatedText =
          "${newText.substring(0, 1)}${newText.substring(2, 3)}:${newText.substring(3, 5)}";
      return TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    } else if (oldText.length == 5) {
      // If 5 digits are typed, append the fifth digit after the colon
      final updatedText =
          "${newText.substring(0, 1)}:${newText.substring(1, 2)}${newText.substring(3, 4)}:${newText.substring(4, 6)}";
      return TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    }
    return newValue;
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
  }
  return null;
}
