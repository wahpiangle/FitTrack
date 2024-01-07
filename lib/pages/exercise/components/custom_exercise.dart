import 'package:flutter/material.dart';

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Body Part and Category'),
          content: Column(
            children: [
              // Add your body part and category selection widgets here
              // Example: DropdownButtonFormField, CheckboxListTile, etc.
              // Use the selected values to perform the desired action.
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add logic to handle the selected body part and category
                // Perform the desired action based on user selections
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
