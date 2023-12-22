import 'package:flutter/material.dart';
import 'package:group_project/pages/exercise/exercise_filter_page.dart';

Widget generateItems(List data, bool isBodyPart, bool isCategory, ExerciseFilterPageState state) {
  if (isBodyPart) {
    return Wrap(
      spacing: 12,
      runSpacing: 20,
      children: data.map((bodyPart) {
        final isFilterSelected = state.selectedBodyPart == bodyPart.name;
        return generateColoredBorderItem(
          isFilterSelected,
          const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
          18,
          bodyPart.name,
              () {
            state.setState(() {
              if (isFilterSelected) {
                state.selectedBodyPart = ''; // Update local state
                state.widget.setBodyPart('');
              } else {
                state.selectedBodyPart = bodyPart.name; // Update local state
                state.widget.setBodyPart(bodyPart.name);
              }
            });
          },
        );
      }).toList(),
    );
  } else if (isCategory) {
    return Wrap(
      spacing: 12,
      runSpacing: 20,
      children: data.map((category) {
        final isFilterSelected = state.selectedCategories.contains(category.name);
        return generateColoredBorderItem(
          isFilterSelected,
          const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
          18,
          category.name,
              () {
            state.setState(() {
              if (isFilterSelected) {
                state.widget.removeCategory(category.name);
              } else {
                state.widget.addCategory(category.name);
              }
            });
          },
        );
      }).toList(),
    );
  } else {
    return Container();
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


