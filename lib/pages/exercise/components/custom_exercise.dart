import 'package:flutter/material.dart';

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context) {
    String? selectedBodyPart;
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Body Part and Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your body part selection widget here
                DropdownButtonFormField<String>(
                  value: selectedBodyPart,
                  onChanged: (String? newValue) {
                    // Update the selected body part
                    selectedBodyPart = newValue;
                  },
                  items: <String>[
                    'Body Part 1',
                    'Body Part 2',
                    'Body Part 3',
                    // Add more body parts as needed
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Body Part',
                    isDense: true, // Keep the title from being minimized
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),

                // Add your category selection widget here
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    // Update the selected category
                    selectedCategory = newValue;
                  },
                  items: <String>[
                    'Category 1',
                    'Category 2',
                    'Category 3',
                    // Add more categories as needed
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    isDense: true, // Keep the title from being minimized
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
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
                String selectedBodyPartText =
                selectedBodyPart != null ? 'Selected Body Part: $selectedBodyPart' : 'No Body Part Selected';
                String selectedCategoryText =
                selectedCategory != null ? 'Selected Category: $selectedCategory' : 'No Category Selected';

                print(selectedBodyPartText);
                print(selectedCategoryText);

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
