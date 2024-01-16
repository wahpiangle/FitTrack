import 'package:flutter/material.dart';

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context) {
    String? customWorkoutName;
    String? selectedBodyPart;
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A), // Set the background color
          title: (selectedBodyPart == null && selectedCategory == null)
              ? Text(
            'Custom Exercise',
            style: TextStyle(color: Colors.white),

          )
              : null,
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add a custom-styled TextField for custom workout name
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFF1A1A1A), // Set the background color
                    border: Border.all(color: Color(0xFF1A1A1A)), // Set the border color
                  ),
                  child: TextField(
                    onChanged: (value) {
                      customWorkoutName = value;
                    },
                    style: TextStyle(color: Colors.white), // Set text color to white
                    decoration: InputDecoration(
                      hintText: 'add name...', // Placeholder text
                      hintStyle: TextStyle(color: Colors.white), // Set hint text color
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 16.0), // Add space between "add name" and "select body part"

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
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white), // Set the text color to white
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Body Part',
                    labelStyle: TextStyle(color: Colors.white),
                    isDense: true, // Keep the title from being minimized
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  dropdownColor: Color(0xFF1A1A1A), // Set the background color of the dropdown list
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
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white), // Set the text color to white
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    labelStyle: TextStyle(color: Colors.white),
                    isDense: false, // Keep the title from being minimized
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  dropdownColor: Color(0xFF1A1A1A), // Set the background color of the dropdown list
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)), // Set the button text color to white
            ),
            TextButton(
              onPressed: () {
                // Add logic to handle the selected body part, category, and custom workout name
                // Perform the desired action based on user selections
                String selectedBodyPartText =
                selectedBodyPart != null ? 'Selected Body Part: $selectedBodyPart' : 'No Body Part Selected';
                String selectedCategoryText =
                selectedCategory != null ? 'Selected Category: $selectedCategory' : 'No Category Selected';
                String customWorkoutNameText =
                customWorkoutName != null ? 'Custom Workout Name: $customWorkoutName' : 'No Workout Name Entered';

                print(selectedBodyPartText);
                print(selectedCategoryText);
                print(customWorkoutNameText);

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save', style: TextStyle(color: Colors.white)), // Set the button text color to white
            ),
          ],
        );
      },
    );
  }
}
