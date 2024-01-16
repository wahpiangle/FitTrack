import 'package:flutter/material.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';
import '../../../models/body_part.dart';
import '../../../models/category.dart';

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context) {
    String? customWorkoutName;
    String? selectedBodyPart;
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A),
          title: (selectedBodyPart == null && selectedCategory == null)
              ? Text(
            'Custom Exercise',
            style: TextStyle(color: Colors.white),
          )
              : null,
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFF1A1A1A),
                    border: Border.all(color: Color(0xFF1A1A1A)),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      customWorkoutName = value;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'add name...',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                DropdownButtonFormField<String>(
                  value: selectedBodyPart,
                  onChanged: (String? newValue) {
                    selectedBodyPart = newValue;
                  },
                  items: bodyPartData.map<DropdownMenuItem<String>>((BodyPart bodyPart) {
                    return DropdownMenuItem<String>(
                      value: bodyPart.name,
                      child: Text(
                        bodyPart.name,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Body Part',
                    labelStyle: TextStyle(color: Colors.white),
                    isDense: true,
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  dropdownColor: Color(0xFF1A1A1A),
                ),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    selectedCategory = newValue;
                  },
                  items: categoryData.map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(
                        category.name,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    labelStyle: TextStyle(color: Colors.white),
                    isDense: false,
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  dropdownColor: Color(0xFF1A1A1A),
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                String selectedBodyPartText =
                selectedBodyPart != null ? 'Selected Body Part: $selectedBodyPart' : 'No Body Part Selected';
                String selectedCategoryText =
                selectedCategory != null ? 'Selected Category: $selectedCategory' : 'No Category Selected';
                String customWorkoutNameText =
                customWorkoutName != null ? 'Custom Workout Name: $customWorkoutName' : 'No Workout Name Entered';

                print(selectedBodyPartText);
                print(selectedCategoryText);
                print(customWorkoutNameText);

                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
