import 'package:flutter/material.dart';
import 'package:group_project/pages/exercise/exercise_filter_page.dart';

class ExerciseFilterWidgets extends StatelessWidget {
  final List data;
  final bool isBodyPart;
  final bool isCategory;
  final ExerciseFilterPageState state;

  const ExerciseFilterWidgets(
      {super.key,
      required this.data,
      required this.isBodyPart,
      required this.isCategory,
      required this.state});

  @override
  Widget build(BuildContext context) {
    if (isBodyPart) {
      return Wrap(
        spacing: 12,
        runSpacing: 20,
        children: data.map((bodyPart) {
          final isFilterSelected = state.selectedBodyPart == bodyPart.name;
          return generateColoredBorderItem(
            isFilterSelected,
            const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
            14,
            bodyPart.name,
            () {
              state.changeExerciseState(bodyPart.name);
            },
          );
        }).toList(),
      );
    } else if (isCategory) {
      return Wrap(
        spacing: 12,
        runSpacing: 20,
        children: data.map((category) {
          final isFilterSelected =
              state.selectedCategories.contains(category.name);
          return generateColoredBorderItem(
            isFilterSelected,
            const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
            14,
            category.name,
            () {
              state.changeCategoryState(category.name);
            },
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }
}

Widget generateColoredBorderItem(
  bool isFilterSelected,
  Color selectedColor,
  double fontSize,
  String text,
  Function() onTap,
) {
  return FittedBox(
    fit: BoxFit.fitWidth,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: isFilterSelected
            ? selectedColor
            : const Color.fromARGB(255, 46, 46, 46),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(
              text,
              style: TextStyle(
                color: isFilterSelected ? Colors.black : Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
