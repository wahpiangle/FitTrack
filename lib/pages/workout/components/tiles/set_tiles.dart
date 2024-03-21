import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercises_sets_info.dart';
import 'package:group_project/pages/workout/components/tiles/set_labels.dart';
import 'package:group_project/pages/workout/components/tiles/set_tile.dart';

class SetTiles extends StatefulWidget {
  final ExercisesSetsInfo exercisesSetsInfo;
  final void Function(int exerciseSetId) removeSet;
  final void Function(ExercisesSetsInfo exercisesSetsInfo) addSet;
  final void Function(int exerciseSetId)? setIsCompleted;
  final bool isEditing;

  const SetTiles({
    super.key,
    required this.exercisesSetsInfo,
    required this.removeSet,
    required this.addSet,
    this.setIsCompleted,
    required this.isEditing,
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
            itemBuilder: (context, index) {
              int setIndex = index;
              ExerciseSet set = widget.exercisesSetsInfo.exerciseSets[setIndex];
              if (index == 0) {
                return Column(
                  children: [
                    SetLabels(
                      setIsCompleted: widget.setIsCompleted,
                    ),
                    SetTile(
                      set: set,
                      setIndex: setIndex,
                      exercisesSetsInfo: widget.exercisesSetsInfo,
                      removeSet: widget.removeSet,
                      addSet: widget.addSet,
                      setIsCompleted: widget.setIsCompleted,
                      isEditing: widget.isEditing,
                    )
                  ],
                );
              }
              return SetTile(
                set: set,
                setIndex: setIndex,
                exercisesSetsInfo: widget.exercisesSetsInfo,
                removeSet: widget.removeSet,
                addSet: widget.addSet,
                setIsCompleted: widget.setIsCompleted,
                isEditing: widget.isEditing,

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
                  MaterialStateProperty.all<Color>(AppColours.primaryBright),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
