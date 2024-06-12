import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/set_labels.dart';
import 'package:group_project/pages/workout/components/tiles/set_tile.dart';
import 'package:group_project/pages/workout/components/tiles/set_tile_duration.dart';
import 'package:group_project/pages/workout/components/tiles/set_tile_repsonly.dart';

class SetTiles extends StatefulWidget {
  final ExercisesSetsInfo exercisesSetsInfo;
  final void Function(int exerciseSetId) removeSet;
  final void Function(ExercisesSetsInfo exercisesSetsInfo) addSet;
  final void Function(int exerciseSetId)? setIsCompleted;
  final bool isCurrentEditing;

  const SetTiles({
    super.key,
    required this.exercisesSetsInfo,
    required this.removeSet,
    required this.addSet,
    this.setIsCompleted,
    required this.isCurrentEditing,
  });

  @override
  State<SetTiles> createState() => _SetTilesState();
}

class _SetTilesState extends State<SetTiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollConfiguration(
          behavior: NoGlowBehaviour(),
          child: ListView.builder(
            itemCount: widget.exercisesSetsInfo.exerciseSets.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              int setIndex = index;
              ExerciseSet set = widget.exercisesSetsInfo.exerciseSets[setIndex];
              String categoryName = widget.exercisesSetsInfo.exercise.target
                      ?.category.target?.name ??
                  "";
              if (index == 0) {
                return Column(
                  children: [
                    SetLabels(
                      categoryName: categoryName,
                      setIsCompleted: widget.setIsCompleted,
                    ),
                    buildSetTile(
                      categoryName,
                      set,
                      setIndex,
                      widget.exercisesSetsInfo,
                      widget.removeSet,
                      widget.addSet,
                      widget.setIsCompleted,
                      widget.isCurrentEditing,
                    ),
                  ],
                );
              }
              return buildSetTile(
                categoryName,
                set,
                setIndex,
                widget.exercisesSetsInfo,
                widget.removeSet,
                widget.addSet,
                widget.setIsCompleted,
                widget.isCurrentEditing,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColours.primaryBright),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            onPressed: () {
              widget.addSet(widget.exercisesSetsInfo);
            },
            child: const Center(
              child: Text(
                "Add Set",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildSetTile(
  String categoryName,
  ExerciseSet set,
  int setIndex,
  ExercisesSetsInfo exercisesSetsInfo,
  void Function(int exerciseSetId) removeSet,
  void Function(ExercisesSetsInfo exercisesSetsInfo) addSet,
  void Function(int exerciseSetId)? setIsCompleted,
  bool isCurrentEditing,
) {
  if (categoryName == "Reps Only") {
    return SetTileRepsOnly(
      set: set,
      setIndex: setIndex,
      exercisesSetsInfo: exercisesSetsInfo,
      removeSet: removeSet,
      addSet: addSet,
      setIsCompleted: setIsCompleted,
      isCurrentEditing: isCurrentEditing,
    );
  } else if (categoryName == "Duration") {
    return SetTileDuration(
      set: set,
      setIndex: setIndex,
      exercisesSetsInfo: exercisesSetsInfo,
      removeSet: removeSet,
      addSet: addSet,
      setIsCompleted: setIsCompleted,
      isCurrentEditing: isCurrentEditing,
    );
  } else {
    return SetTile(
      set: set,
      setIndex: setIndex,
      exercisesSetsInfo: exercisesSetsInfo,
      removeSet: removeSet,
      addSet: addSet,
      setIsCompleted: setIsCompleted,
      isCurrentEditing: isCurrentEditing,
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
