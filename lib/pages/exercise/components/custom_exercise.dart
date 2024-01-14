import 'package:flutter/material.dart';
import 'exercise_filter_widgets.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';
import 'package:group_project/pages/exercise/exercise_filter_page.dart';

class FilterDialog extends StatelessWidget {
  final bool isBodyPart;
  final void Function(String) onSelect;

  FilterDialog({
    required this.isBodyPart,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = isBodyPart ? bodyPartData : categoryData;

    return AlertDialog(
      title: Text(isBodyPart ? 'Select Body Part' : 'Select Category'),
      content: ExerciseFilterWidgets(
        data: data,
        isBodyPart: isBodyPart,
        isCategory: !isBodyPart,
        state: ExerciseFilterPageState(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context) {
    TextEditingController workoutNameController = TextEditingController();
    String selectedCategory = '';
    String selectedBodyPart = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Custom workout'),
          content: Container(
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              maxWidth: 300.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: workoutNameController,
                  decoration: InputDecoration(labelText: 'Workout Name'),
                ),
                SizedBox(height: 16.0),
                // Category selection button
                generateCategoryButton(
                  context,
                  selectedCategory,
                      () {
                    _showFilterSelectionDialog(
                      context,
                      isBodyPart: false,
                      onSelect: (category) {
                        selectedCategory = category;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                SizedBox(height: 16.0),
                // Body part selection button
                generateBodyPartButton(
                  context,
                  selectedBodyPart,
                      () {
                    _showFilterSelectionDialog(
                      context,
                      isBodyPart: true,
                      onSelect: (bodyPart) {
                        selectedBodyPart = bodyPart;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String workoutName = workoutNameController.text;
                print('Entered Workout Name: $workoutName');
                print('Selected Category: $selectedCategory');
                print('Selected Body Part: $selectedBodyPart');
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  static void _showFilterSelectionDialog(
      BuildContext context, {
        required bool isBodyPart,
        required void Function(String) onSelect,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          isBodyPart: isBodyPart,
          onSelect: onSelect,
        );
      },
    );
  }

  static Widget generateCategoryButton(
      BuildContext context,
      String selectedCategory,
      Function() onTap,
      ) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: const Color(0xFFE1F0CF),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.0),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                selectedCategory.isNotEmpty
                    ? 'Selected Category: $selectedCategory'
                    : 'Select Category',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget generateBodyPartButton(
      BuildContext context,
      String selectedBodyPart,
      Function() onTap,
      ) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: const Color(0xFFE1F0CF),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.0),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                selectedBodyPart.isNotEmpty
                    ? 'Selected Body Part: $selectedBodyPart'
                    : 'Select Body Part',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
