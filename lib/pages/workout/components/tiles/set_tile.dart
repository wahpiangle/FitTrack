import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';

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

class _SetTileState extends State<SetTile> {
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
                  initialValue: "${widget.set.weight ?? ''}",
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
                  onChanged: (value) => {
                    widget.set.weight = int.tryParse(value),
                    if (widget.set.weight == null)
                      {
                        widget.set.isCompleted = false,
                      },
                    objectBox.exerciseService.updateExerciseSet(widget.set),
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
                  initialValue: "${widget.set.reps ?? ''}",
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
                  onChanged: (value) => {
                    widget.set.reps = int.tryParse(value),
                    if (widget.set.reps == null)
                      {
                        widget.set.isCompleted = false,
                      },
                    objectBox.exerciseService.updateExerciseSet(widget.set),
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
